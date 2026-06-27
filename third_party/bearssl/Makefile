SRC = .
BUILD := /tmp/bearssl.linux
C_SOURCES := $(wildcard $(SRC)/*.c)
OBJECTS := $(patsubst $(SRC)/%.c,$(BUILD)/%.c.o,$(C_SOURCES))


CC := cc
CFLAGS += -pipe

LIB_BEARSSL := libbearssl.a
$(LIB_BEARSSL): $(OBJECTS)
	ar rcs $@ $^

$(BUILD)/%.c.o: $(SRC)/%.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD):
	mkdir -p $(BUILD)

clean:
	@rm -rf $(BUILD)
	@rm -f $(LIB_BEARSSL)

.PHONY: clean
