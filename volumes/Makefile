export PLATFORM_YAML = $(subst ",,$(CONFIG_PLATFORM_YAML))
export PARTITIONS_YAML = $(subst ",,$(CONFIG_PARTITIONS_YAML))

ifneq ($(CONFIG_PARTITIONS_YAML),)

$(BUILDDIR)/.format.yaml: .format $(PLATFORM_YAML) $(PARTITIONS_YAML) .config
	env -i --split-string="$$(grep '^CONFIG_PARTITION' .format)" \
	  build-tools/build_format.py\
	    -p $(PARTITIONS_YAML) \
	    -c $(PLATFORM_YAML) -o $@

endif

ifeq ($(CONFIG_USE_VOLUMES),y)
include volumes/_volumes/Makefile
endif

