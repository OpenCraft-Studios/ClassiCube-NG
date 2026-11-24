bearssl.src    ?= $(dir $(lastword $(MAKEFILE_LIST)))
bearssl.build  ?= /tmp/$(plat.USE)-bearssl
bearssl.SRCS   := $(wildcard $(bearssl.src)/*.c)
bearssl.OBJS   := $(patsubst $(bearssl.src)/%.c,$(bearssl.build)/%.c.o,$(bearssl.SRCS))

$(bearssl.build)/%.c.o: $(bearssl.src)/%.c | $(bearssl.build)
	$(call log_compile,$(<F),bearssl,$(VERSION))
	$(CC) $(CFLAGS) -c $< -o $@

$(bearssl.build):
	@mkdir -p $@

override OBJS       += $(bearssl.OBJS)
override BUILD_DIRS += $(bearssl.build)
