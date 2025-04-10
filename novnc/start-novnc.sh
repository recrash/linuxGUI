#!/bin/bash

# FUSE 모듈 로드 시도 (컨테이너 시작 시 필요)
sudo modprobe fuse || true

# VNC 서버 시작 - 여러 가능한 명령어 이름 시도
VNC_CMD=""
for cmd in tigervncserver vncserver Xvnc x11vnc; do
  if command -v $cmd >/dev/null 2>&1; then
    VNC_CMD=$cmd
    echo "Found VNC server command: $VNC_CMD"
    break
  fi
done

if [ -z "$VNC_CMD" ]; then
  echo "Error: No VNC server command found"
  exit 1
fi

# 기존 VNC 세션 정리
pkill -f Xvnc || true
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 || true

# 패스워드 파일 확인
if [ ! -f ~/.vnc/passwd ]; then
  mkdir -p ~/.vnc
  echo -n "password" | openssl passwd -1 -stdin > ~/.vnc/passwd
  chmod 600 ~/.vnc/passwd
fi

# VNC 서버 시작
if [ "$VNC_CMD" = "tigervncserver" ] || [ "$VNC_CMD" = "vncserver" ]; then
  $VNC_CMD :1 -geometry 1280x800 -depth 24 -localhost no -SecurityTypes VncAuth -PasswordFile $HOME/.vnc/passwd
elif [ "$VNC_CMD" = "Xvnc" ]; then
  $VNC_CMD :1 -geometry 1280x800 -depth 24 -rfbport 5901 -SecurityTypes VncAuth -PasswordFile $HOME/.vnc/passwd &
  sleep 2
  DISPLAY=:1 startxfce4 &
elif [ "$VNC_CMD" = "x11vnc" ]; then
  Xvfb :1 -screen 0 1280x800x24 &
  sleep 2
  DISPLAY=:1 startxfce4 &
  sleep 2
  x11vnc -display :1 -rfbport 5901 -forever -passwd password &
fi

# 컨테이너가 계속 실행되도록 함
tail -f /dev/null 