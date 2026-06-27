SRC = .
BUILD := /tmp/bearssl.linux
C_SOURCES := $(wildcard $(SRC)/*.c)
OBJECTS := $(patsubst $(SRC)/%.c,$(BUILD)/%.c.o,$(C_SOURCES))


CC := cc
CFLAGS += -pipe

TARGET := libbearssl.a
$(TARGET): $(OBJECTS)
	@ar rcs $@ $^

$(BUILD)/%.c.o: $(SRC)/%.c | $(BUILD)
	@printf "  $(GREEN)Compiling$(RESET) %s\n" "$(@F)"
	@$(CC) $(CFLAGS) -c $< -o $@

$(BUILD):
	mkdir -p $(BUILD)

clean:
	@rm -rf $(BUILD)
	@rm -f $(LIB_BEARSSL)


.PHONY: clean
-include ../../misc/colors.mk
