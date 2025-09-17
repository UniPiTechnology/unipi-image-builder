vm: $(IMAGE)

$(IMAGE): $(BUILDDIR)/Makefile.vm {{tar}}
	@fakeroot build-tools/tar2ext.sh "{{tar}}" $@
