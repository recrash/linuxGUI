FROM ubuntu:24.04

# 환경 변수 설정
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

# 기본 패키지 업데이트 및 설치
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    wget \
    gnupg \
    ca-certificates \
    dbus-x11 \
    sudo \
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
    curl \
    git \
    unzip \
    ffmpeg \
    software-properties-common \
    # NoVNC 관련 패키지
    net-tools \
    x11vnc \
    xvfb \
    openssl \
    supervisor \
    python3-pip \
    --no-install-recommends

# python으로 novnc 및 websockify 설치 (Ubuntu 패키지 대신)
RUN pip3 install numpy websockify && \
    mkdir -p /usr/local/share/novnc && \
    curl -k -L -o /tmp/novnc.zip https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.zip && \
    unzip /tmp/novnc.zip -d /tmp && \
    cp -a /tmp/noVNC-1.4.0/* /usr/local/share/novnc/ && \
    rm -rf /tmp/novnc.zip /tmp/noVNC-1.4.0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# FUSE 지원 패키지 설치
RUN apt-get update && apt-get install -y \
    libfuse2 \
    fuse \
    kmod \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# FUSE 설정
RUN chmod 4755 /bin/fusermount || true \
    && echo "user_allow_other" >> /etc/fuse.conf

# 로케일 설정
RUN sed -i 's/# ko_KR.UTF-8 UTF-8/ko_KR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen ko_KR.UTF-8 && \
    update-locale LANG=ko_KR.UTF-8

ENV LANG=ko_KR.UTF-8
ENV LANGUAGE=ko_KR:ko
ENV LC_ALL=ko_KR.UTF-8
ENV XMODIFIERS=@im=ibus
ENV GTK_IM_MODULE=ibus
ENV QT_IM_MODULE=ibus
ENV QT4_IM_MODULE=ibus

# Chrome 설치
RUN mkdir -p /etc/apt/keyrings \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg \
    && chmod a+r /etc/apt/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 기본 사용자 생성
ARG USERNAME=user
ARG USER_UID=1002
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# AppImage 헬퍼 디렉토리 생성
RUN mkdir -p /home/$USERNAME/AppImages \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/AppImages

# x11vnc용 비밀번호 설정
RUN mkdir -p /home/$USERNAME/.vnc && \
    echo "password" > /home/$USERNAME/.vnc/passwd && \
    chmod 600 /home/$USERNAME/.vnc/passwd && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.vnc

# Supervisor 설정
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 작업 디렉토리 설정
WORKDIR /home/$USERNAME

# 컨테이너 포트 노출
EXPOSE 8080

# 시작 명령
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
