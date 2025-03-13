

mmopt-$(CONFIG_NOPASSWD) += --customize-hook='passwd  --root "$$1" --delete root'


ifeq ($(CONFIG_MAKE_VM),y)
CREATE_OPT += --customize-hook="copy-in initrd.cpio /"\
 --customize-hook=./initrd-update\
 --customize-hook="download initrd.img bin/initrd.img"\
 --customize-hook="download vmlinuz bin/vmlinuz"\
 --customize-hook='rm -f "$$1/vmlinuz" "$$1/initrd.img"'
endif

include addons/vm/autologin/Makefile
