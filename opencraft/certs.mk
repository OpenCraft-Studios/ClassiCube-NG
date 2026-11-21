CRT_BACKENDS := windows android openssl apple-sec
CRT_USE       = $(lastword $(filter $(CRT_BACKENDS), $(USE)))

ifeq ($(CRT_USE), )
	override CRT_USE = openssl
endif

ifeq ($(CRT_USE), windows)
	CRT_CFLAGS += -DCC_CRT_BACKEND=CC_CRT_BACKEND_WINCRYPTO
else ifeq ($(CRT_USE), android)
	CRT_CFLAGS += -DCC_CRT_BACKEND=CC_CRT_BACKEND_ANDROID
else ifeq ($(CRT_USE), openssl)
	CRT_CFLAGS += -DCC_CRT_BACKEND=CC_CRT_BACKEND_OPENSSL
else ifeq ($(CRT_USE), apple-sec)
	CRT_CFLAGS += -DCC_CRT_BACKEND=CC_CRT_BACKEND_APPLESEC
endif

override CFLAGS += $(CRT_CFLAGS)
