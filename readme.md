# Ubuntu Linux GUI in Docker

이 프로젝트는 Docker를 사용하여 Ubuntu Linux, XFCE 데스크톱 환경, 그리고 개발에 필요한 도구들을 설치하고 두 가지 방식으로 GUI를 실행할 수 있도록 설정합니다:

1. **VcXsrv 방식**: Windows에 VcXsrv를 설치하여 X 서버를 통해 GUI를 표시합니다.
2. **KasmVNC 방식**: 웹 브라우저를 통해 Linux 데스크톱에 접속합니다 (별도 설치 불필요).

## 목차

1. [필수 요구사항](#1-필수-요구사항)
2. [설치 및 실행 방법](#2-설치-및-실행-방법)
3. [VcXsrv 방식 사용하기](#3-vcxsrv-방식-사용하기)
   - [VcXsrv 설치 및 설정](#31-vcxsrv-설치-및-설정)
   - [VcXsrv 모드로 실행하기](#32-vcxsrv-모드로-실행하기)
4. [KasmVNC 방식 사용하기](#4-kasmvnc-방식-사용하기)
   - [KasmVNC 모드로 실행하기](#41-kasmvnc-모드로-실행하기)
   - [웹 브라우저로 접속하기](#42-웹-브라우저로-접속하기)
5. [데이터 관리](#5-데이터-관리)
   - [데이터 지속성](#51-데이터-지속성)
   - [공유 폴더 사용](#52-공유-폴더-사용)
6. [문제 해결](#6-문제-해결)
   - [VcXsrv 관련 문제](#61-vcxsrv-관련-문제)
   - [KasmVNC 관련 문제](#62-kasmvnc-관련-문제)
   - [한글 표시 문제](#63-한글-표시-문제)
   - [FUSE 관련 문제](#64-fuse-관련-문제)
7. [고급 사용법](#7-고급-사용법)
   - [자동 시작 설정](#71-자동-시작-설정)
   - [추가 소프트웨어 설치](#72-추가-소프트웨어-설치)
8. [보안 고려사항](#8-보안-고려사항)
9. [참고 자료](#9-참고-자료)

## 1. 필수 요구사항

- **공통 요구사항**
  - Windows 10 또는 11
  - Docker Desktop
  
- **VcXsrv 방식 추가 요구사항**
  - VcXsrv (X-Server for Windows)

- **KasmVNC 방식 추가 요구사항**
  - 웹 브라우저 (Chrome, Firefox, Edge 등)

## 2. 설치 및 실행 방법

1. 이 저장소를 다운로드하거나 클론합니다.
2. `linux-gui-launcher.bat` 파일을 더블클릭하여 실행합니다.
3. 공유 폴더가 자동으로 생성됩니다 (프로젝트 루트의 `shared` 폴더).
4. 실행 방식을 선택합니다:
   - VcXsrv 방식: Windows에 VcXsrv를 설치하여 사용
   - KasmVNC 방식: 웹 브라우저를 통해 사용 (별도 설치 불필요)


## 3. VcXsrv 방식 사용하기

### 3.1 VcXsrv 설치 및 설정

VcXsrv는 Windows에서 X11 디스플레이 서버를 실행하기 위한 소프트웨어입니다.

#### 3.1.1 VcXsrv 설치

1. [VcXsrv 다운로드 페이지](https://sourceforge.net/projects/vcxsrv/)에서 최신 버전의 VcXsrv를 다운로드합니다.
2. 다운로드한 설치 파일을 실행하여 VcXsrv를 설치합니다.

#### 3.1.2 VcXsrv 설정 및 실행

1. Windows 시작 메뉴에서 XLaunch를 찾아 실행합니다.

2. **Display settings** 화면:
   - "Multiple windows" 선택
   - "Display number"를 0으로 설정
   - "Next" 클릭

3. **Session selection** 화면:
   - "Start no client" 선택
   - "Next" 클릭

4. **Additional parameters** 화면:
   - "Disable access control" 체크박스 **반드시 체크**
   - "Native OpenGL" 체크 (선택사항)
   - "Next" 클릭

5. **Finish configuration** 화면:
   - "Save configuration" 버튼을 클릭하여 설정을 저장하면 나중에 쉽게 실행할 수 있습니다.
   - 설정 파일을 바탕화면이나 시작 메뉴에 저장해 두는 것이 좋습니다.
   - "Finish" 클릭하여 VcXsrv를 시작합니다.

#### 3.1.3 Windows 방화벽 설정

VcXsrv가 처음 실행되면 Windows에서 방화벽 허용 여부를 물을 수 있습니다. "허용"을 선택하세요.

수동으로 방화벽 설정을 확인하거나 변경하려면:

1. Windows 검색에서 "방화벽"을 검색하고 "Windows Defender 방화벽을 통해 앱 또는 기능 허용"을 선택합니다.
2. "설정 변경" 버튼을 클릭합니다.
3. 목록에서 "VcXsrv windows xserver"를 찾아 "프라이빗" 및 "공용" 네트워크에 체크하세요.
4. "확인"을 클릭하여 설정을 저장합니다.

#### 3.1.4 고급 방화벽 설정 (필요한 경우)

더 구체적인 방화벽 규칙이 필요한 경우:

1. Windows 검색에서 "고급 방화벽"을 검색하고 "Windows Defender 방화벽과 고급 보안"을 선택합니다.
2. 왼쪽 패널에서 "인바운드 규칙"을 선택합니다.
3. 오른쪽 패널에서 "새 규칙"을 클릭합니다.
4. "포트"를 선택하고 "다음"을 클릭합니다.
5. "TCP"를 선택하고 "특정 로컬 포트"에 "6000"을 입력한 후 "다음"을 클릭합니다.
6. "연결 허용"을 선택하고 "다음"을 클릭합니다.
7. 모든 네트워크 위치에 체크하고 "다음"을 클릭합니다.
8. 이름을 "VcXsrv Port 6000"으로 지정하고 "마침"을 클릭합니다.

### 3.2 VcXsrv 모드로 실행하기

1. `linux-gui-launcher.bat` 파일을 실행합니다.
2. "1. VcXsrv" 옵션을 선택합니다.
3. 표시되는 메뉴에서 원하는 작업을 선택합니다:
   ```
   메뉴:
   1. 새 컨테이너 생성 (처음 실행시)
   2. 컨테이너 시작 (중지된 컨테이너가 있을 경우)
   3. 컨테이너 재시작 (이미 실행 중인 컨테이너가 있을 경우)
   4. 컨테이너 재구축 (설정 변경 적용, 홈 데이터 유지)
   ```
4. 작업이 완료되면 Ubuntu XFCE 데스크톱이 새 창에 표시됩니다.

## 4. KasmVNC 방식 사용하기

KasmVNC 방식은 별도의 소프트웨어 설치 없이 웹 브라우저만으로 Linux 데스크톱에 접속할 수 있습니다. KasmVNC는 기존 NoVNC에 비해 향상된 성능과 기능을 제공합니다.

### 4.1 KasmVNC 모드로 실행하기

1. `linux-gui-launcher.bat` 파일을 실행합니다.
2. "2. KasmVNC" 옵션을 선택합니다.
3. 표시되는 메뉴에서 원하는 작업을 선택합니다:
   ```
   메뉴:
   1. 새 컨테이너 생성 (처음 실행시)
   2. 컨테이너 시작 (중지된 컨테이너가 있을 경우)
   3. 컨테이너 중지
   4. 컨테이너 재구축 (설정 변경 적용)
   ```

### 4.2 웹 브라우저로 접속하기

1. 컨테이너가 시작되면 웹 브라우저를 열고 다음 주소로 접속합니다: `http://localhost:6901/`
2. KasmVNC 접속 화면이 표시됩니다.
3. 기본 패스워드는 docker-compose.yml 파일에 설정된 `password`입니다.
4. 이제 웹 브라우저에서 Ubuntu XFCE 데스크톱을 사용할 수 있습니다.

### 4.3 KasmVNC의 주요 기능

- **자동 화면 크기 조정**: 브라우저 창 크기에 맞게 자동으로 해상도가 조정됩니다.
- **향상된 성능**: 최적화된 프로토콜로 더 빠른 화면 응답성을 제공합니다.
- **클립보드 동기화**: 호스트와 컨테이너 간 클립보드 내용이 자동으로 동기화됩니다.
- **파일 업로드/다운로드**: 웹 인터페이스를 통해 파일을 주고받을 수 있습니다.
- **한글 지원**: 한글 폰트와 입력기가 기본으로 설치되어 있습니다.

## 5. 데이터 관리

### 5.1 데이터 지속성

- **홈 디렉토리 데이터**: 
   - VcXsrv 모드: ubuntu-home이라는 Docker 볼륨에 저장되어 컨테이너를 재시작해도 유지됩니다.
   - KasmVNC 모드: 컨테이너 내부 데이터는 컨테이너를 재구축하면 초기화됩니다.
- `docker-compose down` 명령은 컨테이너를 중지하고 제거하지만, 볼륨 데이터는 유지됩니다.
- 볼륨 데이터를 포함하여 모든 것을 삭제하려면 명령 프롬프트에서 `docker-compose down -v` 명령을 실행하세요.

### 5.2 공유 폴더 사용

`shared` 디렉토리는 호스트와 컨테이너 간에 파일을 공유하는 데 사용됩니다. 두 컨테이너 모드(VcXsrv와 KasmVNC) 모두 동일한 공유 폴더를 사용합니다.

1. 호스트에서는 프로젝트 루트 디렉토리의 `shared` 폴더에 접근할 수 있습니다.
2. 컨테이너 내부에서는 다음 경로로 접근할 수 있습니다:
   - VcXsrv 방식: `/home/user/shared`
   - KasmVNC 방식: `/home/kasm-user/shared`

## 6. 문제 해결

### 6.1 VcXsrv 관련 문제

"Cannot open display" 오류가 발생하면:

1. VcXsrv가 실행 중인지 확인하세요.
2. VcXsrv 설정에서 "Disable access control" 옵션이 체크되어 있는지 확인하세요.
3. Docker 컨테이너를 재시작하세요:
   ```bash
   cd [사용 중인 방식의 폴더]  # 예: vcxsrv 또는 KasmVNC
   docker-compose restart
   ```
4. DISPLAY 환경 변수가 올바르게 설정되었는지 확인하세요:
   ```bash
   docker exec -it ubuntu-xfce bash -c "echo $DISPLAY"
   ```
   결과가 `host.docker.internal:0.0`이어야 합니다.

### 6.2 KasmVNC 관련 문제

웹 브라우저에서 KasmVNC에 접속할 수 없는 경우:

1. 컨테이너가 실행 중인지 확인하세요:
   ```bash
   cd [사용 중인 방식의 폴더]  # 예: vcxsrv 또는 KasmVNC
   docker-compose ps
   ```

2. 컨테이너 로그를 확인하세요:
   ```bash
   docker logs kasmvnc-gui
   ```

3. 6901 포트가 다른 프로그램에서 사용 중인지 확인하세요:
   ```bash
   netstat -ano | findstr :6901
   ```

4. 포트를 변경하려면 `KasmVNC/docker-compose.yml` 파일의 ports 섹션을 수정하세요:
   ```yaml
   ports:
     - "7901:6901"  # 7901 포트로 변경 예시
   ```

5. 인증 문제가 있는 경우 환경 변수에서 VNC_PASSWORD를 확인하세요:
   ```yaml
   environment:
     - VNC_PASSWORD=원하는_비밀번호 # 비밀번호 변경
   ```
6. startup.sh 파일의 줄 끝(line ending) 문제: 
   Windows에서 파일을 편집한 경우 CRLF가 아닌 LF로 저장해야 합니다. 
   VSCode나 Notepad++와 같은 에디터에서 줄 끝 형식을 LF로 변경하세요.

### 6.3 한글 표시 문제

한글이 깨져서 표시되는 경우:

1. 컨테이너가 최신 버전으로 빌드되었는지 확인하세요:
   ```bash
   cd [사용 중인 방식의 폴더]  # 예: vcxsrv 또는 KasmVNC
   docker-compose down
   docker-compose up -d --build
   ```
2. 컨테이너 내부에서 로케일 설정이 올바른지 확인하세요:
   ```bash
   docker exec -it ubuntu-xfce bash -c "locale"  # VcXsrv 방식   
   docker exec -it kasmvnc-gui bash -c "locale"  # KasmVNC 방식
   ```
   `LANG`, `LANGUAGE`, `LC_ALL` 값이 모두 `ko_KR.UTF-8`로 설정되어 있어야 합니다.

### 6.4 FUSE 관련 문제

FUSE 기능을 사용하는 AppImage 애플리케이션이 실행되지 않는 경우:

1. Docker 컨테이너에 FUSE 관련 권한이 적절히 설정되어 있는지 확인하세요:
   ```bash
   docker exec -it ubuntu-xfce bash -c "ls -la /dev/fuse"  # VcXsrv 방식
   docker exec -it kasmvnc-gui bash -c "ls -la /dev/fuse"  # KasmVNC 방식
   ```

2. 필수 패키지 설치:
   이미 libfuse2를 설치했지만, 몇 가지 추가 패키지도 필요할 수 있습니다:
   ```bash
   sudo apt update
   sudo apt install -y fuse kmod
   ```
   kmod 패키지는 modprobe 명령을 제공합니다.

3. FUSE 모듈 로드:
   modprobe 명령으로 FUSE 커널 모듈을 로드합니다:
   ```bash
   sudo modprobe fuse
   ```

4. FUSE 장치 확인:
   FUSE 장치가 제대로 생성되었는지 확인합니다:
   ```bash
   ls -la /dev/fuse
   ```

5. docker-compose.yml 파일에서 다음 설정이 포함되어 있는지 확인하세요:
   ```yaml
   devices:
     - /dev/fuse:/dev/fuse
   cap_add:
     - SYS_ADMIN
   security_opt:
     - apparmor:unconfined
   ```

6. 컨테이너를 재시작하고 다시 시도하세요:
   ```bash
   cd [사용 중인 방식의 폴더]  # 예: vcxsrv 또는 KasmVNC
   docker-compose restart
   ```

## 7. 고급 사용법

### 7.1 자동 시작 설정

#### 7.1.1 VcXsrv 자동 시작 (VcXsrv 방식 사용 시)

Windows 시작 시 VcXsrv가 자동으로 실행되도록 설정하려면:

1. 이전에 저장한 XLaunch 구성 파일(.xlaunch)을 찾습니다.
2. Windows 키 + R을 누르고 "shell:startup"을 입력한 후 확인을 클릭합니다.
3. 시작 폴더가 열리면 XLaunch 구성 파일의 바로 가기를 이 폴더에 복사합니다.

#### 7.1.2 컨테이너 자동 시작

Docker Desktop이 시작될 때 컨테이너가 자동으로 시작되도록 설정하려면:

1. Docker Desktop을 실행합니다.
2. Docker Desktop 설정(Settings)에서 "General" 탭으로 이동합니다.
3. "Start Docker Desktop when you log in" 옵션이 체크되어 있는지 확인합니다.
4. docker-compose.yml 파일에서 `restart: unless-stopped` 설정이 이미 적용되어 있습니다.

### 7.2 추가 소프트웨어 설치

컨테이너 내부에서 추가 소프트웨어를 설치하려면:

1. 터미널에서 다음 명령어로 컨테이너에 접속합니다:
   ```bash
   docker exec -it ubuntu-xfce bash  # VcXsrv 방식
   docker exec -it kasmvnc-gui bash  # KasmVNC 방식
   ```

2. sudo 권한으로 apt-get을 사용하여 원하는 패키지를 설치합니다:
   ```bash
   sudo apt-get update
   sudo apt-get install [패키지 이름]
   ```

#### 7.2.1 크롬 브라우저 바로가기 설정

XFCE 데스크톱에서 크롬 브라우저를 더 쉽게 실행할 수 있도록 바로가기를 설정하려면:

1. XFCE 데스크톱 환경에서 바탕화면을 마우스 오른쪽 버튼으로 클릭합니다.
2. "Create Launcher"를 선택합니다.
3. 다음과 같이 설정합니다:
   - Name: Google Chrome
   - Command: google-chrome-stable
   - Icon: chrome 아이콘 선택
4. "Create" 버튼을 클릭합니다.

#### 7.2.2 AppImage 애플리케이션 실행하기

이 환경은 AppImage 애플리케이션을 실행할 수 있도록 FUSE 지원이 설정되어 있습니다:

1. 원하는 AppImage 파일을 호스트의 `shared` 폴더에 복사합니다.
2. 컨테이너 내부에서 터미널을 열고 다음과 같이 실행 권한을 부여합니다:
   ```bash
   chmod +x ~/shared/애플리케이션명.AppImage
   ```
3. AppImage 파일을 실행합니다:
   ```bash
   ~/shared/애플리케이션명.AppImage
   ```
4. 자주 사용하는 AppImage 파일은 홈 디렉토리의 `AppImages` 폴더에 저장하는 것이 좋습니다:
   ```bash
   mkdir -p ~/AppImages
   cp ~/shared/애플리케이션명.AppImage ~/AppImages/
   ```

## 8. 보안 고려사항

1. **VcXsrv 방식**: VcXsrv에서 "Disable access control" 옵션은 보안상 취약할 수 있습니다. 공용 네트워크에서는 주의해서 사용하세요.

2. **KasmVNC 방식**: 기본 설정에서는 localhost에서만 접속이 가능합니다. 다른 컴퓨터에서 접속하려면 docker-compose.yml 파일의 ports 설정을 변경해야 하며, 이 경우 보안에 주의하세요.

3. 컨테이너 내부의 사용자는 sudo 권한을 갖고 있습니다. 필요에 따라 Dockerfile에서 이 설정을 변경할 수 있습니다.

4. Docker Desktop과 VcXsrv는 최신 버전으로 유지하는 것이 좋습니다.

5. 그래픽 집약적인 애플리케이션의 경우 성능 제한이 있을 수 있습니다.

## 9. 참고 자료

- [Docker 공식 문서](https://docs.docker.com/)
- [VcXsrv 프로젝트 페이지](https://sourceforge.net/projects/vcxsrv/)
- [KasmVNC 프로젝트 페이지](https://github.com/kasmtech/KasmVNC)
- [KasmVNC 문서](https://www.kasmweb.com/kasmvnc/docs/latest/)
- [Ubuntu 공식 문서](https://help.ubuntu.com/)
- [XFCE 공식 문서](https://docs.xfce.org/)
- [Docker Compose 문서](https://docs.docker.com/compose/)