override AUD_BACKENDS := openal os2 sles winmm

aud.USE   = $(filter $(AUD_BACKENDS), $(USE))
aud.OBJS := $(oc.build)/Audio.c.o $(oc.build)/Audio_$(aud.USE).c.o

ifeq ($(aud.USE),)
$(error Please, select an audio backend or disable libaudio (make ... AUDIO=0))
else ifeq ($(aud.USE),openal)
aud.CFLAGS += -DCC_AUD_BACKEND=CC_AUD_BACKEND_OPENAL
aud.LDLIBS += -ldl
else ifeq ($(aud.USE),os2)
aud.CFLAGS += -DCC_AUD_BACKEND=CC_AUD_BACKEND_OS2
else ifeq ($(aud.USE),sles)
aud.CFLAGS += -DCC_AUD_BACKEND=CC_AUD_BACKEND_OPENSLES
else ifeq ($(aud.USE),winmm)
aud.CFLAGS += -DCC_AUD_BACKEND=CC_AUD_BACKEND_WINMM
endif

$(oc.build)/Audio_%.c.o: $(oc.src)/Audio_%.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

override OBJS   += $(aud.OBJS)
override CFLAGS += $(aud.CFLAGS)
override LDLIBS += $(aud.LDLIBS)
