LOCAL_PATH := $(call my-dir)
NDK_SYSROOT := /home/parker/tools/arm/toolchain/sysroot

include $(CLEAR_VARS)
APP_ABI := arm64-v8a
TARGET_ARCH_ABI := arm64-v8a

LOCAL_MODULE    := glut-example
LOCAL_C_INCLUDES := $(NDK_SYSROOT)/usr/include
LOCAL_SRC_FILES := test-shapes-gles1.c
LOCAL_LDLIBS    := -llog -landroid -lGLESv2 -lEGL -lGLESv1_CM
LOCAL_STATIC_LIBRARIES := freeglut-gles
# LOCAL_SHARED_LIBRARIES := glues

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
APP_ABI := arm64-v8a
TARGET_ARCH_ABI := arm64-v8a

LOCAL_MODULE    := glut
LOCAL_SRC_FILES := glut-wrapper.c
LOCAL_LDLIBS    := -llog -landroid -lGLESv2 -lEGL -lGLESv1_CM
LOCAL_STATIC_LIBRARIES := freeglut-gles

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
APP_ABI := arm64-v8a
TARGET_ARCH_ABI := arm64-v8a

LOCAL_MODULE    := gloss-example
LOCAL_SRC_FILES := ../hs/dist/build/libgloss-example.so/libgloss-example.so
LOCAL_LDLIBS    := -llog -landroid -lGLESv2 -lEGL -lGLESv1_CM
LOCAL_SHARED_LIBRARIES := iconv glues
cmd-strip :=

include $(PREBUILT_SHARED_LIBRARY)

$(call import-add-path,$(LOCAL_PATH)/../native-import)
$(call import-module,sysroot)
