@echo off
chcp 65001 > nul
echo Linux GUI 컨테이너 런처
echo ==================================================

if not exist shared mkdir shared

echo.
echo 사용하실 Linux GUI 방식을 선택하세요:
echo 1. VcXsrv (외부 X 서버 필요 - Windows에 VcXsrv 설치 필요)
echo 2. KasmVNC (웹 브라우저만 필요 - 아무 설치 없이 사용 가능)
echo.

set /p userChoice=번호를 선택하세요 (1-2): 

if "%userChoice%"=="1" goto :VcXsrv
if "%userChoice%"=="2" goto :KasmVNC
goto :InvalidChoice

:VcXsrv
echo.
echo VcXsrv 모드를 선택하셨습니다.
echo VcXsrv(XLaunch)가 실행 중인지 확인하세요!
echo 실행되지 않았다면, 시작 메뉴에서 XLaunch를 실행하고 설정하세요.
pause
cd vcxsrv
call setup-and-run.bat
cd ..
goto :End

:KasmVNC
echo.
echo KasmVNC 모드를 선택하셨습니다.
echo 브라우저에서 접속할 수 있는 컨테이너를 시작합니다.
echo.
cd kasmvnc

echo 메뉴:
echo 1. 새 컨테이너 생성 (처음 실행시)
echo 2. 컨테이너 시작 (중지된 컨테이너가 있을 경우)
echo 3. 컨테이너 중지
echo 4. 컨테이너 재구축 (설정 변경 적용)
echo.

set /p kasmvncChoice=번호를 선택하세요 (1-4): 

if "%kasmvncChoice%"=="1" goto :KasmVNC_CreateNew
if "%kasmvncChoice%"=="2" goto :KasmVNC_StartContainer
if "%kasmvncChoice%"=="3" goto :KasmVNC_StopContainer
if "%kasmvncChoice%"=="4" goto :KasmVNC_RebuildContainer
goto :InvalidChoice

:KasmVNC_CreateNew
echo.
echo 새 KasmVNC 컨테이너를 생성합니다...
docker-compose up -d --build
goto :KasmVNC_CheckStatus

:KasmVNC_StartContainer
echo.
echo KasmVNC 컨테이너를 시작합니다...
docker-compose start
goto :KasmVNC_CheckStatus

:KasmVNC_StopContainer
echo.
echo KasmVNC 컨테이너를 중지합니다...
docker-compose stop
cd ..
goto :End

:KasmVNC_RebuildContainer
echo.
echo KasmVNC 컨테이너를 재구축합니다...
docker-compose down
docker-compose up -d --build
goto :KasmVNC_CheckStatus

:KasmVNC_CheckStatus
echo.
echo 컨테이너 상태:
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}" --filter "name=ubuntu-kasmvnc"

echo.
echo 설치 및 실행이 완료되었습니다!
echo 웹 브라우저에서 다음 주소로 접속하세요:
echo   http://localhost:6080/
echo.
echo 기본 VNC 패스워드: password
echo.
cd ..
pause
goto :End

:InvalidChoice
echo.
echo 잘못된 선택입니다. 프로그램을 종료합니다.
exit /b

:End
echo.
echo 프로그램을 종료합니다. 