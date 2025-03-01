#!/usr/bin/python3

import argparse, sys
import os, shutil, stat
import logging
import subprocess
import jinja2

from part_config import YamlPartitionLoader, YamlBootPartitionLoader, YamlPlatformLoader

def main():
	a = argparse.ArgumentParser(prog='make_fstab.py')
	a.add_argument('-c','--platform_desc', metavar="file", help='Platform specification yaml', type=str)
	a.add_argument('-p','--part', metavar="file", help='Partitions specification yaml', type=str)
	a.add_argument('-o','--output', metavar="file", help='Output file')
	args = a.parse_args()

	platform_file = args.platform_desc if args.platform_desc else "packaging/unipi_zulu.yaml"
	partitions_file = args.part if args.part else "packaging/part-std.yaml"
	output_file = args.output if args.output else ".format.yaml"
	output_dir = os.path.dirname(output_file) or "."

	l = YamlPlatformLoader(platform_file)
	platform = l.get_platform()
	uboot = l.get_uboot()

	# Platform specification may require a mandatory boot partition.
	l = YamlBootPartitionLoader(platform_file)
	partitions = l.get_partitions()
	volumes = l.get_volumes(partitions)
	boot_part_count = len(partitions)

	l = YamlPartitionLoader(partitions_file)
	partitions.extend(l.get_partitions(start_num=boot_part_count+1))
	volumes.extend(l.get_volumes(partitions))

	volumes.sort(key=lambda v: v['mount_point'])

	for vol in volumes:
		excludes = [ f".{v['mount_point']}/*" for v in volumes
	                     if v != vol and v['mount_point'].startswith(vol['mount_point'])]
		vol['excludes'] = excludes

	images = [vol for vol in volumes if vol['partition']['swu_format'] == "image" ]
	cpios  = [vol for vol in volumes if vol['partition']['swu_format'] != "image" ]

	import yaml
	d = {'platform':platform, 'part_table': partitions, 'volumes': volumes, 'uboot':uboot, 'cpios': cpios, 'images': images}
	with open(output_file,'w') as stream:
			yaml.dump(d, stream)


if __name__ == "__main__":

	main()
