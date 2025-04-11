#!/bin/bash

# XFCE 설정 디렉토리 생성
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml

# 화면 설정
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/displays.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="displays" version="1.0">
  <property name="Default" type="empty">
    <property name="VNC-0" type="string" value="VNC 디스플레이">
      <property name="Active" type="bool" value="true"/>
      <property name="Resolution" type="string" value="1280x720"/>
      <property name="RefreshRate" type="double" value="60.000000"/>
      <property name="Primary" type="bool" value="true"/>
      <property name="Position" type="empty">
        <property name="X" type="int" value="0"/>
        <property name="Y" type="int" value="0"/>
      </property>
    </property>
  </property>
</channel>
EOF

# 패널 설정
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=8;x=640;y=760"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
      </property>
    </property>
  </property>
</channel>
EOF

# 데스크톱 설정
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="image-path" type="string" value="/usr/share/backgrounds/xfce/xfce-blue.jpg"/>
        <property name="last-image" type="string" value="/usr/share/backgrounds/xfce/xfce-blue.jpg"/>
        <property name="last-single-image" type="string" value="/usr/share/backgrounds/xfce/xfce-blue.jpg"/>
      </property>
    </property>
  </property>
</channel>
EOF 