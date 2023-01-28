#!/bin/sh -
#===============================================
#    Copyright By ALIENTEK, All Rights Reserved
#    https://www.openedv.com
#    File Name:  setmac.sh
#    Created  :  2021-7-5
#================================================

mkdir -p /var/.macconfig
MACFILE=/var/.macconfig/mac
ETHNAME1=eth0
ETHNAME2=eth1

makeMacByPerl() {
    echo -e 88`perl -e 'print join("",map{sprintf "%0.2x",rand(256)}(1..6)), "\n"' | cut -c1-10`
}

if [ ! -f "$MACFILE" ]; then
    echo `makeMacByPerl` > $MACFILE
    echo `makeMacByPerl` >> $MACFILE
    sync
fi
tmpvalue1=$(sed -n '1p' $MACFILE)
tmpvalue2=$(sed -n '2p' $MACFILE)
# Set mac
/sbin/ifconfig $ETHNAME1 hw ether $tmpvalue1 >/dev/null 2>&1
/sbin/ifconfig $ETHNAME2 hw ether $tmpvalue2 >/dev/null 2>&1

