#include <stdio.h>
#include <jni.h>
#include <HsFFI.h>
#include <Rts.h>

extern void __stginit_GlExample(void);
extern void app_main(void);

int gloss_main(int argc, char** argv)
{
    static char *argv_hs[] = { "libgloss-example.so", "+RTS", "-A128m", 0 };
    static char **argv_ = argv_hs;
    static int argc_hs = 3;

#if __GLASGOW_HASKELL__ >= 703
    {
        RtsConfig conf = defaultRtsConfig;
        conf.rts_opts_enabled = RtsOptsAll;
        hs_init_ghc(&argc_hs, &argv_, conf);
    }
#else
    hs_init(&argc_hs, &argv_);
#endif
#ifdef __GLASGOW_HASKELL__
    hs_add_root(__stginit_GlExample);
#endif
    app_main();
    hs_exit();
    return 0;
}

void init_dummy()
{
    // If no this dummy function, this C code should be striped.
}
