LOCAL_PATH:= $(call my-dir)

# import static free glut library
include $(CLEAR_VARS)

LOCAL_MODULE := freeglut-gles
LOCAL_SRC_FILES := lib/libfreeglut-gles.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include

include $(PREBUILT_STATIC_LIBRARY)

# import shared glut library(same as free glut)
#include $(CLEAR_VARS)
#
#LOCAL_MODULE := glut
#LOCAL_SRC_FILES := lib/libglut.so
#LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
#
#include $(PREBUILT_SHARED_LIBRARY)

# import shared glues library
include $(CLEAR_VARS)

LOCAL_MODULE := glues
LOCAL_SRC_FILES := lib/libGLU.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include

include $(PREBUILT_SHARED_LIBRARY)

# import shared iconv library
include $(CLEAR_VARS)

LOCAL_MODULE := iconv
LOCAL_SRC_FILES := lib/libiconv.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include

include $(PREBUILT_SHARED_LIBRARY)

