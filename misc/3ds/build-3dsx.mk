
$(TARGET_BASE).3dsx: $(target) $(build).smdh
	$(DSXTOOL) $< $@ --smdh=$(build).smdh