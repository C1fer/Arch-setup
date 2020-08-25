#!/bin/sh
#Clone repo
if [ -d "/home/rusbel/Arch-setup" ] ; then
 rm -rf /home/rusbel/Arch-setup
else
 :
fi
sudo pacman -S --noconfirm git
git clone https://github.com/C1fer/Arch-setup.git  && cd Arch-setup
source ./functions.sh
pacman_conf
mirrors
#Keys setup
sudo rm -rf /etc/pacman.d/gnupg/gpg.conf
sudo pacman-key --init
echo keyserver hkp://ipv4.pool.sks-keyservers.net:11371 | sudo tee -a /etc/pacman.d/gnupg/gpg.conf
sudo pacman-key --populate archlinux
sudo pacman-key --keyserver hkp://ipv4.pool.sks-keyservers.net:11371 -r 3056513887B78AEB 8A9E14A07010F7E3
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman-key --lsign-key 8A9E14A07010F7E3
sudo pacman-key --refresh-keys
sudo pacman -Sc --noconfirm

#Parallel Compilation
if grep -q "MAKEFLAGS=" /etc/makepkg.conf; then
 sudo sed -i 's/MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/' "/etc/makepkg.conf"
else
 :
 
fi

#SOFTWARE
sudo pacman -Syyu --noconfirm pacman-contrib yay zsh-theme-powerlevel10k-git p7zip unrar  fuseiso git base-devel ninja cmake sdl2 qt5 python2 python-pip boost catch2 fmt libzip lz4 mbedtls nlohmann-json openssl opus zlib ccache zstd ntfs-3g ufw gufw wget nano  bluez bluez-utils
sudo pacman -Rdd --noconfirm llvm-libs lib32-llvm-libs mesa 
echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
export PATH="/usr/lib/ccache/bin/:$PATH"
export EDITOR="/usr/bin/nano"' | tee -a ~/.zshrc

yay -S --noconfirm conan noto-fonts-cjk ttf-opensans ttf-meslo-nerd-font-powerlevel10k gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugin-libde265 mesa-demos libva-utils vulkan-tools llvm-git llvm-libs-git lib32-llvm-git clang-git meson
yay -S --noconfirm mesa-git lib32-mesa-git 
#Others
yay -S --noconfirm plasma-meta adapta-kde-git adapta-gtk-theme mkvtoolnix-gui plasma5-applets-eventcalendar spek-git spectacle brave qbittorrent mangohud goverlay-git puddletag-qt5-git wine-tkg-staging-fsync-vkd3d-opt-git winetricks-git psensor corectrl-git ark gwenview krename steam gnome-disk-utility nano qdirstat-git grub-customizer htop gedit galculator gparted audacious systemd-swap schedtool kde-servicemenus-rootactions cronie modprobed-db qmplay2-git ffmpegthumbs  neofetch papirus-folders-git 

#Cleaning
sudo pacman -Rdd --noconfirm vim chromium discover oxygen plasma-thunderbolt plasma-browser-integration
yay -Sc --noconfirm && sudo pacman -Rns --noconfirm $(pacman -Qtdq)
sudo rm -rf /var/cache/pacman/pkg ~/.cache/yay
pacman_conf_signon

#Functions 
enable_zram
fstab
amdgpu_conf
amdgpu_oc
ds4_touchpad 
enable_bt

#modprobe & cron
modprobed-db && modprobed-db store 
#crontab -e 0 */1* * *   /usr/bin/modprobed-db store &> /dev/null

#Papirus custom folder color
papirus-folders -C bluegrey --theme Papirus-Dark
