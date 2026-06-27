## —— Project settings ————————————————————————————————————————————————————————
  SRC := src
  BUILD := /tmp/opencraft.linux

  C_SOURCES := $(wildcard $(SRC)/*.c) # Main.c, Audio.c,...
  OBJECTS := $(patsubst $(SRC)/%.c,$(BUILD)/%.c.o,$(C_SOURCES)) # Main.c.o,...

## —— Toolchain settings ——————————————————————————————————————————————————————
  CC := cc
  LD := cc
  
  MAKE = make
  MAKEFLAGS += -j$(shell nproc) --no-print-directory
  
  CFLAGS  += -pipe -fno-math-errno -Werror -Wno-error=missing-braces -Wno-error=strict-aliasing
  LDFLAGS += -lX11 -lXi -lpthread -ldl -lm -lGL -rdynamic



EXECUTABLE := OpenCraft
$(EXECUTABLE): $(OBJECTS) $(BUILD)/libbearssl.a ## Makes the final game
	@printf "  $(BLUE)Linking the game...$(RESET)\n"
	@$(LD) $^ -o $@ $(LDFLAGS)
	@chmod +x $@


$(BUILD)/libbearssl.a: ## Builds BearSSL (needed for internet connection)
    # Delegates BearSSL build to its own Makefile
    # `TARGET` represents the name of the resultant file
	$(MAKE) -Cthird_party/bearssl TARGET=$@



$(BUILD)/%.c.o: $(SRC)/%.c | $(BUILD) ## Rule to compile C files
	@printf "  $(GREEN)Compiling$(RESET) %s\n" "$(@F)"
	@$(CC) $(CFLAGS) -c $< -o $@


$(BUILD): ## Create the build directory in case it doesn't exist
	mkdir -p $(BUILD)

clean:
	@rm -rf $(BUILD) $(EXECUTABLE)
	@$(MAKE) -Cthird_party/bearssl clean

-include misc/colors.mk