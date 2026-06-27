## —— Project settings ————————————————————————————————————————————————————————
  src := src
  build := /tmp/opencraft.$(platform)

  C_SOURCES := $(wildcard $(src)/*.c) # Main.c, Audio.c,...
  OBJECTS := $(patsubst $(src)/%.c,$(build)/%.c.o,$(C_SOURCES)) # Main.c.o,...

## —— Toolchain settings ——————————————————————————————————————————————————————
  CC := cc
  LD := cc
  
  MAKE = make
  MAKEFLAGS += -j$(shell nproc) --no-print-directory
  
  CFLAGS  += -pipe -fno-math-errno
  LDFLAGS += -no-pie
  LIBS    += 

-include config.mk

target := OpenCraft
$(target): $(OBJECTS) $(build)/libbearssl.a ## Makes the final game
	@printf "  $(BLUE)Linking the game...$(RESET)\n"
	@$(LD) $(LDFLAGS) $^ -o $@ $(LIBS)
	@chmod +x $@


$(build)/libbearssl.a: ## Builds BearSSL (needed for internet connection)
    # Delegates BearSSL build to its own Makefile
    # `TARGET` represents the name of the resultant file
	$(MAKE) -Cthird_party/bearssl TARGET=$@



$(build)/%.c.o: $(src)/%.c | $(build) ## Rule to compile C files
	@printf "  $(GREEN)Compiling$(RESET) %s\n" "$(@F)"
	@$(CC) $(CFLAGS) -c $< -o $@


$(build): ## Create the build directory in case it doesn't exist
	mkdir -p $(build)

clean:
	@rm -rf $(build) $(target)
	@$(MAKE) -Cthird_party/bearssl clean

-include misc/colors.mk