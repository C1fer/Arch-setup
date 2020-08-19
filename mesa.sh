#/bin/sh
if [ -d "/tmp/mesa/" ]; then
 sudo rm -rf /tmp/mesa
else 
 echo "test"
fi
#Mesa 64bit
mkdir /tmp/mesa && cd /tmp/mesa wget https://aur.archlinux.org/cgit/aur.git/snapshot/mesa-git.tar.gz 
tar -xf mesa-git.tar.gz 
if grep -q "MESA_WHICH_LLVM=" /tmp/mesa/mesa-git/PKGBUILD; then
 sed -i 's/MESA_WHICH_LLVM=4/MESA_WHICH_LLVM=3/' "/tmp/mesa/mesa-git/PKGBUILD"
 cd /tmp/mesa/mesa-git/ && makepkg -si
else
 :
fi 
#Mesa 32-bit
cd /tmp/mesa
wget https://aur.archlinux.org/cgit/aur.git/snapshot/lib32-mesa-git.tar.gz
tar -xf lib32-mesa-git.tar.gz 
if grep -q "MESA_WHICH_LLVM=" /tmp/mesa/lib32-mesa-git/PKGBUILD; then
 sed -i 's/MESA_WHICH_LLVM=4/MESA_WHICH_LLVM=3/' "/tmp/mesa/lib32-mesa-git/PKGBUILD"
 cd /tmp/mesa/lib32-mesa-git/ && makepkg -si
else
 :
 
fi 
rm -rf /tmp/mesa

