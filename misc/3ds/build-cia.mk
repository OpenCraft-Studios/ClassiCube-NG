CIA_BANNER_BIN := misc/3ds/banner.bin
CIA_ICON_BIN   := misc/3ds/icon.bin
CIA_SPEC_RSF   := misc/3ds/spec.rsf
$(TARGET_BASE).cia : $(target) $(TARGET_BASE).3dsx $(MAKEROM) | $(build)
	$(MAKEROM) -f cia -o $@ -elf $< \
		-rsf $(CIA_SPEC_RSF) \
		-icon $(CIA_ICON_BIN) \
		-banner $(CIA_BANNER_BIN) \
		-exefslogo -target t