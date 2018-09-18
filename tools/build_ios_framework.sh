#!/usr/bin/env bash

FWNAME=openssl
EXEC_DIR=$(pwd)
BUILD_DIR=${EXEC_DIR}/tools/build
UNIFIED_DIR=${BUILD_DIR}/openssl-ios
OUT_DIR=${EXEC_DIR}/ios/OpenSSL

if [ ! -d ${UNIFIED_DIR} ]; then
    echo "Please run build-ios.sh first."
    exit 1
fi

if [ -d ${UNIFIED_DIR}/${FWNAME}.framework ]; then
    echo "Removing previous ${FWNAME}.framework copy."
    rm -rf ${UNIFIED_DIR}/${FWNAME}.framework
fi

echo "Creating ${FWNAME}.framework"

mkdir -p ${UNIFIED_DIR}/${FWNAME}.framework/Headers
mkdir -p ${UNIFIED_DIR}/${FWNAME}.framework/Modules
libtool -no_warning_for_no_symbols -static -o ${UNIFIED_DIR}/${FWNAME}.framework/${FWNAME} ${UNIFIED_DIR}/lib/libcrypto.a ${UNIFIED_DIR}/lib/libssl.a
cp -r ${UNIFIED_DIR}/include/${FWNAME}/* ${UNIFIED_DIR}/${FWNAME}.framework/Headers/
cp ${EXEC_DIR}/tools/openssl_for_ios.plist ${UNIFIED_DIR}/${FWNAME}.framework/Info.plist
cp ${EXEC_DIR}/tools/openssl_for_ios.modulemap ${UNIFIED_DIR}/${FWNAME}.framework/Modules/module.modulemap

check_bitcode=`otool -arch arm64 -l ${UNIFIED_DIR}/${FWNAME}.framework/${FWNAME} | grep __bitcode`
if [ -z "${check_bitcode}" ]; then
    echo "INFO: ${FWNAME}.frameworK doesn't contain Bitcode"
else
    echo "INFO: ${FWNAME}.frameworK contains Bitcode"
fi
