# Unipi Image Builder

Simple, configurable tool to build Debian images. The tool is basically frontend to [mmdebstrap - multi-mirror Debian chroot creator](https://gitlab.mister-muffin.de/josch/mmdebstrap)

Frontend is based on Kconfig language and Makefiles and is used it like building Linux kernel

``` 
    make patron-nodered_defconfig
    make menuconfig
    make format
    make
```

## Requirements
- mmdebstrap
- apt
- make
- fakeroot
- kconfig-frontends-nox
- python3-jinja2
- j2
- pigz, zip
- fusefat



## Makefile options

- mmopt-y          - list of hooks to run
- mmpre-y          - list of hooks to run before mmopt-y hooks
- mmpost-y         - list of hooks to run after mmopt-y hooks
- sources-y        - list of directories with apt source definition
- pkgs-y           - list of packages to install
- local-pkgs-y     - list of local file packages to install
- local-uploads-y
- components-y     - list of apt components to install (main, test ...)

## Customizing

To customize the image build, call make menuconfig where you can choose from predefined options.
The output format is selected by calling make format. Make always creates tar file that contains all installed files.
The desired images are than generated from it. All temporary files and images are placed into build directory.

If you are not satisfied with options offered, you can create own addon to extend the installation options.

# Create your addon

Create own directory in directory addons
 '' mkdir addons/myapp ''

Create in that directory Kconfig and Makefile


