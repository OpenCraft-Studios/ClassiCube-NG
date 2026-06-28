$(ELF): $(OBJS) | $(BUILDDIR)
	$(LD) -o $@ $^ $(LDFLAGS)

$(BUILDDIR)/%.o : %.s | $(BUILD_DIR)
	$(CC) $(ASFLAGS) -MMD -MP -c $< -o $@

$(BUILDDIR)/%.o : %.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

$(BUILDDIR):
	@mkdir -p $(BUILDDIR)

clean:
	@rm $(ELF) $(MAP) $(OBJS)
	@rm -rf $(BUILDDIR)

.PHONY: clean