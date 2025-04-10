#!/bin/bash

# FUSE 모듈 로드 시도 (컨테이너 시작 시 필요)
sudo modprobe fuse || true

# 기존 VNC 세션 종료
pkill -f Xvnc || true
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 || true

# 사용 가능한 VNC 서버 명령어 검색
if command -v vncserver &> /dev/null; then
    echo "Using vncserver command"
    vncserver :1 -geometry 1280x800 -depth 24 -localhost no
elif command -v tigervncserver &> /dev/null; then
    echo "Using tigervncserver command"
    tigervncserver :1 -geometry 1280x800 -depth 24 -localhost no
elif command -v Xvnc &> /dev/null; then
    echo "Using Xvnc command directly"
    Xvnc :1 -geometry 1280x800 -depth 24 -rfbport 5901 -localhost no &
    sleep 2
    DISPLAY=:1 startxfce4 &
else
    echo "No VNC server command found. Trying alternative approaches..."
    # 대체 방법: x11vnc + Xvfb
    if command -v Xvfb &> /dev/null && command -v x11vnc &> /dev/null && command -v startxfce4 &> /dev/null; then
        Xvfb :1 -screen 0 1280x800x24 &
        sleep 2
        DISPLAY=:1 startxfce4 &
        sleep 2
        x11vnc -display :1 -rfbport 5901 -nopw -forever &
    else
        echo "Critical error: No compatible VNC server found"
        exit 1
    fi
fi

# VNC 서버 시작 확인
echo "VNC server started"
echo "웹 브라우저에서 http://localhost:6080/vnc.html로 접속하세요."

# 컨테이너가 계속 실행되도록 함
tail -f /dev/null 