
VOLUMES_REQ = $(BUILDDIR)/.format.yaml \
    volumes/_volumes/template.mkimage \
    volumes/_volumes/template.mkcpio


$(BUILDDIR)/.Makefile.volumes: volumes/_volumes/template.Makefile $(VOLUMES_REQ)
	build_dir="$(BUILDDIR)" tar=$(BASEIMAGE).tar \
	  j2 -e "" $< $(BUILDDIR)/.format.yaml -o $@.tmp
	mv $@.tmp $@

$(BUILDDIR)/archive/etc/fstab: volumes/_volumes/template.fstab $(BUILDDIR)/.format.yaml
	@mkdir -p $$(dirname $@)
	j2 -e '' $^ -o $@.tmp
	mv $@.tmp $@

$(BUILDDIR)/archive/etc/default/switchboot: volumes/_volumes/template.switchboot $(BUILDDIR)/.format.yaml
	@mkdir -p $$(dirname $@)
	j2 -e '' $^ -o $@.tmp
	mv $@.tmp $@

#$(BUILDDIR)/archive/imagelist: volumes/_volumes/template.imagelist $(BUILDDIR)/.format.yaml
#	@mkdir -p $$(dirname $@)
#	j2 -e '' $^ -o $@.tmp
#	mv $@.tmp $@

