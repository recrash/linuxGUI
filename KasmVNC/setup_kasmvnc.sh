#!/bin/bash

set -e

# 필요한 디렉토리 생성
mkdir -p /etc/kasmvnc
mkdir -p /home/user/.vnc

# KasmVNC 설정 파일 복사
cp kasmvnc.yaml /etc/kasmvnc/kasmvnc.yaml

# KasmVNC 설정 권한 설정
chmod 644 /etc/kasmvnc/kasmvnc.yaml

# 패스워드 설정
if [ ! -f /home/user/.vnc/passwd ]; then
  echo "KasmVNC 패스워드 설정"
  mkdir -p /home/user/.vnc
  echo "password" | vncpasswd -f > /home/user/.vnc/passwd
  chmod 600 /home/user/.vnc/passwd
  chown -R user:user /home/user/.vnc
fi

# CSS 파일 복사
mkdir -p /usr/share/kasmvnc/www/app/styles
cp fullscreen.css /usr/share/kasmvnc/www/app/styles/

# 권한 설정
chown -R user:user /home/user/.vnc
chown -R user:user /home/user/.config

echo "KasmVNC 설정이 완료되었습니다."
echo "브라우저에서 http://localhost:6080/vnc.html 에 접속하여 확인하세요." 