override WDW_BACKENDS := x11 mac-classic os2 sdl2 sdl3 terminal windows wince

# TODO: Add support for BeOS
wdw.USE   = $(lastword $(filter $(WDW_BACKENDS),$(USE)))
wdw.OBJS := $(oc.build)/Window_$(wdw.USE).c.o

ifeq ($(wdw.USE),)
$(error Please, select a window backend or disable it (make ... WINDOW=0))
else ifeq ($(wdw.USE),x11)
wdw.LDLIBS += $(shell $(PKGCONF) --libs x11 xi)
wdw.CFLAGS += $(shell $(PKGCONF) --cflags x11 xi) 
wdw.CFLAGS += -DCC_BUILD_XINPUT2
wdw.CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_X11
else ifeq ($(wdw.USE),sdl2)
wdw.CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_SDL2
else ifeq ($(wdw.USE),sdl3)
wdw.CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_SDL3
else ifeq ($(wdw.USE),terminal)
wdw.CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_TERMINAL
else ifeq ($(wdw.USE),windows)
wdw.CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_WIN32
else ifeq ($(wdw.USE),wince)
wdw.CFLAGS += -DCC_WIN_BACKEND=CC_WIN_BACKEND_WIN32CE
endif

$(oc.build)/Window_%.c.o: $(oc.src)/Window_%.c | $(oc.build)
	$(CC) $(CFLAGS) $(wdw.CFLAGS) -c $< -o $@

override OBJS   += $(wdw.OBJS)
override LDLIBS += $(wdw.LDLIBS)
override CFLAGS += $(wdw.CFLAGS)
