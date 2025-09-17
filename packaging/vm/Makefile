
IMAGES += $(BASEIMAGE).vm

$(BASEIMAGE).vm: $(BASEIMAGE).tar
	@fakeroot build-tools/tar2ext.sh "$(BASEIMAGE).tar" $@

vm: $(BASEIMAGE).vm
