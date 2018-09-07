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
OUT_DIR=${EXEC_DIR}/ios/OpenSSL

rm -rf ${OUT_DIR}
mkdir -p ${OUT_DIR}/lib


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

    cd ../

done

mkdir -p ${BUILD_DIR}/openssl-ios
lipo -create openssl_ios-xcrun/libcrypto.a openssl_ios64-xcrun/libcrypto.a openssl_iossimulator-xcrun/libcrypto.a -output ${OUT_DIR}/lib/libcrypto.a
lipo -create openssl_ios-xcrun/libssl.a openssl_ios64-xcrun/libssl.a openssl_iossimulator-xcrun/libssl.a -output ${OUT_DIR}/lib/libssl.a
cp -r openssl_ios-xcrun/include ${OUT_DIR}

echo "finished")
