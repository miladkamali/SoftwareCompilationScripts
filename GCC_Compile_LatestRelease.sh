#/bin/bash
. ./step.sh
step "installing dependencies"
{
    InstallationLocation="/usr/local"
    version="9.2.0"
    sourceStoreLocation="~/software_used"
    try apt install -y build-essential lynx wget checkinstall
} >/dev/null 2>&1
next

step "getting latest version of released gcc and installed gcc"
{
latestAvailableVersion=`try lynx --dump "ftp://ftp.gnu.org/gnu/gcc/"|tr ' ' '\n'|grep "gcc-[0-9]"|tail -n1|cut -d '-' -f2`
latestInstalledVersion=`try ls $InstallationLocation -rt|grep gcc-[0-9]|cut -d '-' -f2`
} >/dev/null 2>&1
next

if [ $latestAvailableVersion==latestInstalledVersion ]
then
    echo "Latest GCC installed is gcc-$latestInstalledVersion but latest available gcc is gcc-$latestAvailableVersion"
    echo "say yes to compile and install the latest version"
    read response
    if [ $response == "yes" ]
    then
	step "downloading gcc-$version"
        if [ ! -d $sourceStoreLocation ]
        then
            try mkdir "$sourceStoreLocation"
        fi
	{
            cd $sourceStoreLocation
            try wget "ftp://ftp.gnu.org/gnu/gcc/gcc-$version/gcc-$version.tar.xz"
            try tar xf "gcc-$version.tar.xz"
            try cd "gcc-$version"
            try ./contrib/download_prerequisites
	} >/dev/null 2>&1
	next

	step "configuring and compiling gcc-$version"
	{
            try cd ..
            try mkdir build
            try cd build
            try ../gcc-$version/configure -v --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu --prefix=$InstallationLocation/gcc-$version --enable-checking=release --enable-languages=c,c++,fortran --disable-multilib --program-suffix=-$version
            try make -j 8
	}  >/dev/null 2>&1
	next
	step "installing and creating deb package"
	{
            try checkinstall -D make install
            try echo "export export PATH=/usr/local/gcc-$version/bin:$PATH" >> ~/.bashrc
            try echo "export LD_LIBRARY_PATH=/usr/local/gcc-$version/lib64:$LD_LIBRARY_PATH" >>~/.bashrc
	}

    fi

fi

