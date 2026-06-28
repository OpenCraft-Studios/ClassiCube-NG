$(ELF): $(OBJS) | $(BUILDDIR)
	$(LD) -o $@ $^ $(LDFLAGS)

$(BUILDDIR)/%.o : %.s | $(BUILDDIR)
	@printf "Assembling %s" "$(@F)"
	@$(CC) $(ASFLAGS) -MMD -MP -c $< -o $@

$(BUILDDIR)/%.o : %.c | $(BUILDDIR)
	@printf "Compiling  %s" "$(@F)"
	@$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

$(BUILDDIR):
	@mkdir -p $(BUILDDIR)

clean:
	@rm $(ELF) $(MAP) $(OBJS)
	@rm -rf $(BUILDDIR)

.PHONY: clean
