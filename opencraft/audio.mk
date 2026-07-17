AUD_BACKENDS := openal os2 sles winmm
AUD_USE       = $(filter $(AUD_BACKENDS), $(USE))
AUD_OBJS     := $(BUILD_DIR)/Audio.c.o $(BUILD_DIR)/Audio_$(AUD_USE).c.o

ifeq ($(AUD_USE), )
$(error Please, select an audio backend or disable libaudio (make ... AUDIO=0))
else ifeq ($(AUD_USE), openal)
AUD_CFLAGS += -DCC_AUD_BACKEND=CC_AUD_BACKEND_OPENAL
AUD_LDLIBS += -ldl
else ifeq ($(AUD_USE), os2)
AUD_CFLAGS += -DCC_AUD_BACKEND=CC_AUD_BACKEND_OS2
else ifeq ($(AUD_USE), sles)
AUD_CFLAGS += -DCC_AUD_BACKEND=CC_AUD_BACKEND_OPENSLES
else ifeq ($(AUD_USE), winmm)
AUD_CFLAGS += -DCC_AUD_BACKEND=CC_AUD_BACKEND_WINMM
endif

$(BUILD_DIR)/Audio_%.c.o: $(SRC_DIR)/Audio_%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(AUD_CFLAGS) -c $< -o $@

override OBJS   += $(AUD_OBJS)
override CFLAGS += $(AUD_CFLAGS)
override LDLIBS += $(AUD_LDLIBS)
