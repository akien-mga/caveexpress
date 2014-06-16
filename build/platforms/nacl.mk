SO_EXT                    = so
SO_LDFLAGS                = -shared
SO_CFLAGS                 = -fpic
SO_LIBS                  := -ldl

EXE_EXT                   = .pexe

CFLAGS                   += -D_GNU_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE -DSDL_VIDEO_DRIVER_NACL -DSDL_AUDIO_DRIVER_NACL -DHAVE_POW=1 -DHAVE_OPENGLES2=1 -DSDL_VIDEO_OPENGL_ES2=1 -DSDL_VIDEO_RENDER_OGL_ES2=1

LDFLAGS                  +=
SDL_LIBS                 += -lpthread -lppapi_simple -lppapi_gles2
