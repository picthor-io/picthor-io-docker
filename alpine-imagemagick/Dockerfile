FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
ARG IM_RELEASE=7.1.0-25

RUN apt update -y &&\
    apt upgrade -y &&\
    apt install --no-install-recommends -y git openssh-client ca-certificates build-essential \
    perl curl libjbig-dev opencl-headers libglu1-mesa-dev libgxps-dev chrpath libzstd-dev x11proto-dev \
    liblcms2-dev libraqm-dev liblqr-1-0-dev fftw-dev libxml2-dev \
    libxext-dev libx11-dev bzip2 zlib1g-dev libltdl-dev libdjvulibre-dev libraw-dev openexr libheif-dev \
    libopenjp2-7-dev libjpeg-turbo8-dev libghc-lzma-dev libglib2.0-dev libcairo2-dev libpango1.0-dev libpng-dev \
    librsvg2-dev libtiff-dev libwebp-dev libwmf-dev ocl-icd-dev ttf-dejavu libzip-dev  \
    libhighwayhash-dev libdmalloc-dev libfreetype6-dev libopenjp2-7-dev \
    ffmpeg libimage-exiftool-perl &&\
    ##
    ##
    mkdir -p /root/.ssh &&\
    chmod 0700 /root/.ssh &&\
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts &&\
    ##
    ##
    mkdir /build && cd /build &&\
    ##
    ##
    git clone https://github.com/ImageMagick/ImageMagick.git /build/ImageMagick &&\
    cd /build/ImageMagick &&\
    git checkout ${IM_RELEASE} &&\
    ./configure \
        --prefix='/usr' \
        --sysconfdir='/etc' \
        --enable-shared \
        --disable-static \
        --enable-openmp \
        --enable-opencl \
        --disable-delegate-build \
        --enable-cipher \
        --enable-hdri \
        #--enable-docs \
        --with-dmalloc \
        --with-threads \
        --with-modules \
        --with-quantum-depth="32" \
        --with-magick-plus-plus \
        --without-perl \
        --without-jemalloc \
        --with-tcmalloc \
        --with-umem \
        --with-bzlib \
        --with-x \
        --with-zlib \
        --with-zstd \
        --without-autotrace \
        --without-dps \
        --with-fftw \
        #--with-flif \
        --with-fpx \
        #--with-djvu \
        #--with-fontconfig \
        --with-freetype \
        --with-raqm \
        --without-gslib \
        --with-gvc \
        --with-heic \
        --with-jbig \
        --with-jpeg \
        # --with-jxl \
        --with-lcms \
        --with-openjp2 \
        --with-lqr \
        --with-lzma \
        --with-openexr \
        #--with-pango \
        --with-png \
        --with-raw \
        --with-rsvg \
        --with-tiff \
        --with-webp \
        --with-wmf \
        --with-xml \
        --with-dejavu-font-dir='/usr/share/fonts/truetype/dejavu' \
        --with-fontpath='/usr/share/fonts/Type1' &&\
    make && make install && ldconfig /usr/local/lib &&\
    ##
    cd / && rm -rf /build &&\
    apt remove --autoremove --purge -y git openssh-client build-essential \
        libjbig-dev opencl-headers libglu1-mesa-dev libgxps-dev chrpath libzstd-dev x11proto-dev \
        liblcms2-dev libraqm-dev liblqr-1-0-dev fftw-dev libxml2-dev \
        libxext-dev libx11-dev zlib1g-dev libltdl-dev libdjvulibre-dev libraw-dev libheif-dev \
        libopenjp2-7-dev libjpeg-turbo8-dev libghc-lzma-dev libglib2.0-dev libcairo2-dev libpng-dev \
        ghostscript librsvg2-dev libtiff-dev libwebp-dev libwmf-dev ocl-icd-dev libzip-dev  \
        libhighwayhash-dev libdmalloc-dev libfreetype6-dev libopenjp2-7-dev &&\
    apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*