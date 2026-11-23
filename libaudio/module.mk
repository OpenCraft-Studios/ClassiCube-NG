override AUD_BACKENDS := 3ds dreamcast gcwii openal os2 sles switch web wiiu winmm

aud.USE   = $(lastword $(filter $(AUD_BACKENDS), $(USE)))
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

$(oc.build)/Audio_3ds.c.o: libaudio/Audio_3ds.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

$(oc.build)/Audio_dreamcast.c.o: libaudio/Audio_dremcast.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

$(oc.build)/Audio_gcwii.c.o: libaudio/Audio_gcwii.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

$(oc.build)/Audio_openal.c.o: libaudio/Audio_openal.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

$(oc.build)/Audio_os2.c.o: libaudio/Audio_os2.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

$(oc.build)/Audio_sles.c.o: libaudio/Audio_sles.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

$(oc.build)/Audio_switch.c.o: libaudio/Audio_switch.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

$(oc.build)/Audio_web.c.o: libaudio/Audio_web.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

$(oc.build)/Audio_wiiu.c.o: libaudio/Audio_wiiu.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

$(oc.build)/Audio_winmm.c.o: libaudio/Audio_winmm.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

$(oc.build)/Audio.c.o: libaudio/Audio.c | $(oc.build)
	$(CC) $(CFLAGS) $(aud.CFLAGS) -c $< -o $@

override OBJS   += $(aud.OBJS)
override CFLAGS += $(aud.CFLAGS)
override LDLIBS += $(aud.LDLIBS)
