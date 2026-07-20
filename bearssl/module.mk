bearssl.src    ?= $(dir $(lastword $(MAKEFILE_LIST)))
bearssl.build  ?= /tmp/$(plat.USE)-bearssl
bearssl.SRCS   := $(wildcard $(bearssl.src)/*.c)
bearssl.OBJS   := $(patsubst $(bearssl.src)/%.c,$(bearssl.build)/%.c.o,$(bearssl.SRCS)) $(oc.build)/SSL.c.o

bearssl.CFLAGS += -DOC_SSL_HAS_BACKEND=1

$(bearssl.build)/%.c.o: $(bearssl.src)/%.c | $(bearssl.build)
	$(call log_compile,$(<F),bearssl,$(VERSION))
	$(CC) $(CFLAGS) -c $< -o $@

$(oc.build)/SSL.c.o: $(oc.src)/SSL.c
	$(call log_compile,$(<F),opencraft,$(VERSION))
	$(CC) $(CFLAGS) -c $< -o $@

$(bearssl.build):
	@mkdir -p $@

override OBJS       += $(bearssl.OBJS)
override CFLAGS     += $(bearssl.CFLAGS)
override BUILD_DIRS += $(bearssl.build)
