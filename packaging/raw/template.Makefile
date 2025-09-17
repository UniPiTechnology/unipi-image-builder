
PREREQ_FILES := {{build_dir}}/.format.yaml {{build_dir}}/.Makefile.raw 
ETC_FILES += {{build_dir}}/archive/etc/fstab {{build_dir}}/archive/etc/default/switchboot

include {{build_dir}}/.Makefile.volumes

{{build_dir}}/archive/cpart.sh: packaging/raw/template.cpart $(PREREQ_FILES) $(VOLUME_FILES) {{build_dir}}/.Makefile.volumes
	raw_files="$(RAW_FILES)" \
	tar="{{tar}}" \
	  j2 -e '' $< {{build_dir}}/.format.yaml > $@.tmp
	mv $@.tmp $@
	chmod +x $@

{{image}}: $(ARCHIVE_FILES) {{build_dir}}/archive/cpart.sh
	{{build_dir}}/archive/cpart.sh $@.tmp
	mv $@.tmp $@
	#rm -rf {{build_dir}}/archive
