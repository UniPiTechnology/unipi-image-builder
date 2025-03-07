
#ifeq ($(CONFIG_IMAGE_FORMAT_RAW),y)
IMAGES += $(BASEIMAGE).raw

IMAGE_RAW_REQ = $(BUILDDIR)/.Makefile.raw \
    $(BUILDDIR)/.Makefile.volumes \
    $(BUILDDIR)/archive/etc/fstab \
    $(BUILDDIR)/archive/etc/default/switchboot


$(BUILDDIR)/.Makefile.raw: packaging/raw/template.Makefile $(BUILDDIR)/.format.yaml
	build_dir="$(BUILDDIR)" tar=$(BASEIMAGE).tar image=$(BASEIMAGE).raw \
	  j2 -e "" $< $(BUILDDIR)/.format.yaml -o $@.tmp
	mv $@.tmp $@

$(BASEIMAGE).raw: $(BASEIMAGE).tar $(IMAGE_RAW_REQ)
	make -f $(BUILDDIR)/.Makefile.raw $@

