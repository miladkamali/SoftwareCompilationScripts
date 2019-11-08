#/bin/bash

#
# This file is part of the publicSource  distribution (https://github.com/miladkamali/).
# Copyright (c) 2019 Milad Zare Kamali.
#
# This program is free software: you can redistribute it and/or modify  
# it under the terms of the GNU General Public License as published by  
# the Free Software Foundation, version 3.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
# General Public License for more details.

# You should have received a copy of the GNU General Public License 
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#

# TODO: do every thing as normal user then for installation switch to super user
# TODO: check if each step is completed properly before continuing with the next step
InstallationLocation="/usr/local"
version="9.2.0"
sourceStoreLocation="~/software_used"
apt install -y build-essential lynx wget
latestAvailableVersion=`lynx --dump "ftp://ftp.gnu.org/gnu/gcc/"|tr ' ' '\n'|grep "gcc-[0-9]"|tail -n1|cut -d '-' -f2`
latestInstalledVersion=`ls $InstallationLocation -rt|grep gcc-[0-9]|cut -d '-' -f2`
if [ $latestAvailableVersion==latestInstalledVersion ]
then
    echo "yes";echo "$latestAvailableVersion==$latestInstalledVersion";
    echo "Latest GCC installed is gcc-$latestInstalledVersion but latest available gcc is gcc-$latestInstalledVersion"
    echo "say yes to compile and install the latest version"
    read response
    if [ $response == "yes" ]
    then
        if [ ! -d $sourceStoreLocation ]
        then
            mkdir $sourceStoreLocation
        fi
        cd $sourceStoreLocation
        wget "ftp://ftp.gnu.org/gnu/gcc/gcc-$version/gcc-$version.tar.xz"
        tar xf "gcc-$version.tar.xz"
        cd "gcc-$version"
        ./contrib/download_prerequisites
        cd ..
        mkdir build
        cd build
        ../gcc-$version/configure -v --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu --prefix=$InstallationLocation/gcc-$version --enable-checking=release --enable-languages=c,c++,fortran --disable-multilib --program-suffix=-$version
        make -j 8

        make install-strip
        echo "export export PATH=/usr/local/gcc-$version/bin:$PATH" >> ~/.bashrc
        echo "export LD_LIBRARY_PATH=/usr/local/gcc-$version/lib64:$LD_LIBRARY_PATH" >>~/.bashrc

    fi

fi

