################################################################################
# Makefile for vivado Project
#
# quick usage:
#   $ make                      # Build the entire project (same build-open-nic-shell)
#   $ make build-open-nic-shell # Build Open NIC Shell
#   $ make get-devices          # Show FPGA Device List
#   $ make program-bit          # Program FPGA with bitstream
#   $ make program-mcs          # Program flash memory with MCS file
#   $ make log                  # Show vnp4_framework/open-nic-shell/script/vivado.log
#   $ make ide                  # Open vivado GUI
#   $ make clean-log            # Remove vivado log files
#   $ make clean                # Remove generated files
################################################################################
.PHONY: all build-open-nic-shell get-devices program-bit program-mcs log ide clean-log clean

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

###########################################################################
##### Program Options
###########################################################################
PROGRAM_HW_SERVER   := 127.0.0.1:3121
PROGRAM_DEVICE_NAME := xcu50_u55n_0
PROGRAM_FLASH_PART  := mt25qu01g-spi-x1_x2_x4

###########################################################################
##### Config Defines
###########################################################################
ifeq ($(TAG),"")
    OPEN_NIC_SHELL_BUILD_NAME := $(BOARD)
else
    OPEN_NIC_SHELL_BUILD_NAME := $(BOARD)_$(TAG)
endif

OPEN_NIC_SHELL_PATH       := $(abspath open-nic-shell)
OPEN_NIC_SHELL_BUILD_PATH := $(OPEN_NIC_SHELL_PATH)/build/$(OPEN_NIC_SHELL_BUILD_NAME)
OPEN_NIC_SHELL_IMPLE_PATH := $(OPEN_NIC_SHELL_BUILD_PATH)/open_nic_shell/open_nic_shell.runs/impl_1

BIT_FILE := $(OPEN_NIC_SHELL_IMPLE_PATH)/open_nic_shell.bit
MCS_FILE := $(OPEN_NIC_SHELL_IMPLE_PATH)/open_nic_shell.mcs

###########################################################################
##### Tasks
###########################################################################
all: build-open-nic-shell

build-open-nic-shell:
	cd $(OPEN_NIC_SHELL_PATH)/script && vivado -mode batch -source build.tcl -tclargs \
		-board $(BOARD) \
		-tag $(TAG) \
		-jobs $(JOBS) \
		-synth_ip $(SYNTH_IP) \
		-impl $(IMPL) \
		-post_impl $(POST_IMPL) \
		-build_timestamp $(BUILD_TIMESTAMP) \
		-min_pkt_len $(MIN_PKT_LEN) \
		-max_pkt_len $(MAX_PKT_LEN) \
		-num_phys_func $(NUM_PHYS_FUNC) \
		-num_qdma $(NUM_QDMA) \
		-num_cmac_port $(NUM_CMAC_PORT)

get-devices:
	vivado -mode batch -notrace -source vnp4_framework/scripts/get_devices.tcl -tclargs $(PROGRAM_HW_SERVER)

program-bit: $(BIT_FILE)
	vivado -mode batch -source vnp4_framework/scripts/program_bit.tcl -tclargs $(PROGRAM_HW_SERVER) $(PROGRAM_DEVICE_NAME) $(BIT_FILE)

program-mcs: $(MCS_FILE)
	vivado -mode batch -source vnp4_framework/scripts/program_mcs.tcl -tclargs $(PROGRAM_HW_SERVER) $(PROGRAM_DEVICE_NAME) $(MCS_FILE) $(PROGRAM_FLASH_PART)

log:
	cat $(OPEN_NIC_SHELL_PATH)/script/vivado.log

ide: $(OPEN_NIC_SHELL_BUILD_PATH)/open_nic_shell/open_nic_shell.xpr
	vivado $(OPEN_NIC_SHELL_BUILD_PATH)/open_nic_shell/open_nic_shell.xpr &

clean-log:
	rm -f vivado*.log vivado*.jou vivado*.str

clean: clean-log
	rm -rf $(OPEN_NIC_SHELL_PATH)/build
	rm -f  $(OPEN_NIC_SHELL_PATH)/script/vivado.log
