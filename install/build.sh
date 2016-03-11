#!/bin/bash

# Add users
useradd -u 1000 -m -g users -G wheel llvm
echo -n llvm:llvm | chpasswd
echo -n root:root | chpasswd

# Add multilib to pacman
sed -i 's/#\[multilib\]/[multilib]/' /etc/pacman.conf
sed -i 's/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/' /etc/pacman.conf

# Migrate to multilib
yes | pacman -Sy gcc-libs-multilib

pacman --noconfirm -Sy \
  curl \
  openssh \
  sudo \
  vim \
  git \
  subversion \
  patch \
  quilt \
  rsync \
  make \
  cmake \
  ninja \
  fakeroot \
  bc \
  binutils \
  gdb \
  valgrind \
  strace \
  gcc-multilib \
  clang \
  python \
  xmlto \
  docbook-xsl \
  lib32-zlib \
  zlib

# Add Linaro toolchain
curl -q -L 'https://releases.linaro.org/14.09/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.bz2' -O && \
  tar xf gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.bz2 && \
  rsync -a gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/ /usr/local &&
  rm -rf gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux &&
  rm -rf gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.bz2

# Set gold as default linker
ln -s /usr/bin/ld.gold /usr/local/bin/ld

# Configure sshd
ssh-keygen -A
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Configure sudo
sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

# Clear pacman cache
pacman --noconfirm -Sc
