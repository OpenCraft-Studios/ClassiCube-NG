
$(MAKEROM):
	wget https://github.com/3DSGuy/Project_CTR/releases/download/makerom-v0.18.3/makerom-v0.18.3-ubuntu_x86_64.zip -O $(build)/makerom.zip
	@unzip $(build)/makerom.zip -d $(build)
	@chmod +x $@
