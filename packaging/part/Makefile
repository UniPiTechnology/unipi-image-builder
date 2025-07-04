
IMAGES += $(BASEIMAGE).part

IMAGE_PART_REQ = $(BUILDDIR)/.Makefile.part \
    $(BUILDDIR)/.Makefile.volumes \
    $(BUILDDIR)/archive/etc/fstab \
    $(BUILDDIR)/archive/etc/default/switchboot


$(BUILDDIR)/.Makefile.part: packaging/part/template.Makefile $(BUILDDIR)/.format.yaml
	build_dir="$(BUILDDIR)" tar=$(BASEIMAGE).tar image=$(BASEIMAGE).part \
	  j2 -e "" $< $(BUILDDIR)/.format.yaml -o $@.tmp
	mv $@.tmp $@

$(BASEIMAGE).part: $(BASEIMAGE).tar $(IMAGE_PART_REQ)
	make -f $(BUILDDIR)/.Makefile.part $@

