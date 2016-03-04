################################################################################
#
##  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  #  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#  #
#  This Program is distributed in the hope that it will be useful,
#  #  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  #  GNU General Public License for more details.
#
##  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  #  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
#  ################################################################################

PKG_NAME="qt"
PKG_VERSION="5.6.0-beta"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://nightlies.plex.tv"
PKG_URL="$PKG_SITE/directdl/plex-oe-sources/$PKG_NAME-everywhere-opensource-src-$PKG_VERSION.tar.gz"

case $PROJECT in
	Generic|Nvidia_Legacy)
		PKG_DEPENDS_TARGET="curl bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfig glibc liberation-fonts-ttf font-util font-xfree86-type1 font-misc-misc alsa flex bison ruby libXcursor libXtst pciutils  nss libxkbcommon libdrm libXi atk libXScrnSaver"
		PKG_BUILD_DEPENDS_TARGET="bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfig openssl linux-headers glibc alsa libXcursor libXtst pciutils pulseaudio nss libxkbcommon"
	;;
	RPi|RPi2)
		PKG_DEPENDS_TARGET="curl bcm2835-driver bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfig glibc liberation-fonts-ttf font-util font-xfree86-type1 font-misc-misc alsa flex bison ruby libX11 xrandr libXdmcp libxslt libXcomposite libwebp libevdev libxkbcommon libdrm libXi atk"
		PKG_BUILD_DEPENDS_TARGET="bcm2835-driver bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfig openssl linux-headers glibc alsa libxkbcommon"

	;;
esac

PKG_PRIORITY="optional"
PKG_SECTION="lib"
PKG_SHORTDESC="Qt GUI toolkit"
PKG_LONGDESC="Qt GUI toolkit"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$CI_BUILD" = true ]; then
 PLEX_DUMP_SYMBOLS=yes
fi

case $PROJECT in
        RPi)
	ARM_COMPILER_PREFIX="armv6zk-openelec-linux-gnueabi-"
	;;

	RPi2)
	ARM_COMPILER_PREFIX="armv7ve-openelec-linux-gnueabi-"
	;;
esac

if [ "$PLEX_DEBUG" = yes ]; then
 QT_FLAGS=--force-debug-info
fi

case $PROJECT in
	Generic|Nvidia_Legacy)
                PKG_CONFIGURE_OPTS="\
							-sysroot ${SYSROOT_PREFIX} \
							-prefix /usr/local/qt5
                                                        -hostprefix ${ROOT}/${BUILD} \
                                                        -release \
                                                        -v \
                                                        -opensource \
                                                        -confirm-license \
                                                        -optimized-qmake \
                                                        -shared \
                                                        -opengl desktop\
                                                        -make libs \
                                                        -no-pch \
                                                        -no-icu \
                                                        -qpa xcb \
                                                        -system-xkbcommon \
                                                        -qt-xcb \
                                                        -no-sql-sqlite2 \
                                                        -arch $TARGET_ARCH \
                                                        -platform linux-g++ \
                                                        -xplatform linux-g++-openelec \
                                                        -no-accessibility \
                                                        -skip qtactiveqt \
                                                        -skip qtandroidextras \
                                                        -skip qtconnectivity \
                                                        -skip qtdoc \
                                                        -skip qtenginio \
                                                        -skip qtgraphicaleffects \
                                                        -skip qtlocation \
                                                        -skip qtmacextras \
                                                        -skip qtscript \
                                                        -skip qtsensors \
                                                        -skip qtserialport \
                                                        -skip qtwayland \
                                                        -skip qtwinextras \
                                                        -skip qtxmlpatterns \
                                                        -skip qttranslations \
                                                        -skip qtmultimedia \
                                                        -skip qtquickcontrols2 \
                                                        -skip qt3d \
                                                        -nomake examples \
                                                        -nomake tests \
                                                        $QT_FLAGS"
	;;
 	RPi|RPi2)
                PKG_CONFIGURE_OPTS="\
                                                        -sysroot ${SYSROOT_PREFIX} \
                                                        -prefix /usr/local/qt5 \
                                                        -hostprefix ${ROOT}/${BUILD} \
                                                        -v \
                                                        -release \
                                                        -opensource \
                                                        -confirm-license \
                                                        -optimized-qmake \
                                                        -no-icu \
                                                        -qpa eglfs \
                                                        -no-xcb \
                                                        -no-kms \
                                                        -no-directfb \
                                                        -no-sql-sqlite2 \
                                                        -no-libjpeg \
                                                        -system-xkbcommon \
                                                        -shared \
                                                        -device linux-rasp-pi2-g++ \
                                                        -device-option CROSS_COMPILE=${ROOT}/${TOOLCHAIN}/bin/${ARM_COMPILER_PREFIX} \
                                                        -opengl es2 \
                                                        -make libs \
                                                        -nomake examples \
                                                        -no-pch \
                                                        -nomake tests \
                                                        -no-accessibility \
                                                        -skip qtactiveqt \
                                                        -skip qtandroidextras \
                                                        -skip qtconnectivity \
                                                        -skip qtdoc \
                                                        -skip qtenginio \
                                                        -skip qtgraphicaleffects \
                                                        -skip qtlocation \
                                                        -skip qtmacextras \
                                                        -skip qtscript \
                                                        -skip qtsensors \
                                                        -skip qtserialport \
                                                        -skip qtwayland \
                                                        -skip qtwinextras \
                                                        -skip qtx11extras \
                                                        -skip qtxmlpatterns \
                                                        -skip qttranslations \
                                                        -skip qtmultimedia \
                                                        -skip qtquickcontrols2 \
                                                        -skip qt3d \
                                                        $QT_FLAGS"
        ;;
esac

unpack() {

	tar -xzf $SOURCES/${PKG_NAME}/qt-everywhere-opensource-src-${PKG_VERSION}.tar.gz -C $BUILD/
	mv $BUILD/qt-everywhere-opensource-src-${PKG_VERSION} $BUILD/${PKG_NAME}-${PKG_VERSION}
        mkdir -p $BUILD/${PKG_NAME}-${PKG_VERSION}/qtbase/mkspecs/linux-g++-openelec

## BIIIIIG HACK TIME!!

if [ "$TARGET_ARCH" = i386 ]; then
    ARCHFLAGS="-m32"
elif [ "$TARGET_ARCH" = x86_64 ]; then
    ARCHFLAGS="-m64"
fi

cat > $BUILD/${PKG_NAME}-${PKG_VERSION}/qtbase/mkspecs/linux-g++-openelec/qmake.conf <<EOF

MAKEFILE_GENERATOR      = UNIX
TARGET_PLATFORM         = unix
TEMPLATE                = app
CONFIG                  += qt warn_on release incremental link_prl
QT                      += core gui network
QMAKE_INCREMENTAL_STYLE = sublib

CFG_ARCH                = $TARGET_ARCH
QMAKE_CFLAGS            = $ARCHFLAGS
QMAKE_LFLAGS            = $ARCHFLAGS
QMAKE_CXXFLAGS          = $ARCHFLAGS

include(../common/linux.conf)
include(../common/gcc-base-unix.conf)
include(../common/g++-unix.conf)
load(qt_config)

# Set RPATH location to search for dynamic libraries relative to executable
QMAKE_LFLAGS            += '-Wl,-rpath,\'\\\$\$ORIGIN/../lib\'' 
QMAKE_LFLAGS            += '-Wl,-rpath-link,$ROOT/$PKG_BUILD/install/lib'

QMAKE_CC                = $TARGET_CC
QMAKE_CXX               = $TARGET_CXX
QMAKE_LINK              = $TARGET_CXX
QMAKE_LINK_SHLIB        = $TARGET_CXX
QMAKE_AR                = $TARGET_AR cqs
QMAKE_OBJCOPY           = $TARGET_OBJCOPY
QMAKE_RANLIB            = $TARGET_RANLIB
QMAKE_STRIP             = $TARGET_STRIP

# Headers Search Path
QMAKE_INCDIR          = $LIB_PREFIX/include
QMAKE_INCDIR         += $LIB_PREFIX/include/freetype2 $MYSQL_INCDIR
QMAKE_INCDIR_X11      = $LIB_PREFIX/include/X11
QMAKE_INCDIR_OPENGL   = $LIB_PREFIX/include
QMAKE_INCDIR_QT       = $ROOT/$PKG_BUILD/install/include

# Libraries Search Path
QMAKE_LIBDIR          = $LIB_PREFIX/lib
QMAKE_LIBDIR_X11      = $LIB_PREFIX/lib
QMAKE_LIBDIR_OPENGL   = $LIB_PREFIX/lib
QMAKE_LIBDIR_QT       = $ROOT/$PKG_BUILD/install/lib

load(qt_config)
EOF
}

pre_configure_target() {
   cd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
   sed -i "s,##SYSROOT_PREFIX##,${SYSROOT_PREFIX}/usr/include,g" qtbase/src/gui/gui.pro 
   sed -i "s|/usr/local/install|$ROOT/$PKG_BUILD/install|g" configure
   CFLAGS="$CFLAGS -fPIC -fno-lto"
   CXXFLAGS="$CXXFLAGS -fPIC -fno-lto"
   LDFLAGS="$LDFLAGS -fPIC -fno-lto"
}

configure_target() {

	case $PROJECT in
		Generic|Nvidia_Legacy)
			unset CC CXX AR OBJCOPY STRIP CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LD RANLIB
			export QT_FORCE_PKGCONFIG=yes
			unset QMAKESPEC
			PKG_CONFIG_PATH="$SYSROOT_PREFIX/usr/lib/pkgconfig"

			cd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
			./configure ${PKG_CONFIGURE_OPTS}
		;;
		RPi|RPi2)
			# Add the RPI HW JPEG decoding files to webengine
			cp -R $PKG_DIR/patches/RpiHWJpeg/* ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}/qtwebengine/src/3rdparty/chromium/third_party/WebKit/Source/platform/image-decoders/

			unset CC CXX AR OBJCOPY STRIP CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LD RANLIB
			export QT_FORCE_PKGCONFIG=yes
			unset QMAKESPEC
		
			cp $SYSROOT_PREFIX/usr/include/interface/vcos/pthreads/vcos_platform_types.h $SYSROOT_PREFIX/usr/include/interface/vcos/
			cp $SYSROOT_PREFIX/usr/include/interface/vcos/pthreads/vcos_platform.h $SYSROOT_PREFIX/usr/include/interface/vcos/
			cp $SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux/vchost_config.h $SYSROOT_PREFIX/usr/include/interface/vmcs_host/
		
			cd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
			./configure ${PKG_CONFIGURE_OPTS}
		;;
	esac
}

make_target() {
	case $PROJECT in
		Generic|Nvidia_Legacy)
			export PYTHON_EXEC="$SYSROOT_PREFIX/usr/bin/python2.7"
			export PYTHONPATH="$SYSROOT_PREFIX/usr/lib/python2.7/lib-dynload"
			unset CC CXX AR OBJCOPY STRIP CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LD RANLIB
			export QT_FORCE_PKGCONFIG=yes
			PKG_CONFIG_PATH="$SYSROOT_PREFIX/usr/lib/pkgconfig"
			unset QMAKESPEC

			cd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
			make
		;;
		RPi|RPi2)
			unset CC CXX AR OBJCOPY STRIP CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LD RANLIB
			export QT_FORCE_PKGCONFIG=yes
			unset QMAKESPEC
		
			cd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
			make
		;;
	esac
}

makeinstall_target() {

	cd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
	make install DESTDIR=${SYSROOT_PREFIX}/usr/local/qt5

	mkdir -p $INSTALL/usr/local/qt5/lib
	cp -Rf ${SYSROOT_PREFIX}/usr/local/qt5/lib/* ${INSTALL}/usr/local/qt5/lib

	mkdir -p $INSTALL/usr/local/qt5/libexec
        cp -Rf ${SYSROOT_PREFIX}/usr/local/qt5/libexec/* ${INSTALL}/usr/local/qt5/libexec

        mkdir -p $INSTALL/usr/local/qt5/plugins
        cp -Rf ${SYSROOT_PREFIX}/usr/local/qt5/plugins/* ${INSTALL}/usr/local/qt5/plugins

	mkdir -p $INSTALL/usr/local/qt5/translations
        cp -Rf ${SYSROOT_PREFIX}/usr/local/qt5/translations/* ${INSTALL}/usr/local/qt5/translations

        cp -Rf ${SYSROOT_PREFIX}/usr/local/qt5/qtwebengine*.pak ${INSTALL}/usr/local/qt5/
	cp -Rf ${SYSROOT_PREFIX}/usr/local/qt5/icudtl.dat ${INSTALL}/usr/local/qt5/icudtl.dat

	#cleanup the plugins
	case $PROJECT in
          Generic|Nvidia_Legacy)
	  ;;
	  RPi|RPi2)
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/generic/libqevdevtabletplugin.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/generic/llibqevdevtouchplugin.so
		
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/imageformats/libqdds.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/imageformats/libqgif.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/imageformats/libqicns.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/imageformats/libqico.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/imageformats/libqjp2.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/imageformats/libqmng.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/imageformats/libqtga.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/imageformats/libqtiff.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/imageformats/libqwbmp.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/imageformats/libqwebp.so
            rm -f ${INSTALL}/usr/local/qt5/plugins/imageformats/libqjpeg*

	    rm -f  ${INSTALL}/usr/local/qt5/plugins/platforms/libqlinuxfb.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/platforms/libqminimal.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/platforms/libqminimalegl.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/platforms/libqoffscreen.so
	    rm -f  ${INSTALL}/usr/local/qt5/plugins/platforms/libqxcb.so
	    rm -f ${INSTALL}/usr/local/qt5/plugins/imageformats/libqjpeg*
	  ;;
	esac

        mkdir -p $INSTALL/usr/local/qt5/qml
        cp -R ${SYSROOT_PREFIX}/usr/local/qt5/qml/* ${INSTALL}/usr/local/qt5/qml
}
