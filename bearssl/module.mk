BSL_BUILD_DIR := $(BUILD_DIR)/bearssl
BSL_SRCS      := $(wildcard bearssl/*.c)
BSL_OBJS      := $(patsubst bearssl/%.c,$(BSL_BUILD_DIR)/%.c.o,$(BSL_SRCS))

BSL_CFLAGS += -DCC_SSL_BACKEND=CC_SSL_BACKEND_BEARSSL

$(BSL_BUILD_DIR)/%.c.o: bearssl/%.c | $(BSL_BUILD_DIR)
	$(call log_compile,$(<F),bearssl,$(VERSION))
	$(CC) $(CFLAGS) $(BSL_CFLAGS) -c $< -o $@

$(BSL_BUILD_DIR):
	@mkdir -p $@

override OBJS   += $(BSL_OBJS)
override CFLAGS += $(BSL_CFLAGS)
