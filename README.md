# Tensor
Tensor is an IM client for the [Matrix](https://matrix.org) protocol in development. [![Build Status](https://travis-ci.org/davidar/tensor.svg?branch=master)](https://travis-ci.org/davidar/tensor)

![](client/logo.png)

## Pre-requisites
- a Git client (to check out this repo)
- a C++ toolchain that can deal with Qt (see a link for your platform at http://doc.qt.io/qt-5/gettingstarted.html#platform-requirements)
- Qt 5 (either Open Source or Commercial)

## Linux

![Screenshot](screen/kde4.png)

### Installing pre-requisites
Just install things from "Pre-requisites" using your preferred package manager.

### Building
From the root directory of the project sources:
```
make
```

## Android

[![Get it on F-Droid](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Get_it_on_F-Droid.svg/320px-Get_it_on_F-Droid.svg.png)](https://f-droid.org/repository/browse/?fdid=io.davidar.tensor)

Alternatively, [Download *Qt for Android*](http://www.qt.io/download-open-source/#section-2), open `tensor.pro` in Qt Creator, and [build for Android](http://doc.qt.io/qt-5/androidgs.html).

![Screenshot](screen/android.png)

## OS X

![Screenshot](screen/osx.png)

Build `tensor.pro` with Qt Creator, or:

```
brew install qt5
make
```

## iOS

![Screenshot](screen/ipad.png)

- [Qt for iOS](http://doc.qt.io/qt-5/ios-support.html)
- [Qt5 Tutorial: Bypass Qt Creator and use XCode](https://www.youtube.com/watch?v=EAdAvMc1MCI)

## Windows

![Screenshot](screen/win7.png)

Build `tensor.pro` with Qt Creator.
