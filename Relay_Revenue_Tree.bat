@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  Relay Revenue Driver Tree - Portable Launcher
::  Drop this file anywhere and double-click to run.
:: ============================================================

title Relay Revenue Driver Tree

set "REPO_URL=https://github.com/wankyu4356/Model_visual.git"
set "BRANCH=claude/revenue-driver-tree-dokO9"
set "REPO_DIR=%~dp0Model_visual"
set "HTML_FILE=index.html"
set "HAS_ERROR=0"

echo.
echo  ========================================
echo    Relay Revenue Driver Tree - Launcher
echo  ========================================
echo.
echo  Bat location: %~dp0
echo  Target folder: %REPO_DIR%
echo.

:: ──────────────────────────────────────
:: STEP 1: Check Git
:: ──────────────────────────────────────
echo [STEP 1/4] Checking environment...

where git >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo.
    echo   [FAIL] Git is NOT installed.
    echo.
    echo   Please install Git first:
    echo   https://git-scm.com/downloads
    echo.
    echo   After installing, restart this script.
    echo.
    goto :DONE
)

for /f "tokens=*" %%v in ('git --version 2^>nul') do set "GIT_VER=%%v"
echo   [OK] !GIT_VER!
echo.

:: ──────────────────────────────────────
:: STEP 2: Clone or Pull
:: ──────────────────────────────────────
if exist "%REPO_DIR%\.git\HEAD" (
    echo [STEP 2/4] Repository found - pulling updates...
    pushd "%REPO_DIR%" || goto :CLONE_FRESH

    git fetch origin %BRANCH% 2>&1
    if !ERRORLEVEL! neq 0 (
        echo   [WARN] Fetch failed - trying with existing local copy...
        popd
        goto :CHECK_FILE
    )

    :: Ensure correct branch
    for /f "tokens=*" %%b in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set "CUR=%%b"
    if "!CUR!" neq "%BRANCH%" (
        echo   Switching branch: !CUR! to %BRANCH%
        git checkout %BRANCH% 2>&1 || git checkout -b %BRANCH% origin/%BRANCH% 2>&1
    )

    git pull origin %BRANCH% 2>&1
    if !ERRORLEVEL! equ 0 (
        echo   [OK] Updated to latest version.
    ) else (
        echo   [WARN] Pull failed - using existing version.
    )

    popd
    goto :CHECK_FILE
)

:CLONE_FRESH
echo [STEP 2/4] Cloning repository...
echo   URL: %REPO_URL%
echo   Branch: %BRANCH%
echo.

set "CLONE_OK=0"

:: Attempt 1
echo   Attempt 1/4...
git clone -b %BRANCH% "%REPO_URL%" "%REPO_DIR%" 2>&1
if !ERRORLEVEL! equ 0 ( set "CLONE_OK=1" & goto :CLONE_DONE )
echo   Failed. Retrying in 2 seconds...
ping -n 3 127.0.0.1 >nul

:: Attempt 2
echo   Attempt 2/4...
git clone -b %BRANCH% "%REPO_URL%" "%REPO_DIR%" 2>&1
if !ERRORLEVEL! equ 0 ( set "CLONE_OK=1" & goto :CLONE_DONE )
echo   Failed. Retrying in 4 seconds...
ping -n 5 127.0.0.1 >nul

:: Attempt 3
echo   Attempt 3/4...
git clone -b %BRANCH% "%REPO_URL%" "%REPO_DIR%" 2>&1
if !ERRORLEVEL! equ 0 ( set "CLONE_OK=1" & goto :CLONE_DONE )
echo   Failed. Retrying in 8 seconds...
ping -n 9 127.0.0.1 >nul

:: Attempt 4
echo   Attempt 4/4...
git clone -b %BRANCH% "%REPO_URL%" "%REPO_DIR%" 2>&1
if !ERRORLEVEL! equ 0 ( set "CLONE_OK=1" & goto :CLONE_DONE )

:CLONE_DONE
if !CLONE_OK! equ 0 (
    echo.
    echo   [FAIL] Could not clone repository.
    echo   Please check your internet connection and try again.
    echo.
    set "HAS_ERROR=1"
    goto :DONE
)
echo   [OK] Clone complete.
echo.

:: ──────────────────────────────────────
:: STEP 3: Verify HTML file
:: ──────────────────────────────────────
:CHECK_FILE
echo [STEP 3/4] Verifying files...

if not exist "%REPO_DIR%\%HTML_FILE%" (
    echo.
    echo   [FAIL] %HTML_FILE% not found in %REPO_DIR%
    echo   The repository may be corrupted. Delete the Model_visual
    echo   folder and run this script again.
    echo.
    set "HAS_ERROR=1"
    goto :DONE
)

for %%F in ("%REPO_DIR%\%HTML_FILE%") do set "FSIZE=%%~zF"
echo   [OK] %HTML_FILE% found (%FSIZE% bytes)
echo.

:: ──────────────────────────────────────
:: STEP 4: Open in browser
:: ──────────────────────────────────────
echo [STEP 4/4] Opening in browser...
start "" "%REPO_DIR%\%HTML_FILE%"
echo   [OK] Opened in default browser.
echo.

:: ──────────────────────────────────────
:: DONE
:: ──────────────────────────────────────
:DONE
echo.
echo  ========================================
if !HAS_ERROR! equ 1 (
    echo    Finished with errors. See above.
) else (
    echo    Done! You can close this window.
)
echo  ========================================
echo.
echo  Press any key to close...
pause >nul
exit /b 0
