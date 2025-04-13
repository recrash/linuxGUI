@echo off
chcp 65001 > nul
echo Ubuntu XFCE with Chrome in Docker 설치 및 실행
echo ==================================================

if not exist ..\shared mkdir ..\shared

echo VcXsrv(XLaunch)가 실행 중인지 확인하세요!
echo 실행되지 않았다면, 시작 메뉴에서 XLaunch를 실행하고 설정하세요.
pause

echo.
echo 메뉴:
echo 1. 새 컨테이너 생성 (처음 실행시)
echo 2. 컨테이너 시작 (중지된 컨테이너가 있을 경우)
echo 3. 컨테이너 재시작 (이미 실행 중인 컨테이너가 있을 경우)
echo 4. 컨테이너 재구축 (설정 변경 적용, 홈 데이터 유지)
echo.

set /p userChoice=번호를 선택하세요 (1-4): 

if "%userChoice%"=="1" goto :CreateNew
if "%userChoice%"=="2" goto :StartContainer
if "%userChoice%"=="3" goto :RestartContainer 
if "%userChoice%"=="4" goto :RebuildContainer
goto :InvalidChoice

:CreateNew
echo.
echo 새 컨테이너를 생성합니다...
docker-compose up -d --build
goto :CheckStatus

:StartContainer
echo.
echo 컨테이너를 시작합니다...
docker-compose start
goto :CheckStatus

:RestartContainer
echo.
echo 컨테이너를 재시작합니다...
docker-compose restart
goto :CheckStatus

:RebuildContainer
echo.
echo 컨테이너를 재구축합니다 (홈 디렉토리 데이터는 유지됩니다)...
docker-compose down
docker-compose up -d --build
goto :CheckStatus

:InvalidChoice
echo.
echo 잘못된 선택입니다. 프로그램을 종료합니다.
exit /b

:CheckStatus
echo.
echo 컨테이너 상태:
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}" --filter "name=ubuntu-xfce"

echo.
echo 설치 및 실행이 완료되었습니다!
echo 이제 Ubuntu XFCE 데스크톱이 새 창에 표시됩니다.
echo.
echo [중요] 지속되는 데이터는 프로젝트 루트의 'shared' 폴더에 저장하세요.
echo       컨테이너 내부에서는 /home/user/shared 경로로 접근할 수 있습니다.
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
echo.
pause