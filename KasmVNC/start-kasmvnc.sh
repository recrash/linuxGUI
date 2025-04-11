#!/bin/bash
set -x

# 디버깅 정보 출력
echo "DEBUG: 스크립트 시작"
echo "DEBUG: PATH = $PATH"
echo "DEBUG: 디렉토리 확인"
ls -la /usr/bin | grep -i vnc
ls -la /usr/local/bin | grep -i vnc
echo "DEBUG: which 명령어 확인"
which vncserver || echo "vncserver not found"
which Xvfb || echo "Xvfb not found"

# FUSE 모듈 로드 시도 (컨테이너 시작 시 필요)
sudo modprobe fuse || echo "FUSE 모듈 로드 실패 (무시 가능)"

# 기존 VNC 세션 종료
pkill -f vncserver || echo "No vncserver process to kill"
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 || echo "No VNC lock files to remove"

# KasmVNC 설정 파일 복사
if [ -f "/home/user/kasmvnc.yaml" ]; then
    echo "KasmVNC 설정 파일을 복사합니다..."
    mkdir -p /etc/kasmvnc
    cp /home/user/kasmvnc.yaml /etc/kasmvnc/kasmvnc.yaml
    chmod 644 /etc/kasmvnc/kasmvnc.yaml
fi

# KasmVNC 패스워드 설정
if [ ! -f /home/user/.vnc/passwd ]; then
    echo "KasmVNC 패스워드를 설정합니다..."
    mkdir -p /home/user/.vnc
    echo -e "password\npassword\n" | vncpasswd /home/user/.vnc/passwd
    chmod 600 /home/user/.vnc/passwd
fi

# CSS 파일 복사
if [ -f "/home/user/fullscreen.css" ]; then
    echo "CSS 파일을 복사합니다..."
    mkdir -p /usr/share/kasmvnc/www/app/styles
    cp /home/user/fullscreen.css /usr/share/kasmvnc/www/app/styles/fullscreen.css
fi

# KasmVNC 서버 시작
echo "KasmVNC 서버를 시작합니다..."
vncserver -blacklistthreshold=0 -SecurityTypes VncAuth -PasswordFile=/home/user/.vnc/passwd -disableBasicAuth -geometry 1280x720 -depth 24 -fg -xstartup /usr/bin/startxfce4 -listen 0.0.0.0 -websocketPort 6080 -httpd /usr/share/kasmvnc/www :1

echo "KasmVNC 서버가 시작되었습니다"
echo "웹 브라우저에서 http://localhost:6080/으로 접속하세요."

# 컨테이너가 계속 실행되도록 함
tail -f /dev/null 