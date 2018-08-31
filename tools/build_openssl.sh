#! /usr/bin/env bash

OPENSSL_VERSION=$1
MINIMUM_ANDROID_SDK_VERSION=$2
BUILD_ANDROID=${3:-1}
BUILD_IOS=${4:-1}

NDK_TOOLCHAIN_VERSION=4.9

( if [ ! ${OPENSSL_VERSION} ]; then
    echo "OPENSSL_VERSION was not provided, include and rerun"
    exit 1
fi

if [ ! ${MINIMUM_ANDROID_SDK_VERSION} ]; then
    echo "MINIMUM_ANDROID_SDK_VERSION was not provided, include and rerun"
    exit 1
fi

if [ ! ${ANDROID_NDK} ]; then
    echo "ANDROID_NDK environment variable not set, set and rerun"
    exit 1
fi

ANDROID_LIB_ROOT=../android-libs
ANDROID_TOOLCHAIN_DIR=/tmp/openssl-android-toolchain
OPENSSL_CONFIGURE_OPTIONS="shared"
#OPENSSL_CONFIGURE_OPTIONS="no-krb5 no-idea no-camellia \
#        no-seed no-bf no-cast no-rc2 no-rc4 no-rc5 no-md2 \
#        no-md4 no-ripemd no-rsa no-ecdh no-sock no-ssl2 no-ssl3 \
#        no-dsa no-dh no-ec no-ecdsa no-tls1 no-pbe no-pkcs \
#        no-tlsext no-pem no-rfc3779 no-whirlpool no-ui no-srp \
#        no-ssltrace no-tlsext no-mdc2 no-ecdh no-engine \
#        no-tls2 no-srtp -fPIC"

HOST_INFO=`uname -a`
case ${HOST_INFO} in
    Darwin*)
        TOOLCHAIN_SYSTEM=darwin-x86_64
    ;;
    Linux*)
        if [[ "${HOST_INFO}" == *i686* ]]
        then
            TOOLCHAIN_SYSTEM=linux-x86
        else
            TOOLCHAIN_SYSTEM=linux-x86_64
        fi
    ;;
    *)
        echo "Toolchain unknown for host system"
        exit 1
    ;;
esac

OPENSSL_DIR=openssl-${OPENSSL_VERSION}
OPENSSL_URL=https://openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz

# clean up build directory
rm -rf tools/build
mkdir tools/build
cd tools/build

# download openssl
wget ${OPENSSL_URL} -O ./openssl.tar.gz
tar -zxf openssl.tar.gz

cd ${OPENSSL_DIR}

#./Configure dist

if [ ${BUILD_ANDROID} = 1 ]; then
    for OPENSSL_TARGET_PLATFORM in armeabi-v7a x86 x86_64 arm64-v8a
    do
        echo "Building libcrypto.so for ${OPENSSL_TARGET_PLATFORM}"
        case "${OPENSSL_TARGET_PLATFORM}" in
            armeabi)
                TOOLCHAIN_ARCH=arm
                TOOLCHAIN_PREFIX=arm-linux-androideabi
                CONFIGURE_ARCH=android-arm
                PLATFORM_OUTPUT_DIR=armeabi
                ANDROID_API_VERSION=${MINIMUM_ANDROID_SDK_VERSION}
            ;;
            armeabi-v7a)
                TOOLCHAIN_ARCH=arm
                TOOLCHAIN_PREFIX=arm-linux-androideabi
                CONFIGURE_ARCH=android-arm
                PLATFORM_OUTPUT_DIR=armeabi-v7a
                ANDROID_API_VERSION=${MINIMUM_ANDROID_SDK_VERSION}
            ;;
            x86)
                TOOLCHAIN_ARCH=x86
                TOOLCHAIN_PREFIX=x86
                CONFIGURE_ARCH=android-x86
                PLATFORM_OUTPUT_DIR=x86
                ANDROID_API_VERSION=${MINIMUM_ANDROID_SDK_VERSION}
            ;;
            x86_64)
                TOOLCHAIN_ARCH=x86_64
                TOOLCHAIN_PREFIX=x86_64
                CONFIGURE_ARCH=android-x86_64
                PLATFORM_OUTPUT_DIR=x86_64
                ANDROID_API_VERSION=${MINIMUM_ANDROID_SDK_VERSION}
            ;;
            arm64-v8a)
                TOOLCHAIN_ARCH=arm64
                TOOLCHAIN_PREFIX=aarch64-linux-android
                CONFIGURE_ARCH=android-arm64
                PLATFORM_OUTPUT_DIR=arm64-v8a
                ANDROID_API_VERSION=${MINIMUM_ANDROID_SDK_VERSION}
            ;;
            *)
                echo "Unsupported build platform:${OPENSSL_TARGET_PLATFORM}"
                exit 1
        esac

        mkdir -p "${ANDROID_LIB_ROOT}/${OPENSSL_TARGET_PLATFORM}"

        export PATH=${ANDROID_NDK}/toolchains/${TOOLCHAIN_PREFIX}-${NDK_TOOLCHAIN_VERSION}/prebuilt/${TOOLCHAIN_SYSTEM}/bin:$PATH
        echo $PATH

        ./Configure "${CONFIGURE_ARCH}" \
 -D__ANDROID_API__=${ANDROID_API_VERSION} \
 "${OPENSSL_CONFIGURE_OPTIONS}"

        if [ $? -ne 0 ]; then
            echo "Error executing:./Configure ${CONFIGURE_ARCH} ${OPENSSL_CONFIGURE_OPTIONS}"
            exit 1
        fi

        make clean
        make SHLIB_VERSION_NUMBER= SHLIB_EXT=.so

        if [ $? -ne 0 ]; then
            echo "Error executing make for platform:${OPENSSL_TARGET_PLATFORM}"
            exit 1
        fi

        mv libcrypto.a ${ANDROID_LIB_ROOT}/${PLATFORM_OUTPUT_DIR}
        mv libcrypto.so ${ANDROID_LIB_ROOT}/${PLATFORM_OUTPUT_DIR}
    done
fi

#if [ ${BUILD_IOS} = 1 ]; then
#    echo "Building iOS binaries..."
#
#    for OPENSSL_TARGET_PLATFORM in armv7 armv7s arm64
#    do
#        echo "Building libcrypto.a for ${OPENSSL_TARGET_PLATFORM}..."
#    done
#fi)
