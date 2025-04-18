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
    # FUSE 지원을 위한 패키지
    libfuse2t64 \
    fuse \
    kmod \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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

# VSCode 설치
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" \
    && apt-get update \
    && apt-get install -y code \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*    

# 기본 사용자 생성
ARG USERNAME=user
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# AppImage 헬퍼 디렉토리 생성
RUN mkdir -p /home/$USERNAME/AppImages \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/AppImages

# 작업 디렉토리 설정
WORKDIR /home/$USERNAME

# .Xauthority 파일 생성
RUN touch /home/$USERNAME/.Xauthority \
    && chown $USERNAME:$USERNAME /home/$USERNAME/.Xauthority

# 시작 스크립트 생성
COPY start-xfce.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-xfce.sh

# 일반 사용자로 전환
USER $USERNAME

CMD ["/usr/local/bin/start-xfce.sh"]