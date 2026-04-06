@echo off
rem Relay Revenue Driver Tree - Portable Launcher

title Relay Revenue Driver Tree

set REPO_URL=https://github.com/wankyu4356/Model_visual.git
set BRANCH=claude/revenue-driver-tree-dokO9
set REPO_DIR=%~dp0Model_visual
set HTML_FILE=index.html

echo.
echo  ========================================
echo    Relay Revenue Driver Tree - Launcher
echo  ========================================
echo.

echo [STEP 1] Checking Git...
where git >NUL 2>NUL
if errorlevel 1 goto NO_GIT
echo   [OK] Git found.
echo.
goto STEP2

:NO_GIT
echo.
echo   [FAIL] Git is NOT installed.
echo   Download Git from https://git-scm.com/downloads
echo   Install it then run this script again.
echo.
goto DONE

:STEP2
if exist "%REPO_DIR%\.git\HEAD" goto DO_PULL
goto DO_CLONE

:DO_PULL
echo [STEP 2] Updating repository...
pushd "%REPO_DIR%"
if errorlevel 1 goto DO_CLONE
git fetch origin %BRANCH%
git checkout %BRANCH% >NUL 2>NUL
git pull origin %BRANCH%
popd
echo   [OK] Update complete.
echo.
goto STEP3

:DO_CLONE
echo [STEP 2] Cloning repository...
echo   This may take a moment...
echo.
if exist "%REPO_DIR%" rmdir /s /q "%REPO_DIR%" >NUL 2>NUL
git clone -b %BRANCH% %REPO_URL% "%REPO_DIR%"
if errorlevel 1 goto RETRY1
echo   [OK] Clone complete.
goto STEP3

:RETRY1
echo   Retry 2/4...
ping -n 3 127.0.0.1 >NUL
if exist "%REPO_DIR%" rmdir /s /q "%REPO_DIR%" >NUL 2>NUL
git clone -b %BRANCH% %REPO_URL% "%REPO_DIR%"
if errorlevel 1 goto RETRY2
echo   [OK] Clone complete.
goto STEP3

:RETRY2
echo   Retry 3/4...
ping -n 5 127.0.0.1 >NUL
if exist "%REPO_DIR%" rmdir /s /q "%REPO_DIR%" >NUL 2>NUL
git clone -b %BRANCH% %REPO_URL% "%REPO_DIR%"
if errorlevel 1 goto RETRY3
echo   [OK] Clone complete.
goto STEP3

:RETRY3
echo   Retry 4/4...
ping -n 9 127.0.0.1 >NUL
if exist "%REPO_DIR%" rmdir /s /q "%REPO_DIR%" >NUL 2>NUL
git clone -b %BRANCH% %REPO_URL% "%REPO_DIR%"
if errorlevel 1 goto CLONE_FAIL
echo   [OK] Clone complete.
goto STEP3

:CLONE_FAIL
echo.
echo   [FAIL] Could not clone. Check internet.
echo.
goto DONE

:STEP3
echo [STEP 3] Checking files...
if not exist "%REPO_DIR%\%HTML_FILE%" goto FILE_MISSING
echo   [OK] %HTML_FILE% found.
echo.
goto STEP4

:FILE_MISSING
echo.
echo   [FAIL] %HTML_FILE% not found.
echo   Delete Model_visual folder and try again.
echo.
goto DONE

:STEP4
echo [STEP 4] Opening browser...
start "" "%REPO_DIR%\%HTML_FILE%"
echo   [OK] Opened in default browser.
echo.

:DONE
echo.
echo  ========================================
echo    Press any key to close this window.
echo  ========================================
pause >NUL
