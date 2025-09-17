
PREREQ_FILES := $(BUILDDIR)/.format.yaml $(BUILDDIR)/.Makefile.mini

include $(BUILDDIR)/.Makefile.volumes

$(BUILDDIR)/archive/cpartm.sh: packaging/mini/template.cpartm $(PREREQ_FILES) $(VOLUME_FILES)
	raw_files="$(RAW_FILES)" \
	tar="{{tar}}" \
	  j2 -e '' $< $(BUILDDIR)/.format.yaml > $@.tmp
	mv $@.tmp $@
	chmod +x $@


{% if platform.boot_partition.name | default(0) %}
{%- set ns = namespace() -%}
{%- set ns.output_file = build_dir+"/archive/"+platform.boot_partition.name+"."+platform.boot_volume.fs_type -%}
MINI_ARCHIVE_FILES = {{ns.output_file}}
{% endif %}


{{image}}: $(MINI_ARCHIVE_FILES) $(BUILDDIR)/archive/cpartm.sh
	rm -rf {{build_dir}}/boot
	$(BUILDDIR)/archive/cpartm.sh $@.tmp
	mv $@.tmp $@
