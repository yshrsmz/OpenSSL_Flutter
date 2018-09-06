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
OUT_DIR=${BUILD_DIR}/openssl-ios


# clean up build directory
rm -rf tools/build/${OPENSSL_DIR}
mkdir tools/build
cd tools/build

# download openssl
if [ ! -e "openssl.tar.gz" ]; then
    wget ${OPENSSL_URL} -O ./openssl.tar.gz
fi
# tar -zxf openssl.tar.gz

# cd ${OPENSSL_DIR}

for TARGET in ios-xcrun ios64-xcrun iossimulator-xcrun
do
    echo "Building libcrypto.a for ${TARGET}..."

    tar -zxf openssl.tar.gz
    TMP_OUT_DIR=openssl_${TARGET}
    rm -rf ${TMP_OUT_DIR}
    mv $OPENSSL_DIR ${TMP_OUT_DIR}
    cd ${TMP_OUT_DIR}

    ./Configure ${TARGET} no-async no-shared

    make clean
    make
    make install

    # mv ./libcrypto.a ${OUT_DIR}

    cd ../

done

mkdir -p ${BUILD_DIR}/openssl-ios
lipo -create openssl_ios-xcrun/libcrypto.a openssl_ios64-xcrun/libcrypto.a openssl_iossimulator-xcrun/libcrypto.a -output ${BUILD_DIR}/openssl-ios/libcrypto.a
cp -r openssl_ios-xcrun/include ${BUILD_DIR}/openssl-ios

echo "finished")
