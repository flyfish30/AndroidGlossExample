#include <stdlib.h>
#include <dlfcn.h>
#include <android/log.h>

#define LOG_TAG  "Glut-wrapper"
#define LOGI(...) ((void)__android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__))
#define LOGW(...) ((void)__android_log_print(ANDROID_LOG_WARN, LOG_TAG, __VA_ARGS__))
#define LOGE(...) ((void)__android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__))

typedef int (*maintype)(int argc, char** argv);
extern void app_dummy();
extern int gloss_main(int argc, char** argv);

static void log_warning(const char *fmt, va_list ap)
{
    /* print warning message */
    LOGW(fmt, ap);
}

static void log_error(const char *fmt, va_list ap)
{
    /* print error message */
    LOGE(fmt, ap);
}

/*
int main(int argc, char** argv)
{
    LOGI("Enter main\n");
    app_dummy();
    gloss_main(argc, argv);
    return 0;
}
*/

int main(int argc, char** argv)
{
    static void *handle = NULL;
    maintype main_func;

    LOGI("Enter main\n");
    app_dummy();
    handle = dlopen("libgloss-example.so", RTLD_LAZY | RTLD_GLOBAL);
    if (handle = NULL) {
        LOGW("Failed to open library libgloss-example.so\n");
        return -1;
    }

    main_func = (maintype) dlsym(handle, "gloss_main");
    if (main_func == NULL) {
        LOGW("Failed to get function gloss_main: %s\n", dlerror());
        main_func = (maintype) dlsym(handle, "__stginit_GlExample");
        LOGI("Get main function: __stginit_GlExample=%p\n", main_func);
        return -1;
    }

    glutInitWarningFunc(log_warning);
    glutInitErrorFunc(log_error);
    LOGI("Get main function: main_func=%p\n", main_func);
    main_func(argc, argv);
    LOGI("wrapped main end\n");
    dlclose(handle);
    return 0;
}
