#!/bin/bash
set -x

# 디버깅 정보 출력
echo "DEBUG: 스크립트 시작"
echo "DEBUG: PATH = $PATH"
echo "DEBUG: 디렉토리 확인"
ls -la /usr/bin | grep -i vnc
ls -la /usr/bin | grep -i tiger
ls -la /usr/local/bin | grep -i vnc
echo "DEBUG: which 명령어 확인"
which vncserver || echo "vncserver not found"
which tigervnc || echo "tigervnc not found"
which tigervncserver || echo "tigervncserver not found"
which Xvnc || echo "Xvnc not found"
which x11vnc || echo "x11vnc not found"
which Xvfb || echo "Xvfb not found"

# FUSE 모듈 로드 시도 (컨테이너 시작 시 필요)
sudo modprobe fuse || echo "FUSE 모듈 로드 실패 (무시 가능)"

# 기존 VNC 세션 종료
pkill -f Xvnc || echo "No Xvnc process to kill"
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 || echo "No VNC lock files to remove"

# 사용 가능한 VNC 서버 명령어 검색
if command -v vncserver &> /dev/null; then
    echo "Using vncserver command"
    vncserver :1 -geometry 1280x800 -depth 24 -localhost no || echo "vncserver failed"
elif command -v tigervncserver &> /dev/null; then
    echo "Using tigervncserver command"
    tigervncserver :1 -geometry 1280x800 -depth 24 -localhost no || echo "tigervncserver failed"
elif command -v Xvnc &> /dev/null; then
    echo "Using Xvnc command directly"
    Xvnc :1 -geometry 1280x800 -depth 24 -rfbport 5901 -localhost no &
    sleep 2
    DISPLAY=:1 startxfce4 &
else
    echo "No VNC server command found. Trying alternative approaches..."
    # 대체 방법: x11vnc + Xvfb
    if command -v Xvfb &> /dev/null && command -v x11vnc &> /dev/null && command -v startxfce4 &> /dev/null; then
        echo "Using Xvfb + x11vnc approach"
        Xvfb :1 -screen 0 1280x800x24 &
        sleep 2
        DISPLAY=:1 startxfce4 &
        sleep 2
        x11vnc -display :1 -rfbport 5901 -nopw -forever &
    else
        echo "Critical error: No compatible VNC server found"
        ls -la /usr/bin
        echo "Will try a hard-coded approach..."
        # 하드코딩된 접근 방식 시도
        if [ -f /usr/bin/x11vnc ] && [ -f /usr/bin/Xvfb ]; then
            echo "Found x11vnc and Xvfb, trying a direct approach"
            /usr/bin/Xvfb :1 -screen 0 1280x800x24 &
            sleep 2
            DISPLAY=:1 /usr/bin/startxfce4 &
            sleep 2
            /usr/bin/x11vnc -display :1 -rfbport 5901 -nopw -forever &
        else
            echo "All approaches failed. Exiting."
            exit 1
        fi
    fi
fi

# VNC 서버 시작 확인
echo "VNC server started"
echo "웹 브라우저에서 http://localhost:6080/vnc.html로 접속하세요."

# 컨테이너가 계속 실행되도록 함
tail -f /dev/null 