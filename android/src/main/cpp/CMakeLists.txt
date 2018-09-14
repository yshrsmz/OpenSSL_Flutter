cmake_minimum_required(VERSION 3.6)

# configure import libs
set(distribution_DIR ${CMAKE_SOURCE_DIR}/../../../../third_party/android)

add_library(lib_crypto SHARED IMPORTED)
add_library(lib_ssl SHARED IMPORTED)
set_target_properties(lib_crypto PROPERTIES IMPORTED_LOCATION ${distribution_DIR}/openssl/lib/${ANDROID_ABI}/libcrypto.so)
set_target_properties(lib_ssl PROPERTIES IMPORTED_LOCATION ${distribution_DIR}/openssl/lib/${ANDROID_ABI}/libssl.so)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")

add_library(crypto-main SHARED crypto-main.cpp)

target_include_directories(crypto-main PRIVATE
                           ${distribution_DIR}/openssl/include)

target_link_libraries(crypto-main
                      android
                      lib_crypto
                      lib_ssl
                      log)
