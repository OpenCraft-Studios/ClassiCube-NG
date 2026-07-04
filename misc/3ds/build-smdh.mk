
APP_ICON	= misc/3ds/icon.png
APP_TITLE 	= ClassiCube
APP_DESCRIPTION = Simple block building sandbox
APP_AUTHOR 	= ClassiCube team
$(build).smdh: $(APP_ICON)
	$(SMDHTOOL) --create "$(APP_TITLE)" "$(APP_DESCRIPTION)" "$(APP_AUTHOR)" $(APP_ICON) $@