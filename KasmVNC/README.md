# KasmVNC 기반 리눅스 GUI 개발환경

이 도커 이미지는 Ubuntu 22.04 기반의 XFCE4 데스크톱 환경을 제공하며, 웹 브라우저를 통해 접근할 수 있습니다.

## 주요 기능

- Ubuntu 22.04 LTS 기반
- XFCE4 데스크톱 환경
- KasmVNC를 이용한 웹 브라우저 기반 원격 접속
- 한국어 지원 (폰트, 입력기)
- Google Chrome 브라우저 내장
- VS Code 개발 환경 포함
- AppImage 실행을 위한 FUSE 지원
- 브라우저 창 크기에 맞게 조정되는 화면

## 빌드 및 실행 방법 (Docker Compose)

```bash
# 데이터 디렉토리 생성
mkdir -p data

# 컨테이너 실행
docker-compose up -d
```

## 빌드 방법 (Docker)

```bash
docker build -t kasmvnc-xfce4 .
```

## 실행 방법 (Docker)

```bash
docker run -d --privileged \
  -p 6901:6901 \
  -e VNC_PASSWORD=mypassword \
  --device /dev/fuse \
  -v /dev/fuse:/dev/fuse \
  -v ./data:/home/kasm-user/data \
  --cap-add SYS_ADMIN \
  --security-opt apparmor:unconfined \
  --name kasmvnc-desktop \
  kasmvnc-xfce4
```

## 환경 변수

- `VNC_PASSWORD`: VNC 접속 비밀번호 (지정하지 않으면 자동 생성됨)
- `RESOLUTION`: 화면 해상도 (기본값: 1920x1080)

## 접속 방법

웹 브라우저에서 다음 URL로 접속합니다:

```
http://localhost:6901
```

또는 서버 IP를 사용하여 접속:

```
http://<서버IP>:6901
```

## AppImage 실행 방법

다운로드 받은 AppImage 파일에 실행 권한을 부여한 후 실행합니다:

```bash
chmod +x myapp.AppImage
./myapp.AppImage
```

## 데이터 보존

`./data` 디렉토리가 컨테이너 내부의 `/home/kasm-user/data` 디렉토리에 마운트됩니다. 
중요한 파일들은 이 디렉토리에 저장하여 컨테이너를 재시작하거나 재구축해도 데이터가 유지되도록 하세요. 