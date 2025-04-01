# open-nic-skelton
This is a repository using the default user plugin of open-nic-shell.

## Usage

### Preparation

#### Install Vitis/Vivado 2024.2.2

- [AMD Xilinx Download Site](https://japan.xilinx.com/support/download/index.html/content/xilinx/ja/downloadNav/vivado-design-tools.html)

#### Obtain Xilinx IP Licenses

- CMAC license
    - [cmac-license (Github: OpenNIC Shell)](https://github.com/Xilinx/open-nic-shell?tab=readme-ov-file#cmac-license)
    - [UltraScale+ 100G Ethernet Subsystem (Xilinx)](https://japan.xilinx.com/products/intellectual-property/cmac_usplus.html)

#### Clone Project

```shell
$ git clone https://github.com/iHalt10/open-nic-skelton
$ cd open-nic-skelton
$ git submodule update --init --recursive
```

### Build OpenNIC Shell

```shell
$ make
```

Before executing the above, please change the 'BOARD' definition in the Makefile to the name of the FPGA Device you are using.
The following are supported:
- au45n
- au50
- au55n
- au55c
- au200
- au250
- au280
- soc250
- vck5k

#### Build Options
The following Makefile options are available for building:

```makefile
###########################################################################
##### OpenNIC Build Script Options (open-nic-shell/script/build.tcl)
###########################################################################
## Build options
BOARD           := au50
TAG             := onic
JOBS            := $(shell nproc)
SYNTH_IP        := 1
IMPL            := 1
POST_IMPL       := 1

## Design parameters
BUILD_TIMESTAMP := $(shell date +%y%m%d%H%M)
MIN_PKT_LEN     := 64
MAX_PKT_LEN     := 1514
NUM_PHYS_FUNC   := 1
NUM_QDMA        := 1
NUM_CMAC_PORT   := 1
```

For detailed explanation of these options, refer to [Build Script Options (Github: OpenNIC Shell)](https://github.com/Xilinx/open-nic-shell?tab=readme-ov-file#build-script-options).

### Program MCS/BIT Files
Program the program file (bit or mcs) to the FPGA device.
First, set the IP address that can connect to the "hw_server" process in the "PROGRAM_HW_SERVER" in the Makefile.
For local development environments, you can leave the local IP address as is.
Next, get the "DEVICE_NAME" of the recognized FPGA Board.
You can get it with the following command:

```shell
$ make get-devices
```

Set the obtained "DEVICE_NAME" in the "PROGRAM_DEVICE_NAME" in the Makefile.
Next, set the "FLASH_PART" name of the FPGA device you are using in the "PROGRAM_FLASH_PART" in the Makefile.

- FLASH_PART
    - au45n: mt25qu01g-spi-x1_x2_x4
    - au50:  mt25qu01g-spi-x1_x2_x4
    - au55c: mt25qu01g-spi-x1_x2_x4
    - au200: mt25qu01g-spi-x1_x2_x4
    - au250: mt25qu01g-spi-x1_x2_x4
    - au280: mt25qu01g-spi-x1_x2_x4

The names of the flash parts above are listed in the device's User Guide.
For au55n, soc250, and vck5k devices, please refer to the respective device documentation if you need detailed information about the corresponding flash parts.

Finally, write the program file to the FPGA device with the following command:
```shell
$ make program-bit # and warm reboot
# or
$ make program-mcs # and cold reboot
```

#### Program Options
The following Makefile options are available for programming:

```makefile
###########################################################################
##### Program Options
###########################################################################
PROGRAM_HW_SERVER   := 127.0.0.1:3121
PROGRAM_DEVICE_NAME := xcu50_u55n_0
PROGRAM_FLASH_PART  := mt25qu01g-spi-x1_x2_x4
```

### Build OpenNIC Driver

```shell
$ cd open-nic-driver
$ make
$ sudo insmod onic.ko
```

For detailed information, refer to [OpenNIC Driver Documentation (Github: OpenNIC Driver)](https://github.com/Xilinx/open-nic-driver).

# References

- Alveo User Guide
    - [au45n User Guide](https://docs.amd.com/r/en-US/ug1636-alveo-u45n)
    - [au50  User Guide](https://docs.amd.com/r/en-US/ug1371-u50-reconfig-accel)
    - [au55c User Guide](https://docs.amd.com/r/en-US/ug1469-alveo-u55c)
    - [au200 User Guide](https://docs.amd.com/r/en-US/ug1289-u200-u250-reconfig-accel)
    - [au250 User Guide](https://docs.amd.com/r/en-US/ug1289-u200-u250-reconfig-accel)
    - [au280 User Guide](https://docs.amd.com/r/en-US/ug1314-alveo-u280-reconfig-accel)
