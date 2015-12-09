This is step by step procedure to setup Raspberry PI cross compile for your boards. It has been tested on Ubuntu for Raspberry PI model B+ and it uses Linaro cross compiler.  For more details, please visit

http://rpilinuxdev.blogspot.ro/



Step 1. Obtain Linaro Raspbian bcm2708 arm-hf cross compiler.


$ mkdir rpi-cross

$ cd rpi-cross

$ git clone https://github.com/raspberrypi/tools.git




Step 2. Download cross compile environment scripts:


$ git clone https://github.com/ionutneicu/rpi-cross-scripts.git



IMPORTANT NOTE: There are 2 versions of my cross compile scripts. The one prefixed with "local" works with a local copy of Raspbian rootfs image. This means you have to copy locally the entire Raspbian image from RPI card.

The other one will work with a remote Raspbian rootfs directly from your Raspberry PI. Despite the fact it is slower, I would recommend this for the beginning because the dependencies can be easily installed directly on PI with apt-get install commands. For example, if the application/package you want to compile needs glib-2.0, just install it on RPI using 


sudo apt-get install libglib-2.0-dev


Once all dependencies are clear and installed in such way on RPI, you can copy the entire RPI image on a local folder of your build machine and use local-* versions of cross compile scrips and get the benefit of their speed.




Step 3. Prepare your RPI machine. Connect it on LAN and power on. In this step, the RPI must be accessible from your build machine through ssh. If using DHCP, note down its IP address, and the user.




Step 4. Create an empty folder where the RPI rootfs will be mounted.


$ mkdir rpi-sysroot


Step 5. Edit the rpi-cross-scripts/setup-arm-dev-env.sh using your favourite editor and make some changes according to your environment:


$ vim rpi-cross-scripts/setup-arm-dev-env.sh


modify the following variables:


RASPB_ADDR=your-RPI-board-IP
RASP_USER=your-RPI-board-username

RASPB_SYSROOT=absolute-path-to-your-RPI-sysroot-empty-folder-created-at-step-4


Also modify CROSS_PATH variable so it will point to the compiler downloaded at Step 1. Use 32 or 64 bit versions according to your system and use the absolute paths for it as this script must be invoked from everywhere:


For 64 bit machine:


CROSS_PATH="<absolute-path-to>/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin"


Fir 32 bit build machine:

CROSS_PATH="<absolute-path-to>/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin"


Step 6. Save the file and run it or navigate in your source code directory that you want to cross compile and invoke it first.


If everything works fine, you will see something like:


**********************************
* RPI devenv successfully set up *
* now use:                       *
*  autoreconf -f -i              *

*  ./configure [params]            *
*  make -j$4                     *
**********************************


IMPORTANT NOTE: Do not close this terminal because the exported environment variables will be lost. Use this to navigate to your source folder and use your compile commands to configure and compile your program.


If there are dependencies problems, see Step 8.


Step 7.  Install on board.


After build finishes, install it on the local sysroot folder


$ sudo make install


If your cross compile build outptut contains at least one shared library, this will be installed on local folder that must be sync-ed with RPI. For this, use the install-on-board.sh


$ rpi-cross-scripts/install-on-board.sh


Executables can be copied on RPI and executed from any location there, or with some minor LD_LIBRARY_PATH tweaking.



Step 8. Install dependencies on RPI ( if necessary ).


If there are unsatisfied dependencies, the  compile will fail. If using Autotools, the configure will give you error about required missing package.



For example, if GLib is required, you'll get compile error like:


Error: glib.h - not found


Or, if using autootools, on configure step :


checking for GLIB ... not found.


If so, you must install development package on your RPI.


SSH into you RPI and type:


$ sudo apt-get update ( optional )

$ apt-cache search glib | grep dev


You will find something like "libglib-2.0-dev". Install it on RPI like:


$sudo apt-get install install libglib-2.0-dev


Finally, on your cross compile machine, re-run configure step if any, then recompile.


Step 9. Copy the RPI rootfs to your machine and speed up the compile process. 


Note this step must be done every time a new dependency is installed on RPI. For example, if you add another library dependency to your project, the development package must be installed on RPI sysroot as described at Step 8.


Make new folder, let's say, rpi-sysroot-local.

Poweroff the RPI and take off the SD card and mount it on your computer. Copy everything from that SD card to your rpi-sysroot-local folder. There should be folders like rpi-sysroot-local/usr, rpi-sysroot-local/lib



Step 10. Edit the rpi-cross-scripts/local-setup-arm-dev-env.sh using your favourite editor and make some changes according to your environment:


$ vim rpi-cross-scripts/local-setup-arm-dev-env.sh


set

RASPB_SYSROOT=absolute-path-to-your-RPI-local-rootfs-created-and-copied-at-step-9


CROSS_PATH=the-same-as-the-step-5


Save it and use it instead ( Go to Step 6 ).
