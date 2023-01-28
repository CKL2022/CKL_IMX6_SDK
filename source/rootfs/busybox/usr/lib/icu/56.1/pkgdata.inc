GENCCODE_ASSEMBLY_TYPE=-a gcc
SO=so
SOBJ=so
A=a
LIBPREFIX=lib
LIB_EXT_ORDER=.56.1
COMPILE=arm-poky-linux-gnueabi-gcc  -march=armv7ve -mfpu=neon  -mfloat-abi=hard -mcpu=cortex-a7 --sysroot=/home/linuxdzm/alientek_workspace/ycoto/fsl-release-bsp/buildQt5.12.9/tmp/sysroots/imx6ull14x14evk -D_REENTRANT  -DU_HAVE_ELF_H=1 -DU_HAVE_ATOMIC=1  -DU_ATTRIBUTE_DEPRECATED= -O2 -pipe -g -feliminate-unused-debug-types -fdebug-prefix-map=/home/linuxdzm/alientek_workspace/ycoto/fsl-release-bsp/buildQt5.12.9/tmp/work/cortexa7hf-neon-poky-linux-gnueabi/icu/56.1-r0=/usr/src/debug/icu/56.1-r0 -fdebug-prefix-map=/home/linuxdzm/alientek_workspace/ycoto/fsl-release-bsp/buildQt5.12.9/tmp/sysroots/x86_64-linux= -fdebug-prefix-map=/home/linuxdzm/alientek_workspace/ycoto/fsl-release-bsp/buildQt5.12.9/tmp/sysroots/imx6ull14x14evk=  -std=c99 -Wall -pedantic -Wshadow -Wpointer-arith -Wmissing-prototypes -Wwrite-strings   -c
LIBFLAGS=-I/usr/include -DPIC -fPIC
GENLIB=arm-poky-linux-gnueabi-gcc  -march=armv7ve -mfpu=neon  -mfloat-abi=hard -mcpu=cortex-a7 --sysroot=/home/linuxdzm/alientek_workspace/ycoto/fsl-release-bsp/buildQt5.12.9/tmp/sysroots/imx6ull14x14evk -O2 -pipe -g -feliminate-unused-debug-types -fdebug-prefix-map=/home/linuxdzm/alientek_workspace/ycoto/fsl-release-bsp/buildQt5.12.9/tmp/work/cortexa7hf-neon-poky-linux-gnueabi/icu/56.1-r0=/usr/src/debug/icu/56.1-r0 -fdebug-prefix-map=/home/linuxdzm/alientek_workspace/ycoto/fsl-release-bsp/buildQt5.12.9/tmp/sysroots/x86_64-linux= -fdebug-prefix-map=/home/linuxdzm/alientek_workspace/ycoto/fsl-release-bsp/buildQt5.12.9/tmp/sysroots/imx6ull14x14evk=  -std=c99 -Wall -pedantic -Wshadow -Wpointer-arith -Wmissing-prototypes -Wwrite-strings   -Wl,-O1 -Wl,--hash-style=gnu   -shared -Wl,-Bsymbolic
LDICUDTFLAGS=
LD_SONAME=-Wl,-soname -Wl,
RPATH_FLAGS=
BIR_LDFLAGS=-Wl,-Bsymbolic
AR=arm-poky-linux-gnueabi-ar
ARFLAGS=r
RANLIB=arm-poky-linux-gnueabi-ranlib
INSTALL_CMD=/usr/bin/install -c
