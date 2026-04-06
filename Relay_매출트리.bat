@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: ============================================================
::  Relay 매출 Driver Tree - 원클릭 실행기
::  어디에 두어도 실행 가능합니다.
:: ============================================================

title Relay 매출 Driver Tree

set "REPO_URL=https://github.com/wankyu4356/Model_visual.git"
set "BRANCH=claude/revenue-driver-tree-dokO9"
set "REPO_DIR=%~dp0Model_visual"
set "HTML_FILE=index.html"

echo.
echo  ╔══════════════════════════════════════════════╗
echo  ║   Relay 매출 Driver Tree  - 실행기           ║
echo  ╚══════════════════════════════════════════════╝
echo.

:: ──────────────────────────────────────────────
:: 1. 환경 체크 - Git 설치 확인
:: ──────────────────────────────────────────────
echo [1/4] 환경 체크...

where git >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo   [X] Git이 설치되어 있지 않습니다.
    echo       https://git-scm.com/downloads 에서 설치 후 다시 실행하세요.
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%v in ('git --version') do set "GIT_VER=%%v"
echo   [OK] %GIT_VER%

:: 브라우저 확인 (start 명령은 항상 있으므로 간단히 체크)
echo   [OK] 브라우저 실행 준비 완료
echo.

:: ──────────────────────────────────────────────
:: 2. 이미 Clone된 경우 → Pull, 아니면 → Clone
:: ──────────────────────────────────────────────
if exist "%REPO_DIR%\.git" (
    echo [2/4] 기존 저장소 발견 - 업데이트 확인 중...
    pushd "%REPO_DIR%"

    :: 현재 브랜치 확인
    for /f "tokens=*" %%b in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set "CUR_BRANCH=%%b"
    if "!CUR_BRANCH!" neq "%BRANCH%" (
        echo   브랜치 전환: !CUR_BRANCH! → %BRANCH%
        git fetch origin %BRANCH% >nul 2>&1
        git checkout %BRANCH% >nul 2>&1
        if !ERRORLEVEL! neq 0 (
            git checkout -b %BRANCH% origin/%BRANCH% >nul 2>&1
        )
    )

    :: Pull 업데이트 (최대 4회 재시도)
    set "PULL_OK=0"
    for /l %%i in (1,1,4) do (
        if !PULL_OK! equ 0 (
            echo   Pull 시도 %%i/4...
            git pull origin %BRANCH% >nul 2>&1
            if !ERRORLEVEL! equ 0 (
                set "PULL_OK=1"
                echo   [OK] 최신 버전으로 업데이트 완료
            ) else (
                if %%i lss 4 (
                    set /a "WAIT=%%i*2"
                    echo   재시도 대기 !WAIT!초...
                    timeout /t !WAIT! /nobreak >nul
                )
            )
        )
    )
    if !PULL_OK! equ 0 (
        echo   [!] 업데이트 실패 - 기존 버전으로 실행합니다.
    )

    popd
) else (
    echo [2/4] 저장소 Clone 중...

    :: Clone (최대 4회 재시도)
    set "CLONE_OK=0"
    for /l %%i in (1,1,4) do (
        if !CLONE_OK! equ 0 (
            echo   Clone 시도 %%i/4...
            git clone -b %BRANCH% "%REPO_URL%" "%REPO_DIR%" >nul 2>&1
            if !ERRORLEVEL! equ 0 (
                set "CLONE_OK=1"
                echo   [OK] 저장소 Clone 완료
            ) else (
                if %%i lss 4 (
                    set /a "WAIT=%%i*2"
                    echo   재시도 대기 !WAIT!초...
                    timeout /t !WAIT! /nobreak >nul
                )
            )
        )
    )
    if !CLONE_OK! equ 0 (
        echo   [X] Clone 실패 - 네트워크 연결을 확인하세요.
        echo.
        pause
        exit /b 1
    )
)
echo.

:: ──────────────────────────────────────────────
:: 3. HTML 파일 존재 확인
:: ──────────────────────────────────────────────
echo [3/4] 파일 확인...

if not exist "%REPO_DIR%\%HTML_FILE%" (
    echo   [X] %HTML_FILE% 파일을 찾을 수 없습니다.
    echo       저장소가 올바르게 다운로드되었는지 확인하세요.
    echo.
    pause
    exit /b 1
)

for %%F in ("%REPO_DIR%\%HTML_FILE%") do (
    echo   [OK] %HTML_FILE% (%%~zF bytes^)
)
echo.

:: ──────────────────────────────────────────────
:: 4. 브라우저에서 열기
:: ──────────────────────────────────────────────
echo [4/4] 브라우저에서 열기...
start "" "%REPO_DIR%\%HTML_FILE%"
echo   [OK] 브라우저에서 열었습니다.
echo.

echo  ────────────────────────────────────────────
echo   완료! 아무 키나 누르면 창이 닫힙니다.
echo  ────────────────────────────────────────────
echo.
pause >nul
