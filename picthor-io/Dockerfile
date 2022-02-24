ARG UI_RELEASE
ARG SERVER_RELEASE
ARG HZ_FRAMEWORK_BRANCH=1.0.5
ARG PICTHOR_SERVER_PORT=5001

## base
FROM archlinux:latest as base
RUN pacman -Sy --noconfirm reflector fish
RUN reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

## base builder
FROM base as builder-base
RUN pacman -S --noconfirm git fish openssh zip unzip gradle nodejs-lts-gallium npm perl-image-exiftool
RUN mkdir /root/.ssh
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

## ui builder
FROM builder-base as ui-builder
ARG UI_RELEASE
WORKDIR /root
RUN git clone --depth 1 --branch $UI_RELEASE https://github.com/picthor-io/picthor-io-ui.git
RUN /usr/bin/npm install -g @angular/cli
WORKDIR /root/picthor-io-ui
RUN npm install
RUN ng build

## server-builder
FROM builder-base as server-builder
ARG HZ_FRAMEWORK_BRANCH
ARG SERVER_RELEASE

WORKDIR /root
RUN git clone --depth 1 --branch $HZ_FRAMEWORK_BRANCH https://github.com/realcnbs/horizon-framework.git
WORKDIR /root/horizon-framework
RUN JAVA_HOME=/usr/lib/jvm/default-runtime gradle publishToMavenLocal

WORKDIR /root
RUN git clone --depth=1 --branch $SERVER_RELEASE https://github.com/picthor-io/picthor-io-server.git
WORKDIR /root/picthor-io-server
RUN JAVA_HOME=/usr/lib/jvm/default-runtime gradle bootJar --stacktrace

## app image
FROM picthorio/arch-imagemagick-full:latest

RUN pacman --noconfirm -Sy xxhash ffmpeg jre-openjdk perl-image-exiftool && \
    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
    rm -rf /build /home/aur /var/cache/* /var/log/* /tmp/*

ARG RELEASE
LABEL \
    org.opencontainers.image.authors="Vitali Carbivnicii realcnbs@gmail.com" \
    org.opencontainers.image.version=$RELEASE

WORKDIR /root
COPY --from=ui-builder /root/picthor-io-ui/dist/picthor-io /root/picthor-io-ui-dist
COPY --from=server-builder /root/picthor-io-server/build/libs/picthor-io-server.jar /root/picthor.io.jar
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
