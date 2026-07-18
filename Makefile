### OpenCraft Build System, Powered by GNU Make
### Copyleft 🄯 OpenCraft Studios (2026)

.PHONY: clean full-clean env

# ——— Project settings ————————————————————————————————————————————————————————

PKGCONF     ?= pkg-config

TARGET      := OpenCraft
USE         := linux gl2 x11 openal openssl
VERSION     := $(shell git describe --always --tags --dirty="*" --abbrev=1)

oc.build    := /tmp/opencraft
oc.src      := $(CURDIR)/opencraft
bearssl.src := $(CURDIR)/bearssl

override SRCS := $(filter-out Graphics_% Audio% Platform_% Window_%,$(wildcard $(oc.src)/*.c))
override OBJS  = $(patsubst $(oc.src)/%.c,$(oc.build)/%.c.o,$(SRCS))

# ——— Modules —————————————————————————————————————————————————————————————————

oc.build    := /tmp/opencraft
oc.src      := $(CURDIR)/opencraft
bearssl.src := $(CURDIR)/bearssl

include misc/logging.mk
include $(oc.src)/platform.mk
include $(oc.src)/certs.mk

BEARSSL  ?= 1
ifneq ($(BEARSSL), 0)
include $(bearssl.src)/module.mk
endif

AUDIO    ?= 1
ifneq ($(AUDIO), 0)
include $(oc.src)/audio.mk
endif

OPENGFX  ?= 1
ifneq ($(OPENGFX), 0)
include $(oc.src)/opengfx.mk
endif

WINDOW   ?= 1
ifneq ($(WINDOW), 0)
include $(oc.src)/window.mk
endif

# ——— Targets —————————————————————————————————————————————————————————————————

.DEFAULT_GOAL := $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -fuse-ld=$(LD) $(LDFLAGS) $^ $(LDLIBS) -o $@
	$(call log_link,$@,$(words $(OBJS)))
	chmod +x $@

$(oc.build):
	@mkdir -p $@

# ——— Basic build rule ————————————————————————————————————————————————————————

$(oc.build)/%.c.o: $(oc.src)/%.c | $(oc.build)
	$(call log_compile,$(<F),opencraft,$(VERSION))
	$(CC) $(CFLAGS) -c $< -o $@

# ——— Helpers —————————————————————————————————————————————————————————————————

## Performs a basic clean of the build directories
clean:
	rm -rf $(BUILD_DIRS) $(TARGET)

## Performs a basic clean and deletes files that git doesn't track
## ! Use with precaution
full-clean: clean
	git clean -fd
	git clean -fdX

## Helps with git bisect run
## * Execute [`git bisect run make bisect`] to find bugs easily
bisect: $(TARGET) .WAIT full-clean

## Detects the system toolchain
## * Execute [`eval "$(make env)"`] to setup your environment
env:
	@echo export MAKEFLAGS=\"-sj$(shell nproc) --no-print-directory\"\;
	@echo export LD=\"$(shell command -v ld.mold || command -v lld || command -v ld.gold)\"\;
	@echo export CC=\"$(shell command -v clang || command -v gcc || command -v cc)\"\;
	@echo "# -s,--silent,--quiet:  Be silent, don't print recipes."
	@echo "# -j,--jobs=$(shell nproc):          Harness full PC power."
	@echo "# --no-print-directory: Don't print annoying messages if compiling recursively."
	@echo 

# ——— Global variables ————————————————————————————————————————————————————————

override BUILD_DIRS   += $(oc.build)

override COMMON_FLAGS += $(ARCH_FLAGS) -pipe -DCC_BUILD_MANUAL
override CFLAGS       += $(COMMON_FLAGS)
override CXXFLAGS     += $(COMMON_FLAGS)
override LDFLAGS      +=
override LDLIBS       += -lm
