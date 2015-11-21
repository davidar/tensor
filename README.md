# Tensor
Cross-platform QML-based [Matrix](https://matrix.org) client

![](src/logo.png)

# Building
- Clone submodules: `git submodule init && git submodule update`
- Build Matrix JavaScript SDK: `cd matrix-js-sdk && npm install && npm run build && cd ..`
- Install [Qt5](http://www.qt.io/download-open-source/)
- Build according to the instructions for your platform:
  - Desktop: `qmake && make` (or build with [Qt Creator](http://www.qt.io/ide/))
    - Windows: make sure [OpenSSL](https://slproweb.com/products/Win32OpenSSL.html) is installed
  - [Android](http://doc.qt.io/qt-5/androidgs.html)
  - Other platforms: [submit an issue](https://github.com/davidar/tensor/issues) ;)

# Usage
Run `./matrix`, fill in your account details, hit enter, and start chatting ;)

# Screenshots
![](screenshots/all.png)
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
