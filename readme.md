# Ubuntu XFCE with Chrome in Docker

이 프로젝트는 Docker를 사용하여 Ubuntu 22.04, XFCE 데스크톱 환경, 그리고 Google Chrome을 설치하고 Windows 10에서 VcXsrv를 통해 GUI를 실행할 수 있도록 설정합니다.

## 목차

1. [필수 요구사항](#1-필수-요구사항)
2. [설치 과정](#2-설치-과정)
   - [Docker Desktop 설치](#21-docker-desktop-설치)
   - [VcXsrv 설치 및 설정](#22-vcxsrv-설치-및-설정)
3. [컨테이너 실행 및 관리](#3-컨테이너-실행-및-관리)
   - [배치 파일 사용법](#31-배치-파일-사용법)
   - [주요 작업별 사용법](#32-주요-작업별-사용법)
   - [컨테이너 관리 명령어](#33-컨테이너-관리-명령어)
4. [데이터 관리](#4-데이터-관리)
   - [데이터 지속성](#41-데이터-지속성)
   - [공유 폴더 사용](#42-공유-폴더-사용)
5. [AppImage 사용하기](#5-appimage-사용하기)
   - [AppImage 기본 실행 방법](#51-appimage-기본-실행-방법)
   - [헬퍼 스크립트 사용법](#52-헬퍼-스크립트-사용법)
   - [AppImage 공유 및 관리](#53-appimage-공유-및-관리)
6. [문제 해결](#6-문제-해결)
   - [DISPLAY 변수 문제](#61-display-변수-문제)
   - [한글 표시 문제](#62-한글-표시-문제)
   - [AppImage 문제 해결](#63-appimage-문제-해결)
7. [고급 사용법](#7-고급-사용법)
   - [자동 시작 설정](#71-자동-시작-설정)
   - [추가 소프트웨어 설치](#72-추가-소프트웨어-설치)
8. [보안 고려사항](#8-보안-고려사항)
9. [참고 자료](#9-참고-자료)

## 1. 필수 요구사항

- Windows 10
- Docker Desktop
- VcXsrv (X-Server for Windows)

## 2. 설치 과정

### 2.1 Docker Desktop 설치

Docker Desktop은 Windows에서 Docker 컨테이너를 실행하기 위한 애플리케이션입니다.

#### 2.1.1 Docker Desktop 다운로드

1. [Docker Desktop 웹사이트](https://www.docker.com/products/docker-desktop/)에서 Windows용 Docker Desktop을 다운로드합니다.
2. 다운로드한 설치 파일(Docker Desktop Installer.exe)을 실행합니다.

#### 2.1.2 Docker Desktop 설치

1. 설치 마법사의 안내에 따라 진행합니다.
2. "Configuration" 화면에서 다음 옵션을 확인하세요:
   - "Use WSL 2 instead of Hyper-V" 옵션이 선택되어 있는지 확인합니다.
   - "Add shortcut to desktop" 옵션을 선택합니다.
3. "Install" 버튼을 클릭하여 설치를 시작합니다.
4. 설치가 완료되면 "Close and restart" 버튼을 클릭하여 컴퓨터를 재시작합니다.

#### 2.1.3 Docker Desktop 설정

1. 컴퓨터 재시작 후 Docker Desktop이 자동으로 실행됩니다.
2. 초기 설정 화면이 나타나면 "Accept" 버튼을 클릭하여 라이선스 계약에 동의합니다.
3. Docker Desktop이 WSL 2 백엔드를 사용하도록 구성되었는지 확인합니다.
4. Docker Desktop이 실행 중인지 확인하려면 시스템 트레이에서 Docker 아이콘을 확인하세요.

### 2.2 VcXsrv 설치 및 설정

VcXsrv는 Windows에서 X11 디스플레이 서버를 실행하기 위한 소프트웨어입니다.

#### 2.2.1 VcXsrv 설치

1. [VcXsrv 다운로드 페이지](https://sourceforge.net/projects/vcxsrv/)에서 최신 버전의 VcXsrv를 다운로드합니다.
2. 다운로드한 설치 파일을 실행하여 VcXsrv를 설치합니다.

#### 2.2.2 VcXsrv 설정 및 실행

1. Windows 시작 메뉴에서 XLaunch를 찾아 실행합니다.

2. **Display settings** 화면:
   - "Multiple windows" 선택
   - "Display number"를 0으로 설정
   - "Next" 클릭

   ![Display Settings](https://i.imgur.com/example1.png)

3. **Session selection** 화면:
   - "Start no client" 선택
   - "Next" 클릭

   ![Session Selection](https://i.imgur.com/example2.png)

4. **Additional parameters** 화면:
   - "Disable access control" 체크박스 **반드시 체크**
   - "Native OpenGL" 체크 (선택사항)
   - "Next" 클릭

   ![Additional Parameters](https://i.imgur.com/example3.png)

5. **Finish configuration** 화면:
   - "Save configuration" 버튼을 클릭하여 설정을 저장하면 나중에 쉽게 실행할 수 있습니다.
   - 설정 파일을 바탕화면이나 시작 메뉴에 저장해 두는 것이 좋습니다.
   - "Finish" 클릭하여 VcXsrv를 시작합니다.

#### 2.2.3 Windows 방화벽 설정

VcXsrv가 처음 실행되면 Windows에서 방화벽 허용 여부를 물을 수 있습니다. "허용"을 선택하세요.

수동으로 방화벽 설정을 확인하거나 변경하려면:

1. Windows 검색에서 "방화벽"을 검색하고 "Windows Defender 방화벽을 통해 앱 또는 기능 허용"을 선택합니다.
2. "설정 변경" 버튼을 클릭합니다.
3. 목록에서 "VcXsrv windows xserver"를 찾아 "프라이빗" 및 "공용" 네트워크에 체크하세요.
4. "확인"을 클릭하여 설정을 저장합니다.

#### 2.2.4 고급 방화벽 설정 (필요한 경우)

더 구체적인 방화벽 규칙이 필요한 경우:

1. Windows 검색에서 "고급 방화벽"을 검색하고 "Windows Defender 방화벽과 고급 보안"을 선택합니다.
2. 왼쪽 패널에서 "인바운드 규칙"을 선택합니다.
3. 오른쪽 패널에서 "새 규칙"을 클릭합니다.
4. "포트"를 선택하고 "다음"을 클릭합니다.
5. "TCP"를 선택하고 "특정 로컬 포트"에 "6000"을 입력한 후 "다음"을 클릭합니다.
6. "연결 허용"을 선택하고 "다음"을 클릭합니다.
7. 모든 네트워크 위치에 체크하고 "다음"을 클릭합니다.
8. 이름을 "VcXsrv Port 6000"으로 지정하고 "마침"을 클릭합니다.

## 3. 컨테이너 실행 및 관리

### 3.1 배치 파일 사용법

프로젝트에 포함된 `setup-and-run.bat` 배치 파일을 사용하여 컨테이너를 쉽게 관리할 수 있습니다.

1. 먼저 VcXsrv(XLaunch)를 실행하고 필요한 설정을 적용합니다 (상세 내용은 VcXsrv 설정 가이드 참조).
2. `setup-and-run.bat` 파일을 더블클릭하여 실행합니다.
3. 표시되는 메뉴에서 다음 중 원하는 작업을 선택합니다:
   ```
   메뉴:
   1. 새 컨테이너 생성 (처음 실행시)
   2. 컨테이너 시작 (중지된 컨테이너가 있을 경우)
   3. 컨테이너 재시작 (이미 실행 중인 컨테이너가 있을 경우)
   4. 컨테이너 재구축 (설정 변경 적용, 홈 데이터 유지)
   ```

4. 작업이 완료되면 Ubuntu XFCE 데스크톱이 새 창에 표시됩니다.

### 3.2 주요 작업별 사용법

#### 3.2.1 처음 실행 시

컨테이너를 처음 실행할 때는 메뉴에서 **1번 옵션(새 컨테이너 생성)**을 선택합니다. 이 과정에서 Docker 이미지가 빌드되고 컨테이너가 시작됩니다.

#### 3.2.2 컨테이너 중지 후 재시작

컨테이너를 중지한 후 다시 시작하려면 메뉴에서 **2번 옵션(컨테이너 시작)**을 선택합니다.

#### 3.2.3 실행 중인 컨테이너 재시작

컨테이너가 실행 중인 상태에서 재시작하려면 메뉴에서 **3번 옵션(컨테이너 재시작)**을 선택합니다.

#### 3.2.4 설정 변경 후 재구축

Dockerfile, docker-compose.yml 또는 기타 설정 파일을 수정한 후에는 메뉴에서 **4번 옵션(컨테이너 재구축)**을 선택합니다. 이 옵션은 홈 디렉토리 데이터를 유지하면서 컨테이너를 재구축합니다.

### 3.3 컨테이너 관리 명령어

배치 파일을 사용하지 않고 명령줄에서 직접 컨테이너를 관리할 수도 있습니다:

#### 3.3.1 컨테이너 상태 확인

```bash
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}" --filter "name=ubuntu-xfce"
```

#### 3.3.2 컨테이너 시작

```bash
docker-compose start
```

#### 3.3.3 컨테이너 재시작

```bash
docker-compose restart
```

#### 3.3.4 컨테이너 중지

```bash
docker-compose stop
```

#### 3.3.5 컨테이너 종료 및 제거

```bash
docker-compose down
```

#### 3.3.6 컨테이너 로그 확인

```bash
docker logs ubuntu-xfce
```

## 4. 데이터 관리

### 4.1 데이터 지속성

- **홈 디렉토리 데이터**: 사용자의 홈 디렉토리(`/home/user`) 데이터는 Docker 볼륨에 저장되어 컨테이너를 재구축하거나 삭제해도 유지됩니다.
- `docker-compose down` 명령은 컨테이너를 중지하고 제거하지만, 볼륨 데이터는 유지됩니다.
- 볼륨 데이터를 포함하여 모든 것을 삭제하려면 명령 프롬프트에서 `docker-compose down -v` 명령을 실행하세요.

### 4.2 공유 폴더 사용

`shared` 디렉토리는 호스트와 컨테이너 간에 파일을 공유하는 데 사용됩니다.

1. 호스트에서는 프로젝트 디렉토리 내의 `shared` 폴더에 접근할 수 있습니다.
2. 컨테이너 내부에서는 `/home/user/shared` 경로로 접근할 수 있습니다.

## 5. AppImage 사용하기

### 5.1 AppImage 기본 실행 방법

AppImage는 설치 없이 실행할 수 있는 리눅스용 휴대용 애플리케이션 형식입니다.

1. AppImage 파일 다운로드
2. 실행 권한 부여
   ```bash
   chmod +x 애플리케이션이름.AppImage
   ```
3. 파일 실행
   ```bash
   ./애플리케이션이름.AppImage
   ```

### 5.2 헬퍼 스크립트 사용법

이 컨테이너는 AppImage 파일을 쉽게 관리할 수 있는 헬퍼 스크립트를 제공합니다.

#### 5.2.1 AppImage 설치(메뉴 등록)

```bash
~/appimage-helper.sh install 경로/파일이름.AppImage 애플리케이션이름
```

이 명령어는:
- AppImage 파일을 `~/AppImages/` 디렉토리로 복사합니다.
- 데스크톱 메뉴에 애플리케이션을 등록합니다.
- 가능하면 아이콘을 추출하여 설정합니다.

#### 5.2.2 AppImage 실행

```bash
~/appimage-helper.sh run 경로/파일이름.AppImage
```

#### 5.2.3 설치된 AppImage 목록 보기

```bash
~/appimage-helper.sh list
```

#### 5.2.4 AppImage 제거

```bash
~/appimage-helper.sh remove 애플리케이션이름
```

#### 5.2.5 AppImage 통합

```bash
~/appimage-helper.sh integrate 경로/파일이름.AppImage
```

### 5.3 AppImage 공유 및 관리

Windows 호스트에서 컨테이너로 AppImage 파일을 전송하려면, 프로젝트의 `shared` 폴더를 사용하세요:

1. AppImage 파일을 Windows의 `shared` 폴더에 복사합니다.
2. 컨테이너 내부에서 `/home/user/shared` 경로로 접근할 수 있습니다.
3. 헬퍼 스크립트를 사용하여 AppImage를 설치하거나 실행합니다:
   ```bash
   ~/appimage-helper.sh install /home/user/shared/애플리케이션.AppImage 애플리케이션이름
   ```

## 6. 문제 해결

### 6.1 DISPLAY 변수 문제

"Cannot open display" 오류가 발생하면:

1. VcXsrv가 실행 중인지 확인하세요.
2. VcXsrv 설정에서 "Disable access control" 옵션이 체크되어 있는지 확인하세요.
3. Docker 컨테이너를 재시작하세요:
   ```bash
   docker-compose restart
   ```
4. DISPLAY 환경 변수가 올바르게 설정되었는지 확인하세요:
   ```bash
   docker exec -it ubuntu-xfce bash -c "echo $DISPLAY"
   ```
   결과가 `host.docker.internal:0.0`이어야 합니다.

### 6.2 한글 표시 문제

한글이 깨져서 표시되는 경우:

1. 컨테이너가 최신 버전으로 빌드되었는지 확인하세요:
   ```bash
   docker-compose down
   docker-compose up -d --build
   ```
2. 컨테이너 내부에서 로케일 설정이 올바른지 확인하세요:
   ```bash
   docker exec -it ubuntu-xfce bash -c "locale"
   ```
   `LANG`, `LANGUAGE`, `LC_ALL` 값이 모두 `ko_KR.UTF-8`로 설정되어 있어야 합니다.

### 6.3 AppImage 문제 해결

1. **실행 권한 오류**: "Permission denied" 오류가 발생하면 실행 권한을 확인하세요.
   ```bash
   chmod +x 파일이름.AppImage
   ```

2. **공유 라이브러리 오류**: 필요한 라이브러리가 누락된 경우 설치하세요.
   ```bash
   # 필요한 라이브러리를 찾기 위한 명령어
   ldd 파일이름.AppImage
   ```

3. **데스크톱 통합 문제**: AppImage가 메뉴에 나타나지 않는 경우:
   ```bash
   update-desktop-database ~/.local/share/applications
   ```

4. **기타 문제**: 일부 AppImage는 특정 시스템 라이브러리가 필요할 수 있습니다.
   ```bash
   sudo apt-get update
   sudo apt-get install 필요한패키지이름
   ```

## 7. 고급 사용법

### 7.1 자동 시작 설정

#### 7.1.1 VcXsrv 자동 시작

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
   docker exec -it ubuntu-xfce bash
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

## 8. 보안 고려사항

1. VcXsrv에서 "Disable access control" 옵션은 보안상 취약할 수 있습니다. 공용 네트워크에서는 주의해서 사용하세요.

2. 컨테이너 내부의 사용자는 sudo 권한을 갖고 있습니다. 필요에 따라 Dockerfile에서 이 설정을 변경할 수 있습니다.

3. Docker Desktop과 VcXsrv는 최신 버전으로 유지하는 것이 좋습니다.

4. 그래픽 집약적인 애플리케이션의 경우 성능 제한이 있을 수 있습니다.

5. 오디오 기능이 필요한 AppImage의 경우, PulseAudio를 설정해야 할 수 있습니다.

## 9. 참고 자료

- [Docker 공식 문서](https://docs.docker.com/)
- [VcXsrv 프로젝트 페이지](https://sourceforge.net/projects/vcxsrv/)
- [Ubuntu 공식 문서](https://help.ubuntu.com/)
- [XFCE 공식 문서](https://docs.xfce.org/)
- [AppImage 공식 웹사이트](https://appimage.org/)
- [AppImageHub - AppImage 애플리케이션 디렉토리](https://appimage.github.io/)