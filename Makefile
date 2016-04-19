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
	mv -f $< $@

build-android/target/bin/QtApp-release-unsigned.apk: build-android/Makefile
	$(MAKE) -C build-android install INSTALL_ROOT=target
	$(QT)/android_armv7/bin/androiddeployqt --deployment bundled --release --verbose \
		--input  build-android/android-libtensor.so-deployment-settings.json \
		--output build-android/target

tensor-debug.apk: build-android/target/bin/QtApp-debug.apk
	mv -f $< $@

build-android/target/bin/QtApp-debug.apk: build-android/Makefile
	$(MAKE) -C build-android install INSTALL_ROOT=target
	$(QT)/android_armv7/bin/androiddeployqt --deployment bundled --install --verbose \
		--input  build-android/android-libtensor.so-deployment-settings.json \
		--output build-android/target

build-android/Makefile: lib/libqmatrixclient.pri $(QT)
	mkdir build-android && cd build-android && $(QT)/android_armv7/bin/qmake ..

qt-unified-linux-x86-2.0.3-online.run:
	wget http://master.qt.io/archive/online_installers/2.0/$@

$(HOME)/Qt/5.5: qt-unified-linux-x86-2.0.3-online.run
	sha256sum -c $<.sha256
	echo "Installing Qt for Android to $@"
	chmod a+x $<
	./$< --script qt-installer-noninteractive.qs --platform minimal --verbose

clean:
	rm -rf build build-android tensor tensor.apk tensor-debug.apk
