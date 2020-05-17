FROM ubuntu@sha256:e5dd9dbb37df5b731a6688fa49f4003359f6f126958c9c928f937bec69836320 AS BuildHandBrake

RUN apt update -qq && \
    apt -y install \
    autoconf \
    automake \
    autopoint \
    build-essential \
    bzip2 \
    cmake \
    git-core \
    libass-dev \
    libbz2-dev \
    libfdk-aac-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libgtk-3-dev \
    libharfbuzz-dev \
    libjansson-dev \
    liblzma-dev \
    libmp3lame-dev \
    libnuma-dev \
    libogg-dev \
    libopus-dev \
    libsamplerate-dev \
    libsdl2-dev \
    libspeex-dev \
    libtheora-dev \
    libtool \
    libtool-bin \
    libtool-bin \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libvpx-dev \
    libx264-dev \
    libx265-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    libxcb1-dev \
    libxml2-dev \
    m4 \
    make \
    nasm \
    nasm yasm \
    ninja-build \
    patch \
    pkg-config \
    python \
    python3 \
    python3-pip \
    tar \
    texinfo \
    wget \
    zlib1g-dev && \
    pip3 install meson && \
    git clone https://github.com/HandBrake/HandBrake.git && \
    cd HandBrake && \
    git tag --list | grep ^1\.3\. && \
    git checkout refs/tags/$(git tag -l | grep -E '^1\.3\.1' | tail -n 1) && \
    ./configure --enable-qsv --launch-jobs=8 --launch --force && \
    make --directory=build install


FROM ubuntu@sha256:e5dd9dbb37df5b731a6688fa49f4003359f6f126958c9c928f937bec69836320
LABEL maintainer="Roxedus"

ARG VERSION="v1.108-Beta"
ENV VERSION="${VERSION}"

ARG DEBIAN_FRONTEND="noninteractive"

ENV PUID="1000" PGID="1000" UMASK="002" TZ="Etc/UTC" HOME="/home/Tdarr" MONGO_URL="mongodb://localhost:27017/Tdarr" PORT="8265" ROOT_URL="http://localhost"
ENV LANGUAGE="en_US.UTF-8" LANG="en_US.UTF-8" NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"
ENV S6_REL=2.0.0.1

# install dependencies

# = Seemingly no effect
## = Description sounds unrelated
### = Desktop enviroment dependencies

RUN apt update && \
    apt install -y apt-utils locales tzdata && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    apt upgrade -y && \
    apt install -y --no-install-recommends --no-install-suggests \
    #        build-essential \
    ca-certificates \
    #        coreutils \
    curl \
    #        dnsutils \
    #        gcc \
    ##        gcc-multilib \
    gnupg \
    #        gstreamer1.0-plugins-bad \
    #        gstreamer1.0-plugins-ugly \
    gvfs-bin \
    #        libavcodec-extra \
    #        libavcodec-extra57 \
    ###        libcanberra-gtk-module \
    ##        libcurl4-gnutls-dev \
    #        libdvdnav4 \
    #        libdvdread4 \
    ###        libglib2.0-bin \
    #        libleptonica-dev \
    ###        libnotify4 \
    #        libnss3 \
    #        libtesseract-dev \
    #        libxss1 \
    mongodb-server \
    netcat \
    ###        packagekit-gtk3-module \
    software-properties-common \
    subversion \
    ##        tesseract-ocr \
    unzip && \
    #        ubuntu-restricted-extras \
    ###        xdg-utils \
    # add 3rd party repos and packages
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    NODE_VERSION=node_8.x NODE_DISTRO="$(lsb_release -s -c)" && \
    echo "deb https://deb.nodesource.com/$NODE_VERSION $NODE_DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/$NODE_VERSION $NODE_DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    add-apt-repository ppa:jonathonf/ffmpeg-4 && \
    add-apt-repository ppa:stebbins/handbrake-releases && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
    ffmpeg \
    handbrake-cli \
    nodejs && \
    # install s6-overlay
    curl -o /tmp/s6-overlay.tar.gz -L \
    "https://github.com/just-containers/s6-overlay/releases/download/v${S6_REL}/s6-overlay-amd64.tar.gz" && \
    tar xfz /tmp/s6-overlay.tar.gz -C / && \
    # create folders, set permissions
    mkdir -p \
    /app \
    /temp \
    /data/db \
    "${HOME}" && \
    useradd -u ${PUID} -U -d ${HOME} -s /bin/false Tdarr && \
    usermod -G users Tdarr && \
    chown Tdarr:Tdarr /app && \
    # download and unpack app
    curl -o /tmp/bundle.zip -L \
    "https://github.com/HaveAGitGat/Tdarr/releases/download/${VERSION}/Tdarr-Linux.zip" && \
    s6-setuidgid Tdarr unzip -q /tmp/bundle.zip -d /app -x *.exe && \
    # clean up
    apt purge -y \
    curl \
    gnupg \
    unzip && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
COPY --from=BuildHandBrake /usr/local/bin/HandBrakeCLI /usr/local/bin/HandBrakeCLI
COPY --chown=${PUID}:${PGID} root/ /
EXPOSE ${PORT}
ENTRYPOINT ["/init"]