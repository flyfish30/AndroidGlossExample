LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
APP_ABI := arm64-v8a
TARGET_ARCH_ABI := arm64-v8a
NDK_SYSROOT := /home/parker/tools/arm/toolchain/sysroot

LOCAL_MODULE    := gloss-example
LOCAL_C_INCLUDES := $(NDK_SYSROOT)/usr/include
LOCAL_SRC_FILES := test-shapes-gles1.c
LOCAL_LDLIBS    := -llog -landroid -lGLESv2 -lEGL -lGLESv1_CM
LOCAL_STATIC_LIBRARIES := freeglut-gles
LOCAL_SHARED_LIBRARIES := glues

include $(BUILD_SHARED_LIBRARY)

$(call import-add-path,$(LOCAL_PATH)/../native-import)
$(call import-module,freeglut-gles)
