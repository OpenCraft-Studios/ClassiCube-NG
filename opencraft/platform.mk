override PTF_BACKENDS := linux posix mac-classic wince windows

plat.USE       = $(filter $(PTF_BACKENDS),$(USE))
ifeq ($(plat.USE), linux)
plat.USE     = posix
plat.CFLAGS += -DCC_BUILD_LINUX
endif

# TODO: Add support for BeOS
plat.OBJS := $(oc.build)/Platform_$(plat.USE).c.o

ifeq ($(plat.USE),)
$(error Please, select a platform (mac-classic, posix, wince, windows))
else ifeq ($(plat.USE),posix)
plat.LDLIBS += -lpthread
plat.CFLAGS += -DCC_BUILD_POSIX
else ifeq ($(plat.USE),mac-classic)
plat.CFLAGS += -DCC_BUILD_MACCLASSIC
else ifeq ($(plat.USE),wince)
plat.CFLAGS += -DCC_BUILD_WINCE
else ifeq ($(plat.USE),windows)
plat.CFLAGS += -DCC_BUILD_WIN
#else ifeq ($(plat.USE), beos)
#plat.CFLAGS += -DCC_BUILD_BEOS
endif

$(oc.build)/Platform_%.c.o: $(oc.src)/Platform_%.c | $(oc.build)
	$(CC) $(CFLAGS) $(plat.CFLAGS) -c $< -o $@

$(oc.build)/Platform_%.cpp.o: $(oc.src)/Platform_%.cpp | $(oc.build)
	$(CXX) $(CXXFLAGS) $(plat.CXXFLAGS) -c $< -o $@

override OBJS   += $(plat.OBJS)
override LDLIBS += $(plat.LDLIBS)
override CFLAGS += $(plat.CFLAGS)
