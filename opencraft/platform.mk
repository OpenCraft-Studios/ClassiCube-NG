PTF_BACKENDS := linux posix mac-classic wince windows
PTF_USE       = $(filter $(PTF_BACKENDS), $(USE))
ifeq ($(PTF_USE), linux)
	PTF_USE     = posix
	PTF_CFLAGS += -DCC_BUILD_LINUX
endif

# TODO: BeOS won't compile
PTF_OBJS     := $(BUILD_DIR)/Platform_$(PTF_USE).c.o

ifeq ($(PTF_USE), )
	$(error Please, select a platform (mac-classic, posix, wince, windows))
else ifeq ($(PTF_USE), posix)
	PTF_LDLIBS += -lpthread
	PTF_CFLAGS += -DCC_BUILD_POSIX
else ifeq ($(PTF_USE), mac-classic)
	PTF_CFLAGS += -DCC_BUILD_MACCLASSIC
else ifeq ($(PTF_USE), wince)
	PTF_CFLAGS += -DCC_BUILD_WINCE
else ifeq ($(PTF_USE), windows)
	PTF_CFLAGS += -DCC_BUILD_WIN
#else ifeq ($(PTF_USE), beos)
#	PTF_CFLAGS += -DCC_BUILD_BEOS
endif

$(BUILD_DIR)/Platform_%.c.o: $(SRC_DIR)/Platform_%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(PTF_CFLAGS) -c $< -o $@

$(BUILD_DIR)/Platform_%.cpp.o: $(SRC_DIR)/Platform_%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(PTF_CXXFLAGS) -c $< -o $@

override OBJS   += $(PTF_OBJS)
override LDLIBS += $(PTF_LDLIBS)
override CFLAGS += $(PTF_CFLAGS)
