.PHONY: clean

QT ?= $(HOME)/Qt/5.5
QT_ARCH ?= x86
export ANDROID_SDK_ROOT ?= $(PWD)/android-sdk-linux
export ANDROID_NDK_ROOT ?= $(PWD)/android-ndk-r10e

tensor: build/tensor
	mv -f build/tensor .

build/tensor: build/Makefile
	$(MAKE) -C build

build/Makefile: lib/libqmatrixclient.pri
	mkdir -p build && cd build && qmake ..

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

build-android/Makefile: lib/libqmatrixclient.pri $(QT) $(ANDROID_NDK_ROOT) \
  $(ANDROID_SDK_ROOT)/platform-tools \
  $(ANDROID_SDK_ROOT)/platforms/android-23 \
  $(ANDROID_SDK_ROOT)/build-tools/23.0.3
	mkdir -p build-android && cd build-android && $(QT)/android_armv7/bin/qmake ..

qt-unified-linux-$(QT_ARCH)-2.0.3-online.run:
	wget http://master.qt.io/archive/online_installers/2.0/$@

$(HOME)/Qt/5.5: qt-unified-linux-$(QT_ARCH)-2.0.3-online.run
	sha256sum -c $<.sha256
	echo "Installing Qt for Android to $@"
	chmod a+x $<
	ls -lh $<
	./$< --script qt-installer-noninteractive.qs --platform minimal --verbose

android-sdk_r24.4.1-linux.tgz:
	wget https://dl.google.com/android/$@

android-sdk-linux: android-sdk_r24.4.1-linux.tgz
	tar -zxvf $< && touch $@

android-23_r01.zip:
	wget https://dl.google.com/android/repository/$@

build-tools_r23.0.3-linux.zip:
	wget https://dl.google.com/android/repository/$@

$(PWD)/android-sdk-linux/platform-tools: android-sdk-linux
	echo y | $</tools/android update sdk -u --filter platform-tools && touch $@

$(PWD)/android-sdk-linux/platforms/android-23: android-23_r01.zip
	unzip $< && mv android-6.0 $@ && touch $@

$(PWD)/android-sdk-linux/build-tools/23.0.3: build-tools_r23.0.3-linux.zip
	mkdir -p $(PWD)/android-sdk-linux/build-tools
	unzip $< && mv android-6.0 $@ && touch $@

android-ndk-r10e-linux-x86.bin:
	wget https://dl.google.com/android/ndk/$@

$(PWD)/android-ndk-r10e: android-ndk-r10e-linux-x86.bin
	chmod a+x $< && ./$< && touch $@

clean:
	rm -rf build build-android android-sdk-linux android-ndk-r10e tensor tensor.apk tensor-debug.apk
