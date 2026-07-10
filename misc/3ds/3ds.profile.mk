ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=path/to/devkitPro)
endif

PLATFORM_SPECIFIC := $(build)/3ds
OBJECTS += $(patsubst $(src)/3ds/%.c, $(PLATFORM_SPECIFIC)/%.c.o, $(wildcard $(src)/3ds/*.c))
OBJECTS += $(patsubst misc/3ds/%.v.pica, $(build)/%.shbin.o, $(wildcard misc/3ds/*.v.pica))

TARGET_BASE = ClassiCube-3ds
override target = $(TARGET_BASE).elf

ARCH      = -march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft
CTRULIB   = $(DEVKITPRO)/libctru
INCLUDES += $(foreach dir, $(CTRULIB), -I$(dir)/include)
override LDFLAGS = -specs=3dsx.specs -g $(ARCH) $(foreach dir, $(CTRULIB), -L$(dir)/lib)
LIBS += -lctru -lm
override CFLAGS  = -pipe -g -Wall -Os -mword-relocations -ffunction-sections $(ARCH) $(INCLUDES) -D__3DS__ -DPLAT_3DS

MAKEROM := $(build)/makerom

# Tools
include misc/3ds/build-cia.mk
include misc/3ds/build-smdh.mk
include misc/3ds/build-3dsx.mk
include misc/3ds/build-makerom.mk

$(PLATFORM_SPECIFIC)/%.c.o: src/3ds/%.c | $(PLATFORM_SPECIFIC)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@


$(build)/%.shbin: misc/3ds/%.v.pica | $(build)
	$(PICASSO) $< -o $@

$(build)/%.shbin.o: $(build)/%.shbin | $(build)
	$(BIN2S) $< | $(CC) -x assembler-with-cpp -c - -o $@

$(PLATFORM_SPECIFIC):
	@mkdir -p $(PLATFORM_SPECIFIC)