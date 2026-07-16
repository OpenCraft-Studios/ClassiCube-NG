WDW_BACKENDS := x11 mac-classic os2 sdl2 sdl3 terminal windows wince
WDW_USE       = $(filter $(WDW_BACKENDS), $(USE))
WDW_OBJS     := $(BUILD_DIR)/Window_$(WDW_USE).c.o
# TODO: BeOS not supported yet

ifeq ($(WDW_USE), )
	$(error Please, select a window backend or disable it (make ... WINDOW=0))
else ifeq ($(WDW_USE), x11)
	WDW_LDLIBS += $(shell $(PKGCONF) --libs x11 xi)
	WDW_CFLAGS += $(shell $(PKGCONF) --cflags x11 xi) 
	WDW_CFLAGS += -DCC_BUILD_XINPUT2
	WDW_CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_X11
else ifeq ($(WDW_USE), x11)
	WDW_CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_SDL2
else ifeq ($(WDW_USE), x11)
	WDW_CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_SDL3
else ifeq ($(WDW_USE), x11)
	WDW_CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_TERMINAL
else ifeq ($(WDW_USE), x11)
	WDW_CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_WIN32
else ifeq ($(WDW_USE), x11)
	WDW_CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_WIN32CE
endif

$(BUILD_DIR)/Window_%.c.o: $(SRC_DIR)/Window_%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(WDW_CFLAGS) -c $< -o $@

override OBJS   += $(WDW_OBJS)
override LDLIBS += $(WDW_LDLIBS)
override CFLAGS += $(WDW_CFLAGS)
