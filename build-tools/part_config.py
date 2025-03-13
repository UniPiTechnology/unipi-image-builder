
import sys
import os
import logging
import yaml
import re
from dataclasses import dataclass, field

ptypes =  {
    'Linux root': ('83', 'B921B045-1DF0-41C3-AF44-4C6F280D3FAE'),
    'Linux variable data': ('83', '4D21B016-B534-45C2-A9FB-5C16E091FD2D'),
    'Linux boot': ('83', '0FC63DAF-8483-4772-8E79-3D69D8477DE4'),
    'BIOS boot':  ('0c', '21686148-6449-6E6F-744E-656564454649'),
    '':           ('83', '0FC63DAF-8483-4772-8E79-3D69D8477DE4'),
}
vol_options = ["noatime", "nodiratime", "discard", "x-systemd.growfs"]
vol_autooptions = ["noatime", "nodiratime", "discard", "x-systemd.growfs", "noauto", "x-systemd.automount"]

re_env_default=re.compile(r'^\$([^(]+)\(([^)]*)\)')

def num_to_int(number):
	if number.startswith('$'):
		m = re_env_default.match(number)
		if m:
			number = os.environ.get(m.group(1), m.group(2))
	if not number:
		return 0
	if number[-1] in ('G','g'):
		return int(number[:-1]) * (1024*1024*1024)
	if number[-1] in ('M','m'):
		return int(number[:-1]) * (1024*1024)
	if number[-1] in ('K','k'):
		return int(number[:-1]) * (1024)
	return int(number)

def num_to_sector(number):
	return num_to_int(number) // 512

def requires(data, keys):
    pass


def Platform(data):
	requires(data, ['mmcdev', 'label', 'start_sector'])
	if data['label'] not in ('dos', 'gpt'):
		raise Exception('Bad label in partition specification')
	return data


@dataclass
class UbootImage:
	sourcefile: str
	offset: str
	appendix: str = ''
	basefile: str = field(init=False)
	ioffset: int = field(init=False)

	def __postinit__(self):
		self.ioffset = num_to_int(self.offset)
		self.basefile = os.path.basename(self.sourcefile)

	def set_basefile(self, basefile):
		self.basefile = basefile


def Uboot(data):

	for image in data["images"]:
		requires(image,["sourcefile","offset"])
		image["ioffset"] = num_to_int(image["offset"])
		sf = image["sourcefile"]
		if not sf.startswith('./'):
			sf = ("." if sf[0] == '/' else "./")+sf
			image["sourcefile"] = sf
		if image.get("basefile","") == "":
			image["basefile"] = os.path.basename(sf)
		
	return data


def Partition(part_num, data):

	data['part_num'] = part_num
	requires(data,["name",])
	ptype = data.get("type",'')
	data["ptype"] = ptypes.get(ptype, ptypes[''])
	if 'size' in data:
		data["size"] = num_to_sector(data['size'])
	else:
		data["size"] = 0
	data['boot_flag'] = data.get('boot_flag','0') == 1
	data['swu_format'] = data.get('swu_format', 'image')
	if data['swu_format'] not in ('image', 'cpio'):
		raise ValueError(f'Value of swu_format can be only "image" or "cpio" not {data["swu_format"]}')
	switchboot = data.get('switchboot','')
	if switchboot not in ('', 'A', 'B'):
			raise ValueError(f'Value of switchboot can be only A or B. not {switchboot}')
	return data

def Volume(data):
	requires(data,['partition', 'mount_point', 'fs_type'])
	if data.get('automount',0) == 1:
		data["options"] = vol_autooptions
	else:
		data["options"] = vol_options
	if 'subvol' in data:
		opt = [f"subvol={data['subvol']}"]
		opt.extend(data["options"])
		data["options"] = opt
	return data

class YamlPlatformLoader:

	def __init__(self, filename):
		self.filename = filename
		self._data = None;

	def get_platform(self):
		if self._data is None:
			self._load()
		return Platform(self._data)

	def get_uboot(self):
		if self._data is None:
			self._load()
		if 'uboot' in self._data:
			uboot = Uboot(self._data['uboot'])
			return uboot
		return None

	def _load(self):
		with open(self.filename, 'r') as stream:
			data = yaml.load(stream, Loader=yaml.SafeLoader)
		if 'platform' not in data:
			logging.error(f"Bad yaml data in {self.filename} - Missing platform:")
			raise Exception()
		self._data = data['platform']


class YamlPartitionLoader:

	def __init__(self, filename):
		self.filename = filename
		self._data_part = None;
		self._data_vol = None;

	def get_partitions(self, start_num=1):
		if self._data_part is None:
			self._load()

		return [Partition(part_num, p)
		        for part_num, p in enumerate(self._data_part, start=start_num)]

	def get_volumes(self, partitions):
		if self._data_vol is None:
			self._load()
		volumes = []
		for vol in self._data_vol:
			volumes.append(Volume(vol))
		return volumes

	def _load(self):
		with open(self.filename, 'r') as stream:
			data = yaml.load(stream, Loader=yaml.SafeLoader)
		if 'partitions' not in data:
			logging.error(f"Bad yaml data in {self.filename} - Missing partitions:")
			raise Exception()
		self._data_part = data['partitions']
		self._data_vol = data.get('volumes',[])



class YamlBootPartitionLoader(YamlPartitionLoader):

	def __init__(self, filename):
		self.filename = filename
		self._data_part = None;
		self._data_vol = None;

	def _load(self):
		with open(self.filename, 'r') as stream:
			data = yaml.load(stream, Loader=yaml.SafeLoader)
		if 'platform' not in data:
			logging.error(f"Bad yaml data in {self.filename} - Missing platform:")
			raise Exception()
		if 'boot_partition' in data['platform']:
			self._data_part=[data['platform']['boot_partition']]
		else:
			self._data_part=[]
		if 'boot_volume' in data['platform']:
			self._data_vol=[data['platform']['boot_volume']]
		else:
			self._data_vol=[]
