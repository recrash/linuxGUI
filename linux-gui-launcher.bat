@echo off
chcp 65001 > nul
echo Linux GUI 컨테이너 런처
echo ==================================================

if not exist shared mkdir shared

echo.
echo 사용하실 Linux GUI 방식을 선택하세요:
echo 1. VcXsrv (외부 X 서버 필요 - Windows에 VcXsrv 설치 필요)
echo 2. NoVNC (웹 브라우저만 필요 - 아무 설치 없이 사용 가능)
echo.

set /p userChoice=번호를 선택하세요 (1-2): 

if "%userChoice%"=="1" goto :VcXsrv
if "%userChoice%"=="2" goto :NoVNC
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

:NoVNC
echo.
echo NoVNC 모드를 선택하셨습니다.
echo 브라우저에서 접속할 수 있는 컨테이너를 시작합니다.
echo.
cd novnc

echo 메뉴:
echo 1. 새 컨테이너 생성 (처음 실행시)
echo 2. 컨테이너 시작 (중지된 컨테이너가 있을 경우)
echo 3. 컨테이너 재시작 (이미 실행 중인 컨테이너가 있을 경우)
echo 4. 컨테이너 재구축 (설정 변경 적용, 홈 데이터 유지)
echo.

set /p novncChoice=번호를 선택하세요 (1-4): 

if "%novncChoice%"=="1" goto :NoVNC_CreateNew
if "%novncChoice%"=="2" goto :NoVNC_StartContainer
if "%novncChoice%"=="3" goto :NoVNC_RestartContainer 
if "%novncChoice%"=="4" goto :NoVNC_RebuildContainer
goto :InvalidChoice

:NoVNC_CreateNew
echo.
echo 새 NoVNC 컨테이너를 생성합니다...
docker-compose up -d --build
goto :NoVNC_CheckStatus

:NoVNC_StartContainer
echo.
echo NoVNC 컨테이너를 시작합니다...
docker-compose start
goto :NoVNC_CheckStatus

:NoVNC_RestartContainer
echo.
echo NoVNC 컨테이너를 재시작합니다...
docker-compose restart
goto :NoVNC_CheckStatus

:NoVNC_RebuildContainer
echo.
echo NoVNC 컨테이너를 재구축합니다 (홈 디렉토리 데이터는 유지됩니다)...
docker-compose down
docker-compose up -d --build
goto :NoVNC_CheckStatus

:NoVNC_CheckStatus
echo.
echo 컨테이너 상태:
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}" --filter "name=ubuntu-novnc"

echo.
echo 설치 및 실행이 완료되었습니다!
echo 웹 브라우저에서 다음 주소로 접속하세요:
echo   기본 URL: http://localhost:6080/
echo   (자동으로 최적 설정이 적용됩니다)
echo.
echo 기본 VNC 패스워드: password
echo.
echo [컨테이너 관리 명령어]
echo  - 컨테이너 중지: docker-compose stop
echo  - 컨테이너 시작: docker-compose start
echo  - 컨테이너 재시작: docker-compose restart
echo  - 컨테이너 및 이미지 삭제: docker-compose down
echo  - 컨테이너 재구축: docker-compose up -d --build
echo.
echo [참고] docker-compose down을 실행해도 볼륨 데이터는 유지됩니다.
echo [참고] 볼륨 데이터를 포함하여 모두 삭제하려면: docker-compose down -v
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