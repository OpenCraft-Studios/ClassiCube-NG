compiler-info:
	@echo "══════════════════════════════════════════════"
	@echo "        COMPILER & TARGET FULL DIAGNOSTIC"
	@echo "══════════════════════════════════════════════"

	@echo ""
	@echo "┌─ [1] COMPILER IDENTITY ─────────────────────"
	@echo "  Binary:     $(CC)"
	@$(CC) --version 2>/dev/null | sed 's/^/  /' || echo "  (--version not supported)"
	@$(CC) -v 2>&1 | sed 's/^/  /' || true
	@echo ""
	@echo "  GCC/Clang/Intel macros:"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E "__GNUC__|__GNUC_MINOR__|__GNUC_PATCHLEVEL__|__clang__|__clang_major__|__clang_minor__|__clang_patchlevel__|__INTEL_COMPILER|__INTEL_LLVM_COMPILER|__CC_ARM|__ARMCC_VERSION|__TCC__|__TINYC__|__PCC__|__SDCC" | sort || true

	@echo ""
	@echo "┌─ [2] C STANDARD & LANGUAGE MODE ───────────"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E "__STDC__|__STDC_VERSION__|__STDC_HOSTED__|__STDC_NO_ATOMICS__|__STDC_NO_COMPLEX__|__STDC_NO_THREADS__|__STDC_NO_VLA__|__STRICT_ANSI__|__cplusplus|__OBJC__|__ASSEMBLER__" | sort || true

	@echo ""
	@echo "┌─ [3] TARGET ARCHITECTURE ───────────────────"
	@echo "  Architecture family macros:"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E \
		"__x86_64__|__i386__|__i486__|__i586__|__i686__|\
__aarch64__|__arm__|__ARM_ARCH|__ARM_ARCH_PROFILE|\
__thumb__|__thumb2__|__ARM_THUMB_ISA_VERSION__|\
__riscv|__riscv_xlen|\
__mips__|__mips|__MIPS__|\
__powerpc__|__powerpc64__|__ppc__|__PPC__|\
__sh__|__SH4__|\
__m68k__|__mc68000__|\
__sparc__|__sparc64__|\
__AVR__|__AVR_ARCH__|\
__Z80__|__gbz80__|\
__xtensa__|__XTENSA__|\
__nds32__|__NDS32__" | sort || true

	@echo ""
	@echo "  Pointer / word size:"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E "__SIZEOF_POINTER__|__SIZEOF_INT__|__SIZEOF_LONG__|__SIZEOF_LONG_LONG__|__SIZEOF_SIZE_T__|__POINTER_WIDTH__|__INTPTR_WIDTH__|__SIZE_WIDTH__|__INT_WIDTH__|__LONG_WIDTH__|__LONG_LONG_WIDTH__|__BIGGEST_ALIGNMENT__" | sort || true

	@echo ""
	@echo "  Endianness:"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E "__BYTE_ORDER__|__ORDER_LITTLE_ENDIAN__|__ORDER_BIG_ENDIAN__|__ORDER_PDP_ENDIAN__|__LITTLE_ENDIAN__|__BIG_ENDIAN__|__ARMEB__|__MIPSEB__|__MIPSEL__" | sort || true

	@echo ""
	@echo "┌─ [4] ARM-SPECIFIC DETAIL* ──────────────────"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E \
		"__ARM_ARCH$|__ARM_ARCH_[0-9]|\
__ARM_FEATURE_|__ARM_NEON|__ARM_NEON__|\
__ARM_FP$|__ARM_FPV|__VFP_FP__|\
__SOFTFP__|__ARM_PCS__|__ARM_PCS_VFP|\
__ARM_SIZEOF_WCHAR_T|__ARM_SIZEOF_MINIMAL_ENUM|\
__ARM_EABI__|__ARM_32BIT_STATE|__ARM_64BIT_STATE|\
__ARM_ACLE" | sort || true

	@echo ""
	@echo "┌─ [5] FPU & FLOAT ABI ───────────────────────"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E \
		"__SOFTFP__|__VFP_FP__|__FPU_PRESENT|\
__SIZEOF_FLOAT__|__SIZEOF_DOUBLE__|__SIZEOF_LONG_DOUBLE__|\
__FLOAT_WORD_ORDER__|__FLT_EVAL_METHOD__|\
__FLT_MANT_DIG__|__DBL_MANT_DIG__|__LDBL_MANT_DIG__|\
__SSE__|__SSE2__|__SSE4_1__|__AVX__|__AVX2__|\
__FP_FAST_FMA|__FP_FAST_FMAF" | sort || true

	@echo ""
	@echo "┌─ [6] ABI & CALLING CONVENTION ──────────────"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E \
		"__ARM_PCS|__ARM_AAPCS|__ELF__|\
__WCHAR_TYPE__|__WCHAR_MAX__|__WCHAR_MIN__|__WCHAR_UNSIGNED__|\
__WINT_TYPE__|__WINT_MAX__|__WINT_UNSIGNED__|\
__CHAR_UNSIGNED__|__CHAR_SIGNED__|__CHAR_BIT__|\
__INT_MAX__|__LONG_MAX__|__LONG_LONG_MAX__|__SHRT_MAX__|\
__SCHAR_MAX__|__UCHAR_MAX__|\
__INT8_TYPE__|__INT16_TYPE__|__INT32_TYPE__|__INT64_TYPE__|\
__UINT8_TYPE__|__UINT16_TYPE__|__UINT32_TYPE__|__UINT64_TYPE__|\
__INTPTR_TYPE__|__UINTPTR_TYPE__|__PTRDIFF_TYPE__|__SIZE_TYPE__|\
__REGISTER_PREFIX__|__USER_LABEL_PREFIX__" | sort || true

	@echo ""
	@echo "┌─ [7] MEMORY MODEL & ADDRESSING ─────────────"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E \
		"__CODE_MODEL__|__model__|__pic__|__PIC__|__pie__|__PIE__|\
__POSITION_INDEPENDENT_CODE__|__NO_INLINE__|\
__HAVE_BUILTIN_SETJMP__|__BUILTIN_|__builtin_|\
__SRAM_START__|__FLASH_START__|__HEAP_" | sort || true

	@echo ""
	@echo "┌─ [8] OPTIMIZATION & ACTIVE FEATURES ────────"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E \
		"__OPTIMIZE__|__OPTIMIZE_SIZE__|__NO_INLINE__|\
__fast_math__|__FINITE_MATH_ONLY__|\
__GCC_HAVE_SYNC_COMPARE_AND_SWAP|\
__ATOMIC_|__HAVE_SPECULATION_SAFE_VALUE|\
__BUILTIN_CPU_SUPPORTS|__BUILTIN_IA32" | sort || true

	@echo ""
	@echo "┌─ [9] OS / EXECUTION ENVIRONMENT ────────────"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -E \
		"__linux__|__unix__|__APPLE__|__WIN32__|__CYGWIN__|\
__MINGW32__|__MINGW64__|__ANDROID__|\
__NEWLIB__|__GLIBC__|__UCLIBC__|__MUSL__|\
__PICOLIBC__|__AEABI__|__ELF__|\
__bare_metal__|__rtems__|__vxworks|\
__STDC_HOSTED__" | sort || true

	@echo ""
	@echo "┌─ [10] SDK / VENDOR MACROS (wildcard) ───────"
	@echo "  (any non-standard macros bundled by the SDK):"
	@echo | $(CC) -dM -E - 2>/dev/null | grep -Ev \
		"^#define (__STDC|__GNUC|__clang|__arm|__ARM|__thumb|__x86|__i[3-9]86|__aarch|__riscv|__mips|__ppc|__powerpc|__sparc|__sh|__m68k|__AVR|__xtensa|__SIZEOF|__BYTE_ORDER|__ORDER|__HAVE|__GCC|__INT|__UINT|__SCHAR|__CHAR|__WCHAR|__WINT|__PTRDIFF|__SIZE|__UINTPTR|__INTPTR|__FLOAT|__FLT|__DBL|__LDBL|__FP|__SSE|__AVX|__ATOMIC|__LITTLE|__BIG|__ELF|__linux|__unix|__APPLE|__WIN|__CYGWIN|__MINGW|__ANDROID|__NEWLIB|__GLIBC|__UCLIBC|__MUSL|__PICOLIBC|__AEABI|__PIC|__PIE|__OPTIMIZE|__NO_INLINE|__REGISTER|__USER_LABEL|__BIGGEST|__POINTER|__cplusplus|__OBJC|__ASSEMBLER|__STRICT_ANSI|__STDC_VERSION|_STDC)" \
		2>/dev/null | sort || true

	@echo ""
	@echo "┌─ [11] SUPPORTED TARGET OPTIONS ─────────────"
	@$(CC) -Q --help=target 2>/dev/null | sed 's/^/  /' || echo "  (--help=target no soportado)"

	@echo ""
	@echo "┌─ [12] SUPPORTED OPTIMIZATION OPTIONS ───────"
	@$(CC) -Q --help=optimizers 2>/dev/null | sed 's/^/  /' || echo "  (--help=optimizers no soportado)"

	@echo ""
	@echo "┌─ [13] SUPPORTED WARNING OPTIONS ────────────"
	@$(CC) -Q --help=warnings 2>/dev/null | sed 's/^/  /' || echo "  (--help=warnings no soportado)"

	@echo ""
	@echo "┌─ [14] DUMP COMPLETO DE SPECS ───────────────"
	@$(CC) -dumpspecs 2>/dev/null | sed 's/^/  /' || echo "  (-dumpspecs no soportado)"

	@echo ""
	@echo "┌─ [15] MULTILIBS DISPONIBLES ────────────────"
	@$(CC) -print-multi-lib 2>/dev/null | sed 's/^/  /' || echo "  (-print-multi-lib no soportado)"
	@$(CC) -print-multi-directory 2>/dev/null | sed 's/^/  dir: /' || true
	@$(CC) -print-multi-os-directory 2>/dev/null | sed 's/^/  os-dir: /' || true

	@echo ""
	@echo "┌─ [16] RUTAS DE BÚSQUEDA ────────────────────"
	@$(CC) -print-search-dirs 2>/dev/null | sed 's/^/  /' || echo "  (-print-search-dirs no soportado)"
	@$(CC) -print-sysroot 2>/dev/null | sed 's/^/  sysroot: /' || true
	@$(CC) -print-file-name=libc.a 2>/dev/null | sed 's/^/  libc.a: /' || true
	@$(CC) -print-file-name=libgcc.a 2>/dev/null | sed 's/^/  libgcc.a: /' || true
	@$(CC) -print-libgcc-file-name 2>/dev/null | sed 's/^/  libgcc: /' || true

	@echo ""
	@echo "┌─ [17] PREPROCESSOR: INCLUDE PATHS ──────────"
	@echo | $(CC) -v -E - 2>&1 | grep -A 50 "#include <...>" | sed 's/^/  /' || true

	@echo ""
	@echo "┌─ [18] AVAILABLE BUILT-IN FUNCTIONS ─────────"
	@$(CC) -E -dM - < /dev/null 2>/dev/null | grep "__builtin_" | sort | sed 's/^/  /' || true

	@echo ""
	@echo "══════════════════════════════════════════════"
	@echo "         THE DIAGNOSTIC HAS ENDED"
	@echo "══════════════════════════════════════════════"