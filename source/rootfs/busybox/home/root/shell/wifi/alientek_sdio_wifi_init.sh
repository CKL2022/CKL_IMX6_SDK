#!/bin/sh
#安装驱动模块
if !(lsmod | grep "8189fs" >/dev/null 2>&1); then
    insmod /home/root/driver/rtl8189/8189fs.ko
fi
sleep 1
#解锁射频
rfkill unblock all
sleep 2
#杀死后台运行的程序
if (ps -aux | grep "wpa_supplicant"  | grep -v grep >/dev/null 2>&1); then
    killall wpa_supplicant
fi
