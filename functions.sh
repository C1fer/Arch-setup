#Pacman.conf
pacman_conf_signoff () {
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
SigLevel    = Never
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
#Server = file:///home/custompkgs" | sudo tee /etc/pacman.conf >&-

}

#zram
enable_zram () {
sudo touch /etc/systemd/system/zram.service
echo '[Unit] 
Description=zRam block devices swapping 
 
[Service] 
Type=oneshot 
ExecStart=/usr/bin/bash -c "modprobe zram && echo lz4 > /sys/block/zram0/comp_algorithm && echo 16G > /sys/block/zram0/disksize && mkswap --label zram0 /dev/zram0 && swapon --priority 100 /dev/zram0" 
ExecStop=/usr/bin/bash -c "swapoff /dev/zram0 && rmmod zram" 
RemainAfterExit=yes 
 
[Install] 
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/zram.service >&-
sudo systemctl enable zram
}

#fstab
fstab () {
echo "UUID=B0D64370D643363E /mnt/Disco\040Local\040C  ntfs-3g  nodev,nofail,x-gvfs-show,uid=1000,guid=1000 0 0
UUID=D2F27AE4F27ACC6B /mnt/Disco\040Local\040D  ntfs-3g  nodev,nofail,x-gvfs-show,uid=1000,guid=1000 0 0
UUID=10EC8ED5EC8EB48E /mnt/Disco\040Local\040E  ntfs-3g  nosuid,nodev,nofail,x-gvfs-show 0 0
UUID=5864C15F64C1408C /mnt/Disco\040Local\040F  ntfs-3g  nodev,nofail,x-gvfs-show,uid=1000,guid=1000 0 0
UUID=70720F9C720F65E6 /mnt/Rusbel               ntfs-3g  nosuid,nodev,nofail,x-gvfs-show 0 0" | sudo tee -a /etc/fstab >&-
}

#Mirror list
mirrors () {
echo "# Arch Linux repository mirrorlist
#
# Worldwide
Server = http://mirrors.evowise.com/archlinux/\$repo/os/\$arch
Server = http://mirror.rackspace.com/archlinux/\$repo/os/\$arch
Server = https://mirror.rackspace.com/archlinux/\$repo/os/\$arch

# Misc
Server = https://mirror.osbeck.com/archlinux/\$repo/os/\$arch
Server = http://mirrors.kernel.org/archlinux/\$repo/os/\$arch
Server = http://archlinux.cu.be/\$repo/os/\$arch
Server = http://mirror.mia11.us.leaseweb.net/archlinux/\$repo/os/\$arch
Server = http://mirror.dal10.us.leaseweb.net/archlinux/\$repo/os/\$arch
Server = http://mirror.onet.pl/pub/mirrors/archlinux/\$repo/os/\$arch" | sudo tee /etc/pacman.d/mirrorlist >&-
}

#Xorg config
amdgpu_conf () {
sudo touch /etc/X11/xorg.conf.d/20-amdgpu.conf
echo 'Section "Device"
     Identifier "AMD"
     Option "TearFree" "true"
     Option "DRI" "3"
     Option "VariableRefresh" "true"
     Driver "amdgpu"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-amdgpu.conf >&-
}

#Disable ds4 touchpad
ds4_touchpad () {
sudo touch /etc/udev/rules.d/51-disable-DS3-and-DS4-motion-controls.rules
echo 'SUBSYSTEM=="input", ATTRS{name}=="*Controller Touchpad", RUN+="/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""' | sudo tee /etc/udev/rules.d/51-disable-DS3-and-DS4-motion-controls.rules >&-
}

#Bluetooth
enable_bt () {
sudo systemctl enable bluetooth.service
}

#GPU overclock
amdgpu_oc () {
sudo sed -i  's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 amdgpu.ppfeaturemask=0xffffffff nowatchdog"/' "/etc/default/grub"
sudo grub-mkconfig -o /boot/grub/grub.cfg
}


pacman_conf_sign1() {
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
SigLevel    = Never
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
#Server = file:///home/custompkgs" | sudo tee /etc/pacman.conf >&-
}
