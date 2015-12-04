# Tensor
Tensor is a cross-platform native [Matrix](https://matrix.org) client, based on [QtQuick/QML](http://www.qt.io/qt-quick/) and [matrix-js-sdk](https://github.com/matrix-org/matrix-js-sdk).

![](screenshots/all.png)

# Build Instructions
1. Clone Git submodules: `git submodule update --init` (or `git clone --recursive`) from within the repo's folder.
2. Install [Qt5](http://www.qt.io/download-open-source/) if you don't have it already, then fetch your distribution's flavor of these packages: (for the sake of simplicity, the Ubuntu/Debian edition of the required packages will be listed here)
  - qt5-default
  - qt5-qmake
  - qtdeclarative5-dev
  - qtdeclarative5-controls-plugin
3. Build according to the instructions for your platform:
  - Linux:
    - `qmake && make` (or build with [Qt Creator](http://www.qt.io/ide/))
  - Windows:
    - make sure [OpenSSL](https://slproweb.com/products/Win32OpenSSL.html) is installed.
  - Android:
    - http://doc.qt.io/qt-5/androidgs.html
  - Other platforms: [submit an issue](https://github.com/davidar/tensor/issues) ;)

# Usage
Run `./tensor`, fill in your account details, hit enter, join the `#tensor:matrix.org` room, and start chatting ;)

# Screenshots
## Android Lollipop
![](screenshots/android5.png)
## Ubuntu Phone
![](screenshots/ubuntu-phone.png)
## SailfishOS
![](screenshots/sailfish.png)
## KDE 4
![](screenshots/kde4.png)
## OS X
![](screenshots/osx.png)
## Windows 7
![](screenshots/windows7.png)
## Methane Browser
![](screenshots/methane-browser.png)
