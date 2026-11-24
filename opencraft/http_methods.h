// SPDX-License-Identifier: BSD-3-Clause
// Copyright (C) 2026-2027 OpenCraft Studios

#define LIST_HTTP_METHODS(M)        \
	M(GET)     M(HEAD)   M(POST)    \
	M(PUT)     M(DELETE) M(CONNECT) \
	M(OPTIONS) M(TRACE)  M(PATCH)

enum http_method : unsigned char {
	#define ENUMERATE(METHOD) HTTP_##METHOD,
	LIST_HTTP_METHODS(ENUMERATE)
	#undef ENUMERATE
};

static const char* HTTP_METHOD_NAMES[] = {
	#define ENUM_AS_STRING(METHOD) #METHOD,
	LIST_HTTP_METHODS(ENUM_AS_STRING)
	#undef ENUM_AS_STRING
};

#undef LIST_HTTP_METHODS
