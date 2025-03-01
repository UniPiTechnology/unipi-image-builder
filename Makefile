
BUILDDIR := build
export BUILDDIR
ADDONS := addons

.DEFAULT_GOAL = $(IMAGE)

mmopt-y = --hook-dir=/usr/share/mmdebstrap/hooks/maybe-merged-usr
#mmpre-y = --hook-dir=/usr/share/mmdebstrap/hooks/file-mirror-automount
mmpre-y += --customize-hook='mv -f "$$1/etc/resolv.conf" "$$1/etc/.resolv.conf"'
mmpre-y += --customize-hook='upload resolv.conf /etc/resolv.conf'
mmpost-y = --customize-hook='mv -f "$$1/etc/.resolv.conf" "$$1/etc/resolv.conf"'
skip-n =
components-y=

Makefile.addons Kconfig.addons &: $(ADDONS)
	@( for i in $(wildcard $(ADDONS)/*/Makefile); do echo "include $$i"; done ) > Makefile.addons
	@( for i in $(wildcard $(ADDONS)/*/Kconfig); do echo "source \"$$i\""; done ) > Kconfig.addons


include Makefile.inc
include Makefile.addons

BASEIMAGE := $(BUILDDIR)/$(subst ",,$(CONFIG_DEBIAN_SUITE))-$(subst ",,$(CONFIG_PRODUCT))
IMAGE = $(BASEIMAGE).$(subst ",,$(CONFIG_IMAGE_FORMAT))


ifeq ($(CONFIG_UNIPI_32_BIT),y)
  ARCHITECTURE = armhf
else
ifeq ($(CONFIG_UNIPI_SOURCE),y)
  ARCHITECTURE = arm64
else
  ARCHITECTURE = $(CONFIG_ARCHITECTURE)
endif
endif

export DEBIAN_SUITE=$(subst ",,$(CONFIG_DEBIAN_SUITE))
#export PLATFORM_YAML = $(subst ",,$(CONFIG_PLATFORM_YAML))
#export PARTITIONS_YAML = $(subst ",,$(CONFIG_PARTITIONS_YAML))

-include packaging/Makefile

%_defconfig:
	kconfig-conf --defconfig=configs/$@ Kconfig
	KCONFIG_CONFIG=.format kconfig-conf --defconfig=configs/$@ Kconfig.format

local-upload = $(shell build-tools/setup-local-upload $(local-pkgs-y))
local-pkgs += $(patsubst %,--include=/tmp/%, $(notdir $(local-pkgs-y)))

$(BASEIMAGE).tar: Makefile.inc .config #Makefile
	@mkdir -p "$(BUILDDIR)"
	@bash -c '$(patsubst %,cp % /tmp;, $(local-pkgs-y))'
	@bash -c '$(patsubst %,build-tools/source-prepare.sh %;, $(sources-y))'
	@bash -c 'set -eu; $(patsubst %,%;, $(check-y))'
	HOME=/tmp /usr/bin/mmdebstrap\
	    --variant=$(BUILD_VARIANT)\
	    --format=tar\
	    --architecture=$(ARCHITECTURE)\
	    $(patsubst %,--components=%, $(components-y))\
	    $(patsubst %,--include=%, $(pkgs-y))\
	    $(patsubst %,--setup-hook=$(BUILDDIR)/.%, $(notdir $(sources-y)))\
	    $(local-upload)\
	    $(local-pkgs)\
	    $(mmpre-y)\
	    $(mmopt-y)\
	    $(mmpost-y)\
	    --customize-hook=build-tools/source-post.sh\
	    $(skip-n) \
	    $(CONFIG_DEBIAN_SUITE) $(BASEIMAGE).tmp\
	    $(if $(V),--verbose,)
	@mv $(BASEIMAGE).tmp $(BASEIMAGE).tar


#ifneq ($(CONFIG_PLATFORM_YAML),)
#$(BUILDDIR)/.format.yaml: .format $(PLATFORM_YAML) $(PARTITIONS_YAML) .config
#	build-tools/build_format.py\
#	  -p $(PARTITIONS_YAML) \
#	  -c $(PLATFORM_YAML) -o $@
#endif

#$(BUILDDIR)/Makefile: $(BUILDDIR)/.format.yaml packaging/template.mkarchive
#	build_dir="$(BUILDDIR)" tar=$(BASEIMAGE).tar \
#	  j2 -e "" packaging/template.mkarchive $(BUILDDIR)/.format.yaml > $(BUILDDIR)/Makefile



#$(BASEIMAGE).ext2: $(BASEIMAGE).tar
#	fakeroot build-tools/tar2ext.sh $< $@ ext2


#$(BASEIMAGE).vfat: $(BASEIMAGE).tar
#	@build-tools/tar2fat.sh $< $@


$(BASEIMAGE).ext4: $(BASEIMAGE).tar
	@fakeroot build-tools/tar2ext.sh $< $@

vm: $(BASEIMAGE).ext4

ifeq ($(CONFIG_USE_PACKAGING),y)
$(IMAGE): $(BASEIMAGE).tar $(BUILDDIR)/Makefile
	make -f $(BUILDDIR)/Makefile IMAGE=$(IMAGE) $(IMAGE)
endif

next:
	@bash -c '$(patsubst %,build-tools/source-prepare.sh %;, $(sources-y))'
	HOME=/tmp /usr/bin/mmdebstrap\
	    --skip=check/empty,$(SKIP)\
	    --variant=custom\
	    --format=tar\
	    --architecture=$(ARCHITECTURE)\
	    --setup-hook='mmtarfilter "--path-exclude=/dev/*" < $(BASEIMAGE).tar | tar -C "$$1" -x'\
	    --setup-hook=build-tools/source-pre.sh\
	    $(patsubst %,--setup-hook=$(BUILDDIR)/.%, $(notdir $(sources-y)))\
	    $(ADDON)\
	    --customize-hook=build-tools/source-post.sh\
	    $(CONFIG_DEBIAN_SUITE) $(BASEIMAGE)-1.tar\
	    $(if $(V),--verbose,)


menuconfig: Kconfig.addons
	@kconfig-mconf Kconfig
	@build-tools/hash_passwd.sh .config

format:
	@KCONFIG_CONFIG=.format kconfig-mconf Kconfig.format


savedefconfig: .config
	@kconfig-conf --savedefconfig defconfig Kconfig
	@KCONFIG_CONFIG=.format kconfig-conf --savedefconfig defconfig.format Kconfig.format
	@cat defconfig.format >> defconfig
	@rm defconfig.format

