


BUILDDIR := build
export BUILDDIR
ADDONS := addons


mmopt-y = --hook-dir=/usr/share/mmdebstrap/hooks/maybe-merged-usr
mmpre-y = --customize-hook='mv -f "$$1/etc/resolv.conf" "$$1/etc/.resolv.conf"'
mmpre-y += --customize-hook='upload resolv.conf /etc/resolv.conf'
mmpost-y = --customize-hook='mv -f "$$1/etc/.resolv.conf" "$$1/etc/resolv.conf"'
skip-n =
components-y=

Makefile.addons Kconfig.addons &: $(ADDONS)
	( for i in $(wildcard $(ADDONS)/*/Makefile); do echo "include $$i"; done ) > Makefile.addons
	( for i in $(wildcard $(ADDONS)/*/Kconfig); do echo "source \"$$i\""; done ) > Kconfig.addons


include Makefile.inc
include Makefile.addons

BASEIMAGE_N = $(BUILDDIR)/$(subst ",,$(CONFIG_DEBIAN_SUITE))-$(subst ",,$(CONFIG_PRODUCT))
#BASEIMAGE = $(BASEIMAGE_N).$(subst ",,$(IMAGE_FORMAT))
BASEIMAGE = $(BASEIMAGE_N).tar
ifeq ($(CONFIG_IMAGE_FORMAT_EXT2),y)
  IMAGE := $(BASEIMAGE_N).ext2
endif
ifeq ($(CONFIG_IMAGE_FORMAT_EXT4),y)
  IMAGE := $(BASEIMAGE_N).ext4
endif
ifeq ($(CONFIG_IMAGE_FORMAT_SWU),y)
  IMAGE := $(BASEIMAGE_N).swu
endif


.DEFAULT_GOAL := $(IMAGE)

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
base-sources = $(shell $(patsubst %,basename %;, $(sources-y)))
setup-sources = $(patsubst %,--setup-hook=$(BUILDDIR)/.%, $(base-sources))

$(BASEIMAGE): Makefile Makefile.inc .config
	@mkdir -p "$(BUILDDIR)"
	@bash -c '$(patsubst %,build-tools/source-prepare.sh %;, $(sources-y))'
	@bash -c 'set -eu; $(patsubst %,%;, $(check-y))'
	HOME=/tmp /usr/bin/mmdebstrap\
	    --variant=$(BUILD_VARIANT)\
	    --format=$(IMAGE_FORMAT)\
	    --architecture=$(ARCHITECTURE)\
	    $(patsubst %,--components=%, $(components-y))\
	    $(patsubst %,--include=%, $(pkgs-y))\
	    $(setup-sources)\
	    $(mmpre-y)\
	    $(mmopt-y)\
	    $(mmpost-y)\
	    --customize-hook=build-tools/source-post.sh\
	    $(skip-n) \
	    $(CONFIG_DEBIAN_SUITE) $(BASEIMAGE).tmp\
	    $(if $(V),--verbose,)
	@mv $(BASEIMAGE).tmp $(BASEIMAGE)
	@rm -f $(IMAGE)


ifeq ($(CONFIG_IMAGE_FORMAT_EXT2),y)

$(IMAGE): $(BASEIMAGE)
	fakeroot build-tools/tar2ext.sh $< $@
endif

ifeq ($(CONFIG_IMAGE_FORMAT_EXT4),y)

$(BASEIMAGE_N).vfat: $(BASEIMAGE)
	@build-tools/tar2fat.sh $< $(BASEIMAGE_N).vfat


$(IMAGE): $(BASEIMAGE) $(BASEIMAGE_N).vfat
	@fakeroot build-tools/tar2ext.sh $< $@

swu: $(IMAGE)
	build-tools/swu.sh $(IMAGE) $(IMAGE).swu
endif

next:
	@bash -c '$(patsubst %,build-tools/source-prepare.sh %;, $(sources-y))'
	HOME=/tmp /usr/bin/mmdebstrap\
	    --skip=check/empty,$(SKIP)\
	    --variant=custom\
	    --format=$(IMAGE_FORMAT)\
	    --architecture=$(ARCHITECTURE)\
	    --setup-hook='mmtarfilter "--path-exclude=/dev/*" < $(BASEIMAGE) | tar -C "$$1" -x'\
	    --setup-hook=build-tools/source-pre.sh\
	    $(setup-sources)\
	    $(ADDON)\
	    --customize-hook=build-tools/source-post.sh\
	    $(CONFIG_DEBIAN_SUITE) $(BASEIMAGE_N)-1.tar\
	    $(if $(V),--verbose,)


menuconfig: Kconfig.addons
	@kconfig-mconf Kconfig

%_defconfig:
	kconfig-conf --defconfig=configs/$@ Kconfig

savedefconfig: .config
	kconfig-conf --savedefconfig defconfig Kconfig
