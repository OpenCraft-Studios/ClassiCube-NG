### OpenCraft Build System, Powered by GNU Make
### Copyleft 🄯 OpenCraft Studios (2026)

.PHONY: clean full-clean env

# ——— Project settings ————————————————————————————————————————————————————————

PKGCONF     ?= pkg-config

TARGET      := OpenCraft
USE         := linux gl2 x11 openal openssl
VERSION     := $(shell git describe --always --tags --dirty="*" --abbrev=1)

oc.build     = /tmp/$(plat.USE)-opencraft
oc.src      := $(CURDIR)/opencraft

override SRCS := $(filter-out $(oc.src)/Platform_%,$(wildcard $(oc.src)/*.c))
override OBJS  = $(patsubst $(oc.src)/%.c,$(oc.build)/%.c.o,$(SRCS))

# ——— Modules —————————————————————————————————————————————————————————————————

include misc/logging.mk
include $(oc.src)/platform.mk
include $(oc.src)/certs.mk

include bearssl/module.mk

AUDIO    ?= 1
ifneq ($(AUDIO), 0)
include libaudio/module.mk
endif

OPENGFX  ?= 1
ifneq ($(OPENGFX), 0)
include graphics/module.mk
endif

WINDOW   ?= 1
ifneq ($(WINDOW), 0)
include window/module.mk
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
	@echo export LD=\"$(shell command -v ld.mold || command -v ld.lld || command -v ld.gold)\"\;
	@echo export CC=\"$(shell command -v clang || command -v gcc || command -v cc)\"\;
	@echo "# -s,--silent,--quiet:  Be silent, don't print recipes."
	@echo "# -j,--jobs=$(shell nproc):          Harness full PC power."
	@echo "# --no-print-directory: Don't print annoying messages if compiling recursively."
	@echo

# ——— Clangd configuration ————————————————————————————————————————————————————

PHONY: .clangd
.clangd:
	$(file >$@,CompileFlags:)
	$(file >>$@,  Compiler: $(CC))
	$(file >>$@,  Add:)
	$(foreach flag,$(CFLAGS),$(file >>$@,    - $(flag)))
	$(file >>$@,    - -D_CLANGD=1)
	$(file >>$@,  Remove:)
	$(file >>$@,    - -pipe)

# ——— Global variables ————————————————————————————————————————————————————————

override BUILD_DIRS   += $(oc.build)

override WARNINGS     += -Wno-unsafe-buffer-usage -Werror=missing-prototypes

override INCLUDES     += -I$(CURDIR)/include
override COMMON_FLAGS += $(ARCH_FLAGS) $(WARNINGS) $(INCLUDES) -pipe -DCC_BUILD_MANUAL
override CFLAGS       += $(COMMON_FLAGS)
override CXXFLAGS     += $(COMMON_FLAGS)
override LDFLAGS      += -s
override LDLIBS       += -lm
