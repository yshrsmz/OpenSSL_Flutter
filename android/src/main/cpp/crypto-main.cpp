#include <jni.h>
#include <openssl/evp.h>
#include <cstring>
#include <android/log.h>
#include <stdio.h>

#define LOGI(...) \
  ((void)__android_log_print(ANDROID_LOG_INFO, "hello-libs::", __VA_ARGS__))


extern "C"
JNIEXPORT jstring JNICALL
Java_com_codingfeline_opensslflutter_OpensslFlutterPlugin_getSha512Digest(JNIEnv *env, jobject thiz, jstring target) {
    const char* nativeString = env->GetStringUTFChars(target, JNI_FALSE);
    unsigned char md_value[EVP_MAX_MD_SIZE];
    unsigned int md_len;
    int i;

    LOGI("crypto-main#getSha512Digest: %s", nativeString);

    EVP_MD_CTX *ctx = EVP_MD_CTX_new();
    const EVP_MD *md = EVP_get_digestbyname("SHA512");

    EVP_DigestInit_ex(ctx, md, NULL);
    EVP_DigestUpdate(ctx, nativeString, strlen(nativeString));
    EVP_DigestFinal_ex(ctx, md_value, &md_len);
    EVP_MD_CTX_free(ctx);

    char hex[md_len * 2 + 1];
    for (i = 0; i < md_len; i++) {
        sprintf(&hex[i*2], "%02X", md_value[i]);
    }

    LOGI("crypto-main#getSha512Digest - result: %s", hex);



    return env->NewStringUTF(hex);
}
