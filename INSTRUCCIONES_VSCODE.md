# Instrucciones para compilar y depurar abc-bitmap-converter desde VSCode

## Archivos de configuración creados

1. **`build.bat`** – Script de compilación que:
   - Busca Visual Studio automáticamente (vswhere o rutas comunes)
   - Configura el entorno MSVC (vcvars64)
   - Compila la solución con MSBuild

2. **`.vscode/tasks.json`** – Tareas de compilación:
   - **Build Debug (x64)** – Tarea por defecto (Ctrl+Shift+B)
   - **Build Release (x64)**
   - **Limpiar** – Limpia archivos compilados

3. **`.vscode/launch.json`** – Configuraciones de depuración:
   - **Depurar abc2 (Debug)** – Compila y depura con `cycle-op.png`
   - **Depurar abc2 (sin compilar)** – Depura el exe ya compilado
   - **Ejecutar abc2 (Release)** – Ejecuta la versión Release

4. **`.vscode/c_cpp_properties.json`** – Configuración de IntelliSense para C/C++

## Requisitos para compilar en Windows 11

Necesitas **Visual Studio 2022** (o 2019) con el workload de C++:

1. Instala Visual Studio 2022 desde: https://visualstudio.microsoft.com/
2. En el instalador, selecciona la carga de trabajo **"Desktop development with C++"**
3. Asegúrate de que incluya:
   - MSVC v143 (VS 2022) o v142 (VS 2019)
   - Windows 10/11 SDK
   - Herramientas de compilación C++ para x64/x86

**Nota:** Este proyecto usa **DirectX 11** (shaders HLSL compute) y toolset **v143**. Si usas VS 2019, puede ser necesario cambiar el `PlatformToolset` en el `.vcxproj` a `v142`.

## Uso desde VSCode

| Acción | Atajo |
|--------|-------|
| Compilar | **Ctrl+Shift+B** |
| Depurar (compila + ejecuta) | **F5** |
| Ejecutar sin depurar | **Ctrl+F5** |

## Si no tienes Visual Studio instalado

La compilación fallará si Visual Studio no está instalado. Instala **Visual Studio 2022 Community** (gratuito) con la carga "Desktop development with C++" y vuelve a intentar **Ctrl+Shift+B** desde VSCode.

## Rutas de salida

- **Debug**: `src/x64/Debug/abc2.exe`
- **Release**: `abc2.exe` (raíz del proyecto)
