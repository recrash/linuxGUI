FROM ubuntu:22.04

# 환경 변수 설정
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

# apt 저장소 업데이트 및 기본 시스템 패키지 설치
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    gnupg \
    sudo \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# XFCE 및 기본 패키지 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-terminal \
    xfce4-goodies \
    firefox \
    dbus-x11 \
    vim \
    locales \
    fonts-nanum \
    language-pack-ko \
    ibus \
    ibus-hangul \
    fonts-noto-cjk \
    libglib2.0-bin \
    file \
    desktop-file-utils \
    libgdk-pixbuf2.0-0 \
    git \
    unzip \
    ffmpeg \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# KasmVNC 관련 패키지 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    net-tools \
    xvfb \
    openssl \
    supervisor \
    python3-numpy \
    libxfont2 \
    xauth \
    xkb-data \
    libssl-dev \
    libxtst-dev \
    libjpeg-dev \
    libxrandr-dev \
    libfuse2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 로케일 설정
RUN sed -i 's/# ko_KR.UTF-8 UTF-8/ko_KR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen ko_KR.UTF-8 && \
    update-locale LANG=ko_KR.UTF-8 && \
    ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

ENV LANG=ko_KR.UTF-8
ENV LANGUAGE=ko_KR:ko
ENV LC_ALL=ko_KR.UTF-8
ENV XMODIFIERS=@im=ibus
ENV GTK_IM_MODULE=ibus
ENV QT_IM_MODULE=ibus

# 기본 사용자 생성
ARG USERNAME=user
ARG USER_UID=1002
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# KasmVNC 설치
RUN wget -q -O kasmvncserver.deb https://github.com/kasmtech/KasmVNC/releases/download/v1.2.0/kasmvncserver_jammy_1.2.0_amd64.deb \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y ./kasmvncserver.deb \
    && rm -f kasmvncserver.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# KasmVNC 설정 디렉토리 생성
RUN mkdir -p /home/$USERNAME/.vnc && \
    mkdir -p /etc/kasmvnc && \
    echo "password" > /home/$USERNAME/.vnc/passwd && \
    chmod 600 /home/$USERNAME/.vnc/passwd && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.vnc

# kasmvnc.yaml 설정
COPY kasmvnc.yaml /etc/kasmvnc/
RUN chmod 644 /etc/kasmvnc/kasmvnc.yaml

# XFCE 설정
RUN mkdir -p /home/$USERNAME/.config/xfce4/xfconf/xfce-perchannel-xml && \
    echo '<?xml version="1.0" encoding="UTF-8"?><channel name="displays" version="1.0"><property name="Default" type="empty"><property name="VNC-0" type="string" value="VNC 디스플레이"><property name="Active" type="bool" value="true"/><property name="Resolution" type="string" value="1280x720"/><property name="RefreshRate" type="double" value="60.000000"/><property name="Primary" type="bool" value="true"/><property name="Position" type="empty"><property name="X" type="int" value="0"/><property name="Y" type="int" value="0"/></property></property></property></channel>' > /home/$USERNAME/.config/xfce4/xfconf/xfce-perchannel-xml/displays.xml && \
    echo '<?xml version="1.0" encoding="UTF-8"?><channel name="xfce4-panel" version="1.0"><property name="panels" type="array"><value type="int" value="1"/><property name="panel-1" type="empty"><property name="position" type="string" value="p=8;x=640;y=760"/><property name="length" type="uint" value="100"/><property name="position-locked" type="bool" value="true"/></property></property></channel>' > /home/$USERNAME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.config

# Supervisor 설정
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# CSS 설정 파일 추가
RUN mkdir -p /usr/share/kasmvnc/www/app/styles/
COPY fullscreen.css /usr/share/kasmvnc/www/app/styles/

# 시작 스크립트
COPY start-kasmvnc.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-kasmvnc.sh

# 작업 디렉토리 설정
WORKDIR /home/$USERNAME

# 컨테이너 포트 노출
EXPOSE 6080

# 시작 명령
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
