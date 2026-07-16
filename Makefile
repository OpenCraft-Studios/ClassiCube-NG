# TODO: Logging
# TODO: Add colors

PKGCONF ?= pkg-config
CC ?= clang
LD ?= mold

TARGET    := OpenCraft
USE       := openal gl2 linux x11 openssl
SRC_DIR   := opencraft
BUILD_DIR := /tmp/opencraft

override SRCS := $(filter-out Graphics_% Audio% Platform_% Window_%, $(wildcard $(SRC_DIR)/*.c))
override OBJS  = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.c.o, $(SRCS))

.DEFAULT: $(TARGET)

native: ARCH_FLAGS += -O3 -march=native -mtune=native
native: $(TARGET)

include $(SRC_DIR)/platform.mk
include $(SRC_DIR)/certs.mk

BEARSSL  ?= 1
ifneq ($(BEARSSL), 0)
include bearssl/module.mk
endif

AUDIO    ?= 1
ifneq ($(AUDIO), 0)
include $(SRC_DIR)/audio.mk
endif

OPENGFX  ?= 1
ifneq ($(OPENGFX), 0)
include $(SRC_DIR)/opengfx.mk
endif

WINDOW   ?= 1
ifneq ($(WINDOW), 0)
include $(SRC_DIR)/window.mk
endif

$(TARGET): $(OBJS)
	$(CC) -fuse-ld=$(LD) $(LDFLAGS) $^ $(LDLIBS) -o $@
	chmod +x $@

$(BUILD_DIR)/%.c.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR):
	@mkdir -p $@


clean:
	rm -rf $(BUILD_DIR) $(TARGET)

.PHONY: clean

override COMMON_FLAGS += $(ARCH_FLAGS) -DCC_BUILD_MANUAL
override CFLAGS       += $(COMMON_FLAGS)
override CXXFLAGS     += $(COMMON_FLAGS)
override LDFLAGS      +=
override LDLIBS       += -lm
