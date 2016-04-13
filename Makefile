.PHONY: clean

tensor: build/tensor
	mv -f build/tensor .

build/tensor: build/Makefile
	$(MAKE) -C build

build/Makefile:
	mkdir build && cd build && qmake ..

tensor.apk: build-android/target/bin/QtApp-release-unsigned.apk
	mv -f build-android/target/bin/QtApp-release-unsigned.apk tensor.apk

build-android/target/bin/QtApp-release-unsigned.apk: build-android/Makefile
	$(MAKE) -C build-android install INSTALL_ROOT=target
	$(QT)/android_armv7/bin/androiddeployqt --release \
		--input  build-android/android-libtensor.so-deployment-settings.json \
		--output build-android/target

build-android/Makefile:
	mkdir build-android && cd build-android && $(QT)/android_armv7/bin/qmake ..

clean:
	rm -rf build build-android
