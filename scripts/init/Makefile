
pkgs-$(CONFIG_INIT_SYSTEMD) += systemd-sysv,udev
pkgs-$(CONFIG_INIT_SYSV) += sysvinit-core,udev
pkgs-$(CONFIG_INIT_SYSV) += ?not(?virtual)?exact-name(orphan-sysvinit-scripts)
pkgs-$(CONFIG_INIT_RUNIT) += runit-init,passwd
pkgs-$(CONFIG_INIT_BUSYBOX) += busybox
mmopt-$(CONFIG_INIT_BUSYBOX) += --customize-hook='chroot "$$1" ln -s /bin/busybox $1/sbin/init'
