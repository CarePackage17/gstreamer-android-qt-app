echo $@;

# get PATH that contains ndk-build
. ~/.bashrc

#1 is TARGET_ARCH_ABI, 2 is GSTREAMER_ROOT_ANDROID, 3 is NDK_PROJECT_PATH
#since building with clang fails, we explicitly specify to build with gcc-4.9
ndk-build NDK_TOOLCHAIN_VERSION="4.9" $1 $2 $3
