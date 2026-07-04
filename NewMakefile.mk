## —— Project settings ————————————————————————————————————————————————————————
  src := src
  
  ifeq ($(platform),)
  	$(warning platform is not defined)
  endif
  build := /tmp/opencraft.$(platform)

  C_SOURCES := $(wildcard $(src)/*.c) # Main.c, Audio.c,...
  OBJECTS := $(patsubst $(src)/%.c,$(build)/%.c.o,$(C_SOURCES)) # Main.c.o,...

## —— Toolchain settings ——————————————————————————————————————————————————————
  CC ?= cc
  LD ?= cc
  
  MAKE ?= make
  MAKEFLAGS += -j$(shell nproc) --no-print-directory
  
  CFLAGS  += -O2 -fno-pie -pipe -fno-math-errno $(EXTRA_CFLAGS)
  LDFLAGS += -no-pie $(EXTRA_LDFLAGS)

-include config.mk

$(info -- LINKER		$(LD) $(LDFLAGS) OBJECTS -o TARGET $(LIBS))
target := OpenCraft
$(target): $(OBJECTS) $(build)/libbearssl.a ## Makes the final game
	@printf "  $(BLUE)Linking the game...$(RESET)\n"
	@$(LD) $(LDFLAGS) $^ -o $@ $(LIBS)
	@chmod +x $@


$(build)/libbearssl.a: ## Builds BearSSL (needed for internet connection)
    # Delegates BearSSL build to its own Makefile
    # `TARGET` represents the name of the resultant file
	@$(MAKE) -Cthird_party/bearssl TARGET=$@


$(info -- COMPILER		$(CC) $(CFLAGS) -c INPUTFILE -o OUTPUTFILE)
$(build)/%.c.o: $(src)/%.c | $(build) ## Rule to compile C files
	@printf "  $(GREEN)Compiling$(RESET) %s\n" "$(@F)"
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@


$(build): ## Create the build directory in case it doesn't exist
	mkdir -p $(build)

clean:
	@rm -rf $(build) $(target)
	@$(MAKE) -Cthird_party/bearssl clean

include misc/diagnostic.mk
-include misc/colors.mk
.PHONY: clean compiler-info