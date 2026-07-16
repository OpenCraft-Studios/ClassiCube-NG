GFX_BACKENDS := gl1 gl2 gl11 softgpu softmin softfp d3d9 d3d11
GFX_USE       = $(filter $(GFX_BACKENDS), $(USE))
GFX_OBJS     := $(BUILD_DIR)/Graphics_$(GFX_USE).c.o

ifeq ($(GFX_USE), )
	$(error Please, select a graphic backend or disable OpenGFX (make ... OPENGFX=0))
else ifeq ($(GFX_USE), gl1)
	GFX_IS_OPENGL = 1
	GFX_CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_GL1
else ifeq ($(GFX_USE), gl2)
	GFX_IS_OPENGL = 1
	GFX_CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_GL2
else ifeq ($(GFX_USE), gl11)
	GFX_IS_OPENGL = 1
	GFX_CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_GL11
	GFX_CFLAGS    += -DCC_BUILD_GL11
else ifeq ($(GFX_USE), softgpu)
	GFX_CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_SOFTGPU
else ifeq ($(GFX_USE), softmin)
	GFX_CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_SOFTMIN
else ifeq ($(GFX_USE), softfp)
	GFX_CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_SOFTFP
else ifeq ($(GFX_USE), d3d9)
	GFX_CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_D3D9
else ifeq ($(GFX_USE), d3d11)
	GFX_CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_D3D11
endif

ifdef GFX_IS_OPENGL
	GFX_LDLIBS += $(shell $(PKGCONF) --libs gl) -ldl
	GFX_CFLAGS += $(shell $(PKGCONF) --cflags gl)
endif

$(BUILD_DIR)/Graphics_%.c.o: $(SRC_DIR)/Graphics_%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(GFX_CFLAGS) -c $< -o $@

override OBJS   += $(GFX_OBJS)
override LDLIBS += $(GFX_LDLIBS)
override CFLAGS += $(GFX_CFLAGS)
