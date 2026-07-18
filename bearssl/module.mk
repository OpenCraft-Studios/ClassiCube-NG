bearssl.src    ?= $(CURDIR)/bearssl
bearssl.build  ?= /tmp/$(plat.USE)/bearssl
bearssl.SRCS   := $(wildcard $(bearssl.src)/*.c)
bearssl.OBJS   := $(patsubst $(bearssl.src)/%.c,$(bearssl.build)/%.c.o,$(bearssl.SRCS))

bearssl.CFLAGS += -DCC_SSL_BACKEND=CC_SSL_BACKEND_BEARSSL

$(bearssl.build)/%.c.o: $(bearssl.src)/%.c | $(bearssl.build)
	$(call log_compile,$(<F),bearssl,$(VERSION))
	$(CC) $(CFLAGS) $(bearssl.CFLAGS) -c $< -o $@

$(bearssl.build):
	@mkdir -p $@

override OBJS       += $(bearssl.OBJS)
override CFLAGS     += $(bearssl.CFLAGS)
override BUILD_DIRS += $(bearssl.build)
