#!/bin/bash

#版本号
export Version_No=EA001

#交叉编译器路径
export Compiler_DIR=/opt/fsl-imx-x11/4.1.15-2.1.0/environment-setup-cortexa7hf-neon-poky-linux-gnueabi

# Uboot defconfig
export UBOOT_DEFCONFIG=alpha_ddr512_emmc_defconfig
# Uboot path
export UBOOT_PATH=$TOP_DIR/source/imx6_uboot

# make_uboot.imx path
export UBOOT_IMX_PATH=$UBOOT_PATH/u-boot.imx

# Kernel defconfig
export KERNEL_DEFCONFIG=alpha_imx_v7_defconfig
# Kernel path
export KERNEL_PATH=$TOP_DIR/source/imx6_kernel

# kernel image path
export KERNEL_IMG_PATH=$KERNEL_PATH/arch/arm/boot/zImage

# kernel dtb path
#export KERNEL_DTB_PATH=$KERNEL_PATH/arch/arm/boot/dts/alpha-emmc-1024x600.dtb
export KERNEL_DTB_PATH=$KERNEL_PATH/arch/arm/boot/dts/alpha*.dtb


#modules path
export MODULES_PATH=$TOP_DIR/source/rootfs/overlay

# rootfs path
export ROOTFS_PATH=$TOP_DIR/source/rootfs

# overlay path
export OVERLAY_PATH=$TOP_DIR/source/rootfs/overlay

# busybox path
export BUSYBOX_PATH=$TOP_DIR/source/rootfs/busybox

# out path
export OUT_PATH=$TOP_DIR/out

# Linux-Burn-Tools path
export LINUX_BURN_TOOLS_PATH=$TOP_DIR/tools/Alpha-mksdcard
