#ifndef CC_CORE_H
#define CC_CORE_H
/*
Core fixed-size integer types, automatic platform detection, and common small structs
Copyright 2014-2025 ClassiCube | Licensed under BSD-3
*/

#if defined(_MSC_VER)
	typedef signed __int8  cc_int8;
	typedef signed __int16 cc_int16;
	typedef signed __int32 cc_int32;
	typedef signed __int64 cc_int64;
	
	typedef unsigned __int8  cc_uint8;
	typedef unsigned __int16 cc_uint16;
	typedef unsigned __int32 cc_uint32;
	typedef unsigned __int64 cc_uint64;
	#ifdef _WIN64
	typedef unsigned __int64 cc_uintptr;
	#else
	typedef unsigned __int32 cc_uintptr;
	#endif
	
#if defined(_MSC_VER) && _MSC_VER <= 1500
	#define CC_INLINE
	#define CC_NOINLINE
#else
	#define CC_INLINE   inline
	#define CC_NOINLINE __declspec(noinline)
#endif
	
	#ifndef CC_API
		#define CC_API __declspec(dllexport, noinline)
		#define CC_VAR __declspec(dllexport)
	#endif
	
	#define CC_HAS_TYPES
	#define CC_HAS_MISC
#elif __GNUC__
	/* really old GCC/clang might not have these defined */
	#ifdef __INT8_TYPE__
	/* avoid including <stdint.h> because it breaks defining UNICODE in Platform.c with MinGW */
	typedef __INT8_TYPE__  cc_int8;
	typedef __INT16_TYPE__ cc_int16;
	typedef __INT32_TYPE__ cc_int32;
	typedef __INT64_TYPE__ cc_int64;
	
	#ifdef __UINT8_TYPE__
	typedef __UINT8_TYPE__   cc_uint8;
	typedef __UINT16_TYPE__  cc_uint16;
	typedef __UINT32_TYPE__  cc_uint32;
	typedef __UINT64_TYPE__  cc_uint64;
	typedef __UINTPTR_TYPE__ cc_uintptr;
	#else
	/* clang doesn't define the __UINT8_TYPE__ */
	typedef unsigned __INT8_TYPE__   cc_uint8;
	typedef unsigned __INT16_TYPE__  cc_uint16;
	typedef unsigned __INT32_TYPE__  cc_uint32;
	typedef unsigned __INT64_TYPE__  cc_uint64;
	typedef unsigned __INTPTR_TYPE__ cc_uintptr;
	#endif
	#define CC_HAS_TYPES
	#endif
	
	#ifndef CC_INLINE
		#define CC_INLINE inline
		#define CC_NOINLINE __attribute__((noinline))
	#endif

	#ifndef CC_API
	#ifdef _WIN32
		#define CC_API __attribute__((dllexport, noinline))
		#define CC_VAR __attribute__((dllexport))
	#else
		#define CC_API __attribute__((visibility("default"), noinline))
		#define CC_VAR __attribute__((visibility("default")))
	#endif
	#endif
	
	#define CC_HAS_MISC
	#ifdef __BIG_ENDIAN__
	#define CC_BIG_ENDIAN
	#endif
#elif __MWERKS__
	/* TODO: Is there actual attribute support for CC_API etc somewhere? */
	#define CC_BIG_ENDIAN
#endif

/* Only used on GBA to store some variables in EWRAM instead of IWRAM */
#define CC_BIG_VAR

#ifdef _MSC_VER
	#define CC_ALIGNED(x) __declspec(align(x))
#else
	#define CC_ALIGNED(x) __attribute__((aligned(x)))
#endif

/* Unrecognised compiler, so just go with some sensible default typedefs */
/* Don't use <stdint.h>, as good chance such a compiler doesn't support it */
#ifndef CC_HAS_TYPES
typedef signed char  cc_int8;
typedef signed short cc_int16;
typedef signed int   cc_int32;
typedef signed long long cc_int64;

typedef unsigned char  cc_uint8;
typedef unsigned short cc_uint16;
typedef unsigned int   cc_uint32;
typedef unsigned long long cc_uint64;
typedef unsigned long  cc_uintptr;
#endif
#ifndef CC_HAS_MISC
#define CC_INLINE
#define CC_NOINLINE
#define CC_API
#define CC_VAR
#endif

typedef cc_uint32 cc_codepoint;
typedef cc_uint16 cc_unichar;
typedef cc_uint8  cc_bool;
#ifdef __APPLE__
/* TODO: REMOVE THIS AWFUL AWFUL HACK */
#include <stdbool.h>
#elif defined(__cplusplus)
#else
#define true 1
#define false 0
#endif

#ifndef NULL
#if defined(__cplusplus)
#define NULL 0
#else
#define NULL ((void*)0)
#endif
#endif