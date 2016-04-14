.PHONY: clean

QT ?= $(HOME)/Qt/5.5

tensor: build/tensor
	mv -f build/tensor .

build/tensor: build/Makefile
	$(MAKE) -C build

build/Makefile: lib/libqmatrixclient.pri
	mkdir build && cd build && qmake ..

lib/libqmatrixclient.pri:
	git submodule update --init
	cd lib && git submodule update --init

tensor.apk: build-android/target/bin/QtApp-release-unsigned.apk
	mv -f build-android/target/bin/QtApp-release-unsigned.apk tensor.apk

build-android/target/bin/QtApp-release-unsigned.apk: build-android/Makefile
	$(MAKE) -C build-android install INSTALL_ROOT=target
	$(QT)/android_armv7/bin/androiddeployqt --release \
		--input  build-android/android-libtensor.so-deployment-settings.json \
		--output build-android/target

build-android/Makefile: lib/libqmatrixclient.pri $(QT)
	mkdir build-android && cd build-android && $(QT)/android_armv7/bin/qmake ..

qt-unified-linux-x86-online.run:
	wget http://download.qt.io/official_releases/online_installers/$@ && chmod a+x $@

$(HOME)/Qt/5.5: qt-unified-linux-x86-online.run
	echo "Installing Qt 5.5 to ~/Qt"
	./qt-unified-linux-x86-online.run --script qt-installer-noninteractive.qs --platform minimal --verbose

clean:
	rm -rf build build-android tensor tensor.apk
