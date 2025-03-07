
IMAGES += $(BASEIMAGE).zip

IMAGE_SWU_REQ = $(BUILDDIR)/.Makefile.swu \
    $(BUILDDIR)/.Makefile.volumes \
    $(BUILDDIR)/archive/clearfs.sh \
    $(BUILDDIR)/archive/sw-description \
    $(BUILDDIR)/archive/etc/fstab \
    $(BUILDDIR)/archive/etc/default/switchboot

$(BUILDDIR)/.Makefile.swu: packaging/swu/template.mkarchive  $(BUILDDIR)/.format.yaml
	build_dir="$(BUILDDIR)" tar=$(BASEIMAGE).tar image=$(BASEIMAGE).zip \
	  j2 -e "" $< $(BUILDDIR)/.format.yaml -o $@.tmp
	mv $@.tmp $@

$(BUILDDIR)/archive/sw-description: packaging/swu/template.sw-description $(BUILDDIR)/.format.yaml
	@mkdir -p $$(dirname $@)
	j2 -e '' $< $(BUILDDIR)/.format.yaml > $@.tmp
	mv $@.tmp $@

$(BUILDDIR)/archive/clearfs.sh: packaging/swu/template.clearfs $(BUILDDIR)/.format.yaml
	@mkdir -p $$(dirname $@)
	j2 -e '' $^ -o $@.tmp
	mv $@.tmp $@


$(BASEIMAGE).zip: $(BASEIMAGE).tar $(IMAGE_SWU_REQ)
	make -f $(BUILDDIR)/.Makefile.swu IMAGE=$@ $@

