@echo off
REM Launch the Obsidenc Tauri GUI in development mode
REM - Runs `cargo tauri dev` in the `gui` directory

setlocal

REM Change to the project root where this script resides
cd /d "%~dp0"

REM Ensure the GUI directory exists
if not exist "gui" (
    echo [run_gui] Error: gui directory not found next to run_gui.bat
    exit /b 1
)

echo [run_gui] Starting Tauri app (cargo tauri dev)...

REM Run Tauri directly in this console so no extra windows are spawned.
cd /d ".\gui"
cargo tauri dev

set EXIT_CODE=%ERRORLEVEL%
echo [run_gui] Tauri exited with code %EXIT_CODE%

endlocal & exit /b %EXIT_CODE%


