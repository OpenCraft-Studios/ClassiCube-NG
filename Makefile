PKGCONF ?= pkg-config

TARGET    := OpenCraft
USE       := linux gl2 x11 openal openssl
SRC_DIR   := opencraft
BUILD_DIR := /tmp/$(PTF_USE)-opencraft
VERSION   := $(shell git describe --always --tags --dirty="*" --abbrev=1)

override SRCS := $(filter-out Graphics_% Audio% Platform_% Window_%,$(wildcard $(SRC_DIR)/*.c))
override OBJS  = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.c.o,$(SRCS))

.DEFAULT_GOAL := $(TARGET)

oc.build    := /tmp/opencraft
oc.src      := $(CURDIR)/opencraft
bearssl.src := $(CURDIR)/bearssl

include misc/logging.mk
include $(oc.src)/platform.mk
include $(oc.src)/certs.mk

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
	$(call log_link,$@,$(words $(OBJS)))
	chmod +x $@

$(BUILD_DIR)/%.c.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(call log_compile,$(<F),opencraft,$(VERSION))
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR):
	@mkdir -p $@


clean:
	rm -rf $(BUILD_DIR) $(TARGET)

env:
	@echo export MAKEFLAGS=\"-sj$(shell nproc) --no-print-directory\"\;
	@echo export LD=\"$(shell command -v ld.mold || command -v lld || command -v ld.gold)\"\;
	@echo export CC=\"$(shell command -v clang || command -v gcc || command -v cc)\"\;
	@echo "# -s,--silent,--quiet:  Be silent, don't print recipes."
	@echo "# -j,--jobs=$(shell nproc):          Harness full PC power."
	@echo "# --no-print-directory: Don't print annoying messages if compiling recursively."
	@echo 

.PHONY: clean env
include misc/logging.mk

override COMMON_FLAGS += $(ARCH_FLAGS) -DCC_BUILD_MANUAL
override CFLAGS       += $(COMMON_FLAGS)
override CXXFLAGS     += $(COMMON_FLAGS)
override LDFLAGS      +=
override LDLIBS       += -lm
