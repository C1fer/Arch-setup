#!/bin/sh
#Clone repo
if [ -d "/home/rusbel/Arch-setup" ] ; then
 rm -rf /home/rusbel/Arch-setup
else
 :
fi
sudo pacman -S --noconfirm git reflector rsync
sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
git clone https://github.com/C1fer/Arch-setup.git  && cd Arch-setup
source ./functions.sh
sudo cpupower frequency-set -g performance
sudo sed -i 's/MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/' "/etc/makepkg.conf"
sudo sed -i 's/governor='performance'/governor='performance'/g' /etc/default/cpupower 

#pacman_conf_signoff
#mirrors
#Set up keys
#sudo rm -rf /etc/pacman.d/gnupg/gpg.conf
#sudo pacman-key --init
#echo keyserver hkp://ipv4.pool.sks-keyservers.net:11371 | sudo tee -a /etc/pacman.d/gnupg/gpg.conf
#sudo pacman-key --populate archlinux


#SOFTWARE
sudo pacman -Syyu --noconfirm pacman-contrib yay zsh-theme-powerlevel10k-git chaotic-keyring chaotic-mirrorlist p7zip unrar  fuseiso git base-devel ninja cmake sdl2 qt5 python2 python-pip boost catch2 fmt libzip lz4 mbedtls nlohmann-json openssl opus zlib ccache zstd ntfs-3g ufw gufw wget nano  bluez bluez-utils
sudo pacman -Rdd --noconfirm llvm-libs mesa
yay -S --noconfirm conan aria2 noto-fonts-cjk ttf-opensans ttf-meslo-nerd-font-powerlevel10k gstreamer mesa-demos libva-utils vulkan-tools llvm-git llvm-libs-git lib32-llvm-git clang-git meson mesa-git lib32-mesa-git vulkan-radeon-git lib32-vulkan-radeon-git linux-tkg-pds-zen linux-tkg-pds-zen-headers
#Others
yay -S --noconfirm plasma-meta arc-kde-git arc-gtk-theme mkvtoolnix-gui plasma5-applets-eventcalendar spek-git spectacle brave qbittorrent mangohud goverlay-git puddletag-git psensor ark gwenview krename steam gnome-disk-utility nano qdirstat-git grub-customizer htop gedit bc gparted audacious systemd-swap kde-servicemenus-rootactions qmplay2-git ffmpegthumbs neofetch papirus-folders-git jdownloader2
if [ $? -ne 0 ]; then 
 exit
else
 :
 fi
 
#Cleaning
sudo pacman -Rdd --noconfirm vim chromium discover oxygen plasma-thunderbolt plasma-browser-integration
yay -Sc --noconfirm && sudo pacman -Rns --noconfirm $(pacman -Qtdq)
sudo rm -rf /var/cache/pacman/pkg ~/.cache/yay
#pacman_conf

#idk
echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
export PATH="/usr/lib/ccache/bin/:$PATH"
export EDITOR="/usr/bin/nano"
alias mesa=' yay -S llvm-git llvm-libs-git lib32-llvm-git lib32-llvm-libs-git mesa-git lib32-mesa-git lib32-vulkan-radeon-git  vulkan-radeon-git'' | tee -a ~/.zshrc
papirus-folders -C bluegrey --theme Papirus-Dark

#Functions 
enable_zram
fstab
amdgpu_conf
amdgpu_oc
ds4_touchpad 
enable_bt
