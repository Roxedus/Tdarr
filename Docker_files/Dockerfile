# syntax=docker/dockerfile:1.0

ARG bundle="base:bundle"
ARG bin_stage="base:binaries"

FROM ${bundle} AS Bundle
FROM ${bin_stage} AS BinStage

ARG BASE_IMAGE
FROM ${BASE_IMAGE:-ubuntu@sha256:3013b0d761d4bad6ff16dd2805887a2f2c3fc140d6206086698b5c3e44e0f7fe}

LABEL maintainer="<Roxedus,me@roxedus.dev>"

ENV PUID="1000" PGID="1000" UMASK="002" TZ="Etc/UTC" HOME="/home/Tdarr" MONGO_URL="mongodb://localhost:27017/Tdarr" PORT="8265" ROOT_URL="http://localhost"
ENV LANGUAGE="en_US.UTF-8" LANG="en_US.UTF-8" NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" DEBIAN_FRONTEND="noninteractive"
ENV S6_REL=2.0.0.1 NODE_VERSION=8 MONGO_VERSION=4.2

RUN apt update && \
    apt install -y apt-utils locales tzdata && \
        locale-gen "${LANG}" && \
        dpkg-reconfigure locales && \
    apt upgrade -y && \
    apt install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        curl \
        gnupg \
        gvfs-bin \
        libgl1-mesa-dev \
        libgl1-mesa-glx \
        libx11-dev \
        libssl-dev \
        vainfo \
        vdpauinfo \
        netcat \
        software-properties-common \
        subversion \
        unzip && \
    # add 3rd party repos and packages
    DISTRO="$(lsb_release -s -c)" && \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    curl -sSL https://www.mongodb.org/static/pgp/server-$MONGO_VERSION.asc |  apt-key add - && \
    echo "deb https://deb.nodesource.com/node_$NODE_VERSION.x $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb https://repo.mongodb.org/apt/ubuntu $DISTRO/mongodb-org/$MONGO_VERSION multiverse" | tee /etc/apt/sources.list.d/mongodb-org.list && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        mongodb-org \
        nodejs && \
    # install s6-overlay
    curl -o /tmp/s6-overlay.tar.gz -L \
        "https://github.com/just-containers/s6-overlay/releases/download/v${S6_REL}/s6-overlay-amd64.tar.gz" && \
    tar xfz /tmp/s6-overlay.tar.gz -C / && \
    # create folders, set permissions
    mkdir -p \
        /app \
        /logs \
        /temp \
        "${HOME}" && \
    useradd -u ${PUID} -U -d ${HOME} -s /bin/false Tdarr && \
    usermod -G users Tdarr && \
    # download and unpack app
    # curl -o /tmp/bundle.zip -L \
    #     "https://github.com/HaveAGitGat/Tdarr/releases/download/${VERSION}/Tdarr-Linux.zip" && \
    # unzip -q /tmp/bundle.zip -d /app -x *.exe && \
    # clean up
    apt purge -y \
        curl \
        gnupg \
        software-properties-common \
        unzip && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY --from=Bundle /app /app
COPY --from=BinStage / /
COPY root/ /

EXPOSE ${PORT}
ENTRYPOINT ["/init"]