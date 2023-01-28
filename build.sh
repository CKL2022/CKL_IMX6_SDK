#!/bin/bash

export TOP_DIR=`pwd`
#echo "TOP_DIR=$TOP_DIR"
BOARD_CONFIG=$TOP_DIR/board/.BoardConfig.mk

if [ ! -e out ];then
cd $TOP_DIR
mkdir ./out
mkdir -p ./tools/Alpha-mksdcard/image
fi



 function choose_target_board()
 {
     echo
     echo "You're building on Linux"
     echo "Lunch menu...pick a combo:"
     echo ""

     echo "0. default BoardConfig_JSOM-N8MC_2G.mk"
     echo ${BOARD_ARRAY[@]} | xargs -n 1 | sed "=" | sed "N;s/\n/. /"

     local INDEX
     read -p "Which would you like? [0]: " INDEX
     INDEX=$((${INDEX:-0} - 1))

     if echo $INDEX | grep -vq [^0-9]; then
         TARGET_BOARD="${BOARD_ARRAY[$INDEX]}"
     else
         echo "Lunching for Default BoardConfig.mk boards..."
         TARGET_BOARD=BoardConfig_ckl_512M.mk
     fi
	 cp ${TOP_DIR}/board/$TARGET_BOARD  $BOARD_CONFIG
	 echo "Final $TARGET_BOARD"
 }

function build_select_board()
 {
     BOARD_ARRAY=( $(cd ${TOP_DIR}/board/; ls BoardConfig*.mk | sort) )

     BOARD_ARRAY_LEN=${#BOARD_ARRAY[@]}
     if [ $BOARD_ARRAY_LEN -eq 0 ]; then
         echo "No available Board Config"
         return
     fi
	choose_target_board
     
 }



#if [ ! -e "$BOARD_CONFIG" -a "$1" != "lunch" ]; then
#    build_select_board
#fi


function usage()
{
	echo "#####################"
	echo "Usage:   ./build.sh [OPTIONS]"
	echo "lunch          -list current SDK boards and switch to specified board config"
	echo "uboot          -build uboot"
	echo "kernel         -build kernel"
	echo "rootfs         -build busybox rootfs"
	echo "all            -build all"
	echo "clean          -build clean"
	echo "firmware       -build firmware"
	echo "Default option is 'help'."
	echo "#####################"

}

function build_cleanall()
{
	echo "run fun build_cleanall"

	echo "CLEAN lunch"
	rm $BOARD_CONFIG
	
	cd $UBOOT_PATH
	echo "CLEAN=`pwd`"
	make clean

	cd $ROOTFS_PATH 
	echo "CLEAN=`pwd`/*.tar.bz2"
	rm -f *.tar.bz2

	cd $KERNEL_PATH
	echo "CLEAN=`pwd`"
	make clean

	cd $OUT_PATH
	echo "CLEAN=`pwd`"	
	rm -rf $OUT_PATH/*

}

function build_all()
{
	echo "run fun build_all"
#	build_cleanall
	build_uboot
	build_kernel
	build_rootfs
	
}

function build_uboot()
{
	 echo "run fun build_uboot"
	 cd $UBOOT_PATH
#	 echo "NOW_PATH=`pwd`"
	 make $UBOOT_DEFCONFIG
	 make -j4
	echo "make uboot done"
	echo "uboot.imx done"

}

function build_kernel()
{
	 echo "run fun build_kernel"
	 cd  $KERNEL_PATH
	 echo "NOW_PATH=`pwd`"
	 make $KERNEL_DEFCONFIG
	 make -j12
	 echo "make kernel done"

	 echo "install modules..."
	 make modules
	 rm -rf $OVERLAY_PATH/lib/modules/*
	 make -j4 modules LDFLAGS=
	 make ARCH=arm modules_install INSTALL_MOD_PATH=$MODULES_PATH > /dev/null
	 echo "make modules done"
	 sync
}


function build_rootfs()
{
	
	echo "run fun build_rootfs"
	cd $ROOTFS_PATH
	if [ -e overlay.tar.bz2 ];then
		rm -f overlay.tar.bz2
	fi
	if [ -e rootfs.tar.bz2 ];then
		rm -f rootfs.tar.bz2
	fi

	# tar standerd rootfs
	cd $BUSYBOX_PATH
	echo "making standerd rootfs..."
	sudo tar cjf ../rootfs.tar.bz2 ./*
	sync
	echo "making standerd rootfs done"


	#打包差分包
	cd $OVERLAY_PATH
	tar cjf $ROOTFS_PATH/overlay.tar.bz2 ./*
	sync
	echo "build_diffrootfs done"

}

function build_firmware()
{
	echo "run fun build_firmware"
	cd $OUT_PATH
	rm -rf $OUT_PATH/*
	cp -r $LINUX_BURN_TOOLS_PATH CKL_$Version_No"_Image_"`date +%F`
	#mkdir cqs-`date +%F`
	cd CKL_$Version_No"_Image_"`date +%F`/image/
	cp $KERNEL_DTB_PATH ./
#	rm ./*dts*
	cp $UBOOT_IMX_PATH ./
	cp $KERNEL_IMG_PATH ./
	cp $ROOTFS_PATH/overlay.tar.bz2 ./	
    cp $ROOTFS_PATH/rootfs.tar.bz2 ./


	files=$(ls *.dtb 2> /dev/null | wc -l)
#	if [ -e overlay.tar ] && [ -e rootfs.tar ] && [ -e flash.bin ] && [ -e Image ] && [ "$files" != "0" ];then
	if [ -e overlay.tar.bz2 ] && [ -e rootfs.tar.bz2 ]  && [ -e zImage ] && [ "$files" != "0" ];then
		echo "烧录包齐全,正在制作烧录包..."
		sync
		cd $OUT_PATH
		tar cjf CKL_$Version_No"_Image_"`date +%F`.tar.bz2 ./CKL_$Version_No"_Image_"`date +%F`
		sync
		echo "firmware make done"
	else
		echo "烧录包不完整"
	fi	

}


#=========================
# build targets
#=========================


if echo $@|grep -wqE "help|-h"; then
			usage
	exit 0
fi

if [ ! -e "$BOARD_CONFIG" -a "$1" != "lunch" ]; then
		echo "Please run $ ./build.sh lunch  First!"
		exit 0
fi


OPTIONS="${@:-help}"

for option in ${OPTIONS}; do
	echo "processing option: $option"
	source $BOARD_CONFIG
	source $Compiler_DIR

#	export

	case $option in
			lunch) build_select_board ;;
			clean) build_cleanall ;;
			all)   build_all ;;
			uboot) build_uboot ;;
			kernel) build_kernel ;;
			rootfs|busybox) build_rootfs ;;
			firmware) build_firmware ;;
			*)  usage ;;
	esac
done


