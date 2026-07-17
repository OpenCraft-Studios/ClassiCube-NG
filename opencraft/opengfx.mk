override GFX_BACKENDS := gl1 gl2 gl11 softgpu softmin softfp d3d9 d3d11
gfx.USE   = $(filter $(GFX_BACKENDS),$(USE))
gfx.OBJS := $(oc.build)/Graphics_$(gfx.USE).c.o

ifeq ($(gfx.USE),)
$(error Please, select a graphic backend or disable OpenGFX (make ... OPENGFX=0))
else ifeq ($(gfx.USE),gl1)
GFX_IS_OPENGL = 1
gfx.CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_GL1
else ifeq ($(gfx.USE),gl2)
GFX_IS_OPENGL = 1
gfx.CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_GL2
else ifeq ($(gfx.USE),gl11)
GFX_IS_OPENGL = 1
gfx.CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_GL11
gfx.CFLAGS    += -DCC_BUILD_GL11
else ifeq ($(gfx.USE),softgpu)
gfx.CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_SOFTGPU
else ifeq ($(gfx.USE),softmin)
gfx.CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_SOFTMIN
else ifeq ($(gfx.USE),softfp)
gfx.CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_SOFTFP
else ifeq ($(gfx.USE),d3d9)
gfx.CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_D3D9
else ifeq ($(gfx.USE),d3d11)
gfx.CFLAGS    += -DCC_GFX_BACKEND=CC_GFX_BACKEND_D3D11
endif

ifdef GFX_IS_OPENGL
gfx.LDLIBS += $(shell $(PKGCONF) --libs gl) -ldl
gfx.CFLAGS += $(shell $(PKGCONF) --cflags gl)
endif

$(oc.build)/Graphics_%.c.o: $(oc.src)/Graphics_%.c | $(oc.build)
	$(CC) $(CFLAGS) $(gfx.CFLAGS) -c $< -o $@

override OBJS   += $(gfx.OBJS)
override LDLIBS += $(gfx.LDLIBS)
override CFLAGS += $(gfx.CFLAGS)
