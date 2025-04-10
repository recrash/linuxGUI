#!/bin/bash

# FUSE 모듈 로드 시도 (컨테이너 시작 시 필요)
sudo modprobe fuse || true

# VNC 서버 시작
vncserver :1 -geometry 1280x800 -depth 24 -localhost no

# 컨테이너가 계속 실행되도록 함
tail -f /dev/null 