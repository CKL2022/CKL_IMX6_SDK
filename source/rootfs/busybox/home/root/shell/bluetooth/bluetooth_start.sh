#!/bin/sh 
#由于出厂系统已经使用 rfkill 管射频之类的设备，在没有用到这类设备时是关闭它的射频的，
#达到省电的目的，现在我们解锁射频
rfkill unblock all 
sleep 1 
#开启蓝牙网络（使能 USB 蓝牙设备）
hciconfig hci0 up
sleep 1 
#启动 bluetoothd 服务
/etc/init.d/bluetooth start
sleep 2
#开启蓝牙被扫描
hciconfig hci0 piscan
