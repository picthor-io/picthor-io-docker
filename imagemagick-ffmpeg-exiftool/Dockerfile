#FROM oblique/archlinux-yay
#
#RUN yay -S --noconfirm imagemagick-full && \
#    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
#    pacman --noconfirm -Rcns fakeroot sudo binutils make gcc git yay && \
#    rm -rf /build /home/aur /var/cache/* /var/log/* /tmp/* \

FROM archlinux:base

RUN pacman --noconfirm -Sy git glibc fakeroot sudo binutils make gcc patch pkg-config autoconf automake && \
    useradd -m -r -s /bin/bash aur && \
    passwd -d aur && \
    echo 'aur ALL=(ALL) ALL' > /etc/sudoers.d/aur && \
    mkdir -p /home/aur/.gnupg && \
    echo 'standard-resolver' > /home/aur/.gnupg/dirmngr.conf && \
    chown -R aur:aur /home/aur && \
    mkdir /build && \
    chown -R aur:aur /build && \
    cd /build && \
    sudo -u aur git clone --depth 1 https://aur.archlinux.org/yay.git && \
    cd yay && \
    sudo -u aur makepkg --noconfirm -si && \
    sudo -u aur yay -S --noconfirm imagemagick-full && \
    pacman --noconfirm -Rcns fakeroot sudo binutils make gcc patch autoconf automake git yay && \
    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
    rm -rf /build /home/aur /var/cache/* /var/log/* /tmp/*