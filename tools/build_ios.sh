#!/usr/bin/env bash

OPENSSL_VERSION=$1

(if [ ! ${OPENSSL_VERSION} ]; then
    echo "OPENSSL_VERSION was not provided, include and rerun"
    exit 1
fi

OPENSSL_DIR=openssl-${OPENSSL_VERSION}
OPENSSL_URL=https://openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz

EXEC_DIR=$(pwd)
BUILD_DIR=${EXEC_DIR}/tools/build


# clean up build directory
rm -rf tools/build/${OPENSSL_DIR}
mkdir tools/build
cd tools/build

# download openssl
if [ ! -e "openssl.tar.gz" ]; then
    wget ${OPENSSL_URL} -O ./openssl.tar.gz
fi
tar -zxf openssl.tar.gz

cd ${OPENSSL_DIR}

for TARGET in ios-xcrun ios64-xcrun iossimulator-xcrun
do
    echo "Building libcrypto.a for ${TARGET}..."
    OUT_DIR="${BUILD_DIR}/ios-libs/${TARGET}"

    rm -rf ${OUT_DIR}
    mkdir -p ${OUT_DIR}

    ./Configure ${TARGET} no-async no-shared

    make clean
    make

    mv ./libcrypto.a ${OUT_DIR}

done






echo "finished")
