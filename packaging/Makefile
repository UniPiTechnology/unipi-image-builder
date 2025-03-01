
export PLATFORM_YAML = $(subst ",,$(CONFIG_PLATFORM_YAML))
export PARTITIONS_YAML = $(subst ",,$(CONFIG_PARTITIONS_YAML))

ifneq ($(CONFIG_PLATFORM_YAML),)
$(BUILDDIR)/.format.yaml: .format $(PLATFORM_YAML) $(PARTITIONS_YAML) .config
	build-tools/build_format.py\
	  -p $(PARTITIONS_YAML) \
	  -c $(PLATFORM_YAML) -o $@
endif

ifeq ($(CONFIG_IMAGE_FORMAT_SWU), y)
$(IMAGE): $(BUILDDIR)/Makefile

$(BUILDDIR)/Makefile: $(BUILDDIR)/.format.yaml packaging/template.mkarchive packaging/template.mkimage packaging/template.mkcpio
	build_dir="$(BUILDDIR)" tar=$(BASEIMAGE).tar \
	  j2 -e "" packaging/template.mkarchive $(BUILDDIR)/.format.yaml > $(BUILDDIR)/Makefile.tmp
	mv $(BUILDDIR)/Makefile.tmp $@
endif

ifeq ($(CONFIG_IMAGE_FORMAT_RAW),y)
$(IMAGE): $(BUILDDIR)/Makefile

$(BUILDDIR)/Makefile: $(BUILDDIR)/.format.yaml packaging/template.mkraw packaging/template.mkimage
	build_dir="$(BUILDDIR)" tar=$(BASEIMAGE).tar \
	  j2 -e "" packaging/template.mkraw $(BUILDDIR)/.format.yaml > $(BUILDDIR)/Makefile.tmp
	mv $(BUILDDIR)/Makefile.tmp $@
endif

ifeq ($(CONFIG_IMAGE_FORMAT_RAWMINI),y)
$(IMAGE): $(BUILDDIR)/Makefile

$(BUILDDIR)/Makefile: $(BUILDDIR)/.format.yaml packaging/template.mkrawmini packaging/template.mkimage
	build_dir="$(BUILDDIR)" tar=$(BASEIMAGE).tar \
	  j2 -e "" packaging/template.mkraw $(BUILDDIR)/.format.yaml > $(BUILDDIR)/Makefile.tmp
	mv $(BUILDDIR)/Makefile.tmp $@
endif

