ARG UI_BRANCH=main
ARG SERVER_BRANCH=main
ARG HZ_FRAMEWORK_BRANCH=1.0.5
ARG PICTHOR_SERVER_PORT=5001
ARG API_URL=http://localhost:5001
ARG SITE_URL=http://localhost:5001

## base
FROM archlinux:latest as base
RUN pacman -Sy --noconfirm reflector fish
RUN reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

## base builder
FROM base as builder-base
RUN pacman -S --noconfirm git fish openssh zip unzip gradle nodejs-lts-gallium npm exiftool
RUN mkdir /root/.ssh
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

## ui builder
FROM builder-base as ui-builder
ARG UI_BRANCH
WORKDIR /root
RUN git clone --depth 1 --branch $UI_BRANCH https://github.com/picthor-io/picthor-io-ui.git
RUN /usr/bin/npm install -g @angular/cli
WORKDIR /root/picthor-io-ui
RUN npm install
RUN ng build

## server-builder
FROM builder-base as server-builder
ARG HZ_FRAMEWORK_BRANCH
ARG SERVER_BRANCH

WORKDIR /root
RUN git clone --depth 1 --branch $HZ_FRAMEWORK_BRANCH https://github.com/realcnbs/horizon-framework.git
WORKDIR /root/horizon-framework
RUN JAVA_HOME=/usr/lib/jvm/default-runtime gradle publishToMavenLocal

WORKDIR /root
RUN git clone --depth=1 --branch $SERVER_BRANCH https://github.com/picthor-io/picthor-io-server.git
WORKDIR /root/picthor-io-server
RUN JAVA_HOME=/usr/lib/jvm/default-runtime gradle bootJar --stacktrace

## app image
FROM picthorio/arch-imagemagick-full:latest
RUN pacman -Sy
RUN pacman -S --noconfirm xxhash ffmpeg jre-openjdk fish htop

ARG APP_VERSION=1.0.0-BETA
LABEL \
    org.opencontainers.image.authors="Vitali Carbivnicii realcnbs@gmail.com" \
    org.opencontainers.image.version=$APP_VERSION

WORKDIR /root
RUN echo "/root/picthor-io-server/build/libs/picthor.io-${APP_VERSION}.jar"
COPY --from=ui-builder /root/picthor-io-ui/dist/picthor-io /root/picthor-io-ui-dist
COPY --from=server-builder /root/picthor-io-server/build/libs/picthor.io-$APP_VERSION.jar /root/picthor.io.jar
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
