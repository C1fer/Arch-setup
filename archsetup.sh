#!/bin/sh
#Keys setup
sudo rm -rf /etc/pacman.d/gnupg/gpg.conf
sudo pacman-key --init
echo keyserver hkp://ipv4.pool.sks-keyservers.net:11371 | sudo tee -a /etc/pacman.d/gnupg/gpg.conf
sudo pacman-key --populate archlinux
sudo pacman-key --keyserver hkp://ipv4.pool.sks-keyservers.net:11371 -r 3056513887B78AEB 8A9E14A07010F7E3
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman-key --lsign-key 8A9E14A07010F7E3

#Parallel Compilation
if grep -q "MAKEFLAGS=" /etc/makepkg.conf; then
 sudo sed -i 's/MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/' "/etc/makepkg.conf"
else
 :
 
fi

#Pacman.conf
echo  "#
# /etc/pacman.conf
#
# See the pacman.conf(5) manpage for option and repository directives

#
# GENERAL OPTIONS
#
[options]
# The following paths are commented out with their default values listed.
# If you wish to use different paths, uncomment and update the paths.
#RootDir     = /
#DBPath      = /var/lib/pacman/
#CacheDir    = /var/cache/pacman/pkg/
#LogFile     = /var/log/pacman.log
#GPGDir      = /etc/pacman.d/gnupg/
#HookDir     = /etc/pacman.d/hooks/
HoldPkg     = pacman glibc
#XferCommand = /usr/bin/curl -L -C - -f -o %o %u
#XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
#CleanMethod = KeepInstalled
Architecture = auto

# Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
#IgnorePkg   =
#IgnoreGroup =

#NoUpgrade   =
#NoExtract   =

# Misc options
#UseSyslog
Color
#TotalDownload
CheckSpace
#VerbosePkgLists

# By default, pacman accepts packages signed by keys that its local keyring
# trusts (see pacman-key and its man page), as well as unsigned packages.
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional
#RemoteFileSigLevel = Required

# NOTE: You must run \`pacman-key --init\` before first using pacman; the local
# keyring can then be populated with the keys of all official Arch Linux
# packagers with \`pacman-key --populate archlinux\`.

#
# REPOSITORIES
#   - can be defined here or included from another file
#   - pacman will search repositories in the order defined here
#   - local/custom mirrors can be added here or in separate files
#   - repositories listed first will take precedence when packages
#     have identical names, regardless of version number
#   - URLs will have \$repo replaced by the name of the current repo
#   - URLs will have \$arch replaced by the name of the architecture
#
# Repository entries are of the format:
#       [repo-name]
#       Server = ServerName
#       Include = IncludePath
#
# The header [repo-name] is crucial - it must be present and
# uncommented to enable the repo.
#

# The testing repositories are disabled by default. To enable, uncomment the
# repo name header and Include lines. You can add preferred servers immediately
# after the header, and they will be used before the default mirrors.

[testing]
Include = /etc/pacman.d/mirrorlist

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[community-testing]
Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist

# If you want to run 32 bit applications on your x86_64 system,
# enable the multilib repositories as required here.

[multilib-testing]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

# An example of a custom package repository.  See the pacman manpage for
# tips on creating your own repositories.
#[custom]
#SigLevel = Optional TrustAll
#Server = file:///home/custompkgs

[chaotic-aur]
# Brazil
Server =  https://lonewolf.pedrohlc.com/\$repo/x86_64
# Germany
Server = http://chaotic.bangl.de/\$repo/x86_64
# USA (Cloudflare proxy)
Server = https://repo.kitsuna.net/x86_64" | sudo tee /etc/pacman.conf >&-

#Software installation
#Build essential
sudo pacman -Syyu --noconfirm pacman-contrib yay zsh-theme-powerlevel10k-git p7zip unrar git base-devel ninja cmake sdl2 qt5 python2 python-pip boost catch2 fmt libzip lz4 mbedtls nlohmann-json openssl opus zlib ccache zstd ntfs-3g ufw gufw wget && sudo pacman -Rdd --noconfirm llvm-libs
echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' |tee -a ~/.zshrc && echo 'export PATH="/usr/lib/ccache/bin/:$PATH"' | tee -a ~/.zshrc
yay -S --noconfirm conan noto-fonts-cjk ttf-opensans ttf-meslo-nerd-font-powerlevel10k llvm-git llvm-libs-git lib32-llvm-git clang-git meson 
#Mesa
yes "y" | . ./mesa.sh
#Others
yay -S --noconfirm plasma-meta adapta-kde-git adapta-gtk-theme mkvtoolnix-gui spek-git spectacle-git brave qmplay2-git qbittorrent mangohud goverlay-git puddletag-qt5-git wine-tkg-staging-fsync-vkd3d-opt-git winetricks-git psensor corectrl-git ark gwenview krename steam gnome-disk-utility nano qdirstat-git grub-customizer htop gedit galculator gparted audacious systemd-swap schedtool kde-servicemenus-rootactions cronie modprobed-db ffmpegthumbs  neofetch papirus-folders-git 
#Cleaning
sudo pacman -Rdd vim chromium discover oxygen plasma-thunderbolt
yay -Sc --noconfirm && sudo pacman -Rns --noconfirm $(pacman -Qtdq)

#zram
sudo touch /etc/systemd/system/zram.service
echo '[Unit] 
Description=zRam block devices swapping 
 
[Service] 
Type=oneshot 
ExecStart=/usr/bin/bash -c "modprobe zram && echo lz4 > /sys/block/zram0/comp_algorithm && echo 8G > /sys/block/zram0/disksize && mkswap --label zram0 /dev/zram0 && swapon --priority 100 /dev/zram0" 
ExecStop=/usr/bin/bash -c "swapoff /dev/zram0 && rmmod zram" 
RemainAfterExit=yes 
 
[Install] 
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/zram.service >&-
sudo systemctl enable zram

#fstab
echo "
UUID=D2F27AE4F27ACC6B /mnt/Disco\040Local\040D ntfs-3g defaults,x-gvfs-show 0 0
UUID=10EC8ED5EC8EB48E /mnt/Disco\040Local\040E ntfs-3g defaults,x-gvfs-show 0 0
UUID=5864C15F64C1408C /mnt/Disco\040Local\040F ntfs-3g defaults,x-gvfs-show 0 0
UUID=70720F9C720F65E6 /mnt/Rusbel ntfs-3g defaults,x-gvfs-show 0 0" | sudo tee -a /etc/fstab >&-

#Xorg config
sudo touch /etc/X11/xorg.conf.d/20-amdgpu.conf
echo 'Section "Device"
     Identifier "AMD"
     Option "TearFree" "true"
     Option "DRI" "3"
     Option "VariableRefresh" "true"
     Driver "amdgpu"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-amdgpu.conf

#modprobe & cron
modprobed-db && modprobed-db store 
crontab -e 0 */1* * *   /usr/bin/modprobed-db store &> /dev/null

#Papirus custom folder color
papirus-folders -C bluegrey --theme Papirus-Dark

