@echo off
REM Build script for abc-bitmap-converter
REM Sets up MSVC environment and builds the project
setlocal

set CONFIG=%~1
set PLATFORM=%~2
if "%CONFIG%"=="" set CONFIG=Debug
if "%PLATFORM%"=="" set PLATFORM=x64

REM Find Visual Studio using vswhere (installed with VS)
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
set "VCVARS="
set "MSBUILD="

if exist "%VSWHERE%" (
    for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -requires Microsoft.Component.MSBuild -property installationPath`) do (
        set "VS_PATH=%%i"
        if exist "%%i\VC\Auxiliary\Build\vcvars64.bat" set "VCVARS=%%i\VC\Auxiliary\Build\vcvars64.bat"
        if exist "%%i\MSBuild\Current\Bin\MSBuild.exe" set "MSBUILD=%%i\MSBuild\Current\Bin\MSBuild.exe"
    )
)

REM Fallback: try common VS 2022, 2019 and Build Tools paths
if "%VCVARS%"=="" (
    for %%V in (Community Professional Enterprise BuildTools) do (
        if exist "C:\Program Files\Microsoft Visual Studio\2022\%%V\VC\Auxiliary\Build\vcvars64.bat" (
            set "VCVARS=C:\Program Files\Microsoft Visual Studio\2022\%%V\VC\Auxiliary\Build\vcvars64.bat"
            set "MSBUILD=C:\Program Files\Microsoft Visual Studio\2022\%%V\MSBuild\Current\Bin\MSBuild.exe"
            goto :found
        )
    )
    for %%V in (Community Professional Enterprise BuildTools) do (
        if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\%%V\VC\Auxiliary\Build\vcvars64.bat" (
            set "VCVARS=C:\Program Files (x86)\Microsoft Visual Studio\2022\%%V\VC\Auxiliary\Build\vcvars64.bat"
            set "MSBUILD=C:\Program Files (x86)\Microsoft Visual Studio\2022\%%V\MSBuild\Current\Bin\MSBuild.exe"
            goto :found
        )
    )
    for %%V in (Community Professional Enterprise BuildTools) do (
        if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\%%V\VC\Auxiliary\Build\vcvars64.bat" (
            set "VCVARS=C:\Program Files (x86)\Microsoft Visual Studio\2019\%%V\VC\Auxiliary\Build\vcvars64.bat"
            set "MSBUILD=C:\Program Files (x86)\Microsoft Visual Studio\2019\%%V\MSBuild\Current\Bin\MSBuild.exe"
            goto :found
        )
    )
)
:found

if "%VCVARS%"=="" (
    echo ERROR: No se encontro Visual Studio 2019/2022.
    echo Instala Visual Studio con la carga "Desktop development with C++"
    echo desde Visual Studio Installer.
    exit /b 1
)

if not exist "%MSBUILD%" (
    echo ERROR: No se encontro MSBuild.exe
    exit /b 1
)

echo Configurando entorno MSVC...
call "%VCVARS%" >nul 2>&1

cd /d "%~dp0src"

if /i "%CONFIG%"=="Clean" (
    echo Limpiando proyecto...
    "%MSBUILD%" abc2.sln /t:Clean /p:Configuration=Debug /p:Platform=x64 /v:minimal
    "%MSBUILD%" abc2.sln /t:Clean /p:Configuration=Release /p:Platform=x64 /v:minimal
) else (
    echo Compilando: %CONFIG% ^| %PLATFORM%
    "%MSBUILD%" abc2.sln /p:Configuration=%CONFIG% /p:Platform=%PLATFORM% /m /v:minimal
)

if %ERRORLEVEL% neq 0 (
    if /i not "%CONFIG%"=="Clean" echo Compilacion fallida.
    exit /b 1
)

if /i not "%CONFIG%"=="Clean" echo Compilacion exitosa.
exit /b 0
