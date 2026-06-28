## —— Project settings ————————————————————————————————————————————————————————
  src := src
  
  ifeq ($(platform),)
  	$(warning platform is not defined)
  endif
  build := /tmp/opencraft.$(platform)

  C_SOURCES := $(wildcard $(src)/*.c) # Main.c, Audio.c,...
  OBJECTS := $(patsubst $(src)/%.c,$(build)/%.c.o,$(C_SOURCES)) # Main.c.o,...

## —— Toolchain settings ——————————————————————————————————————————————————————
  CC := cc
  LD := cc
  
  MAKE ?= make
  MAKEFLAGS += -j$(shell nproc) --no-print-directory
  
  CFLAGS  += -fno-pie -pipe -fno-math-errno $(EXTRA_CFLAGS)
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
	@$(CC) $(CFLAGS) -c $< -o $@


$(build): ## Create the build directory in case it doesn't exist
	mkdir -p $(build)

compiler-info:
	@echo "——————— COMPILER INFO ———————"
	@echo "Endianness:"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E "__BYTE_ORDER__|__ORDER_LITTLE_ENDIAN__|__ORDER_BIG_ENDIAN__" || true
	@echo ""
	@echo "Predefined macros:"
	@echo | $(CC) -dM -E - 2>/dev/null | sort
	@echo ""
	@echo "SIMD / ISA hints:"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E "__AVX|__SSE|__ARM_NEON|__riscv_v" || true
	@echo ""
	@echo "Target architecture macros:"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E "__x86_64__|__i386__|__aarch64__|__arm__|__riscv" || true
	@echo ""
	@echo "C standard in use:"
	@$(CC) -E -dM - < /dev/null 2>/dev/null | grep -E "__STDC_VERSION__|__STDC__" || true
	@echo ""
	@echo "GCC/Clang feature test macros (if available):"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E "__GNUC__|__clang__|__INTEL_COMPILER" || true
	@echo "——————— TARGET FLAGS ———————"
	@$(CC) -Q --help=target 2>/dev/null || true
	@echo "Compiler:           $(CC)"
	@$(CC) --version 2>/dev/null | sed 's/^/  /' || true

clean:
	@rm -rf $(build) $(target)
	@$(MAKE) -Cthird_party/bearssl clean

-include misc/colors.mk
.PHONY: clean compiler-info