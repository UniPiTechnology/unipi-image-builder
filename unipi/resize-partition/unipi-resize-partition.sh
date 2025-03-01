#!/bin/bash

# fail whole script on any command
set -e

DEVICE=/dev/mmcblk0

grow_last_partition()
{
  PART=$(sfdisk -l "$DEVICE" | tail -1 | cut -f 1 -d " ")
  pn=$(sed -n 's/^.*\([1234]\)$/\1/p' <<< "$PART")    #'# bad syntax highlight

  # expand last partition to max value (size=+)
  sfdisk --no-reread --wipe never --no-tell-kernel -N "$pn" "$DEVICE" <<< "$pn:size=+"
  # update the list of partitions in the kernel
  partx -u "$DEVICE"
  # resize the BTRFS partition to its maximum size
  # no need to reboot, all should be done online
  fstype="$(lsblk -n -o FSTYPE "$PART")"
  if [ "$fstype" = "ext4" ]; then
    resize2fs "$PART"
  elif [ "$fstype" = "btrfs" ]; then
    btrfs filesystem resize max /
  fi
}

create_partition()
{
    pn="$1"
    size="$2"
    if sfdisk -l "$DEVICE" | grep -qv "^${DEVICE}p${pn}"; then
        size=${size:+size=$size}
        sfdisk --no-reread --no-tell-kernel -W always --append "$DEVICE" <<< "$pn:type=83,$size"
        partx -a "${DEVICE}p${pn}" "$DEVICE"
    fi
}

disable_service()
{
  # disable the systemd service
  if systemctl -q is-enabled unipi-resize-partition; then
    systemctl disable unipi-resize-partition
  fi
}

case "$1" in
  create_partition)
      create_partition "$2" "$3"
      disable_service
      ;;
  grow_last_partition)
      grow_last_partition
      disable_service
      ;;
  *)
      echo
      echo "Usage:  $0 [grow_last_partition | create_partition]"
      echo
      echo "  to extend last partition to the end of storage"
      echo "  or to add new partition over the free space of storage"
      echo
      ;;
esac

