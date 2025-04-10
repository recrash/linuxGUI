#!/bin/bash

# FUSE 모듈 로드 (컨테이너 시작 시 필요)
sudo modprobe fuse || true

# 로케일 설정 확인
export LANG=ko_KR.UTF-8
export LANGUAGE=ko_KR:ko
export LC_ALL=ko_KR.UTF-8

# 한글 입력기 환경 변수 설정
export XMODIFIERS=@im=ibus
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export QT4_IM_MODULE=ibus

# DISPLAY 환경변수 설정이 안 되어 있으면 기본값 설정
if [ -z "$DISPLAY" ]; then
    export DISPLAY=host.docker.internal:0.0
fi

# 다른 중요한 환경 변수 설정
export XAUTHORITY=$HOME/.Xauthority
export PULSE_SERVER=tcp:host.docker.internal

# AppImages 디렉토리 생성
mkdir -p $HOME/AppImages

# ibus 자동 시작 설정
mkdir -p ~/.config/autostart/
cat > ~/.config/autostart/ibus.desktop << EOF
[Desktop Entry]
Name=IBus
Comment=IBus Input Method
Exec=ibus-daemon -drx
Terminal=false
Type=Application
Categories=System;Utility;
StartupNotify=false
X-GNOME-AutoRestart=false
EOF

# XFCE 세션 시작 전 설정
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml/
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Greybird"/>
    <property name="IconThemeName" type="string" value="elementary-xfce"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="FontName" type="string" value="Nanum Gothic 11"/>
  </property>
</channel>
EOF

# XFCE 성능 최적화 설정
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="use_compositing" type="bool" value="false"/>
    <property name="shadow_opacity" type="int" value="0"/>
    <property name="frame_opacity" type="int" value="100"/>
    <property name="show_frame_shadow" type="bool" value="false"/>
    <property name="show_popup_shadow" type="bool" value="false"/>
  </property>
</channel>
EOF

# 배경화면 설정 간소화
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="image-style" type="int" value="0"/>
        <property name="color-style" type="int" value="0"/>
      </property>
    </property>
  </property>
</channel>
EOF

# 화면 보호기 비활성화
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-power-manager" version="1.0">
  <property name="xfce4-power-manager" type="empty">
    <property name="dpms-enabled" type="bool" value="false"/>
    <property name="blank-on-ac" type="int" value="0"/>
    <property name="blank-on-battery" type="int" value="0"/>
    <property name="brightness-switch-restore-on-exit" type="int" value="1"/>
    <property name="brightness-switch" type="int" value="0"/>
  </property>
</channel>
EOF

# 성능 최적화를 위한 추가 설정
# 불필요한 서비스 비활성화
mkdir -p ~/.config/autostart/
touch ~/.config/autostart/xfce4-power-manager.desktop
touch ~/.config/autostart/xfce4-screensaver.desktop

# ibus 환경 초기화 
ibus-daemon -drx &

# XFCE 세션 시작
startxfce4 --compositor=off &

# 컨테이너가 계속 실행되도록 함
tail -f /dev/null