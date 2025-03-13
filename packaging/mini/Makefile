
IMAGES += $(BASEIMAGE).mini

IMAGE_MINI_REQ = $(BUILDDIR)/.Makefile.mini \
    $(BUILDDIR)/.Makefile.volumes \
    $(BUILDDIR)/archive/etc/fstab \
    $(BUILDDIR)/archive/etc/default/switchboot


$(BUILDDIR)/.Makefile.mini: packaging/mini/template.Makefile $(BUILDDIR)/.format.yaml
	build_dir="$(BUILDDIR)" tar=$(BASEIMAGE).tar image=$(BASEIMAGE).mini \
	  j2 -e "" $< $(BUILDDIR)/.format.yaml -o $@.tmp
	mv $@.tmp $@

$(BASEIMAGE).mini: $(BASEIMAGE).tar $(IMAGE_MINI_REQ)
	make -f $(BUILDDIR)/.Makefile.mini $@

