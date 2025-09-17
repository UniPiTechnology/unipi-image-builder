
pkgs-$(CONFIG_SYSTOOLS) += procps,sudo,less,fdisk,cron,lsb-release,cpio,systemd-timesyncd,libpam-systemd
pkgs-$(CONFIG_SYSTOOLS) += tzdata,btrfs-progs,e2fsprogs,dosfstools
pkgs-$(CONFIG_SYSTOOLS) += $(if $(findstring y,$(CONFIG_DEBIAN_SUITE_TESTING)),login polkitd)
pkgs-$(CONFIG_SYSTOOLS) += $(if $(findstring y,$(CONFIG_DEBIAN_SUITE_STABLE)),polkitd)

pkgs-$(CONFIG_NETTOOLS) += iproute2,openssh-client,openssh-server,nftables,netbase,bridge-utils,net-tools,iputils-ping

pkgs-$(CONFIG_TOOLS) += python3-minimal,xxd,gpiod,busybox,usbutils,wget,curl,evtest,logrotate,gawk,dialog

pkgs-$(CONFIG_EDITOR_VIM) += vim
pkgs-$(CONFIG_EDITOR_NANO) += nano
pkgs-$(CONFIG_EDITOR_MC) += libcom-err2,mc
