<!--
- SPDX-FileCopyrightText: None 
- SPDX-License-Identifier: CC0-1.0
-->

# Kalk <img src="kalk.png" width="40"/>
Kalk is a convergent calculator application built with the [Kirigami framework](https://kde.org/products/kirigami/). Although it is mainly targeted for mobile platforms, it can also be used on the desktop.

Originally starting as a fork of [Liri calculator](https://github.com/lirios/calculator), Kalk has gone through heavy development, and no longer shares the same codebase with Liri calculator.

<a href='https://flathub.org/apps/details/org.kde.kalk'><img width='190px' alt='Download on Flathub' src='https://flathub.org/assets/badges/flathub-badge-i-en.png'/></a>

## Features
* Basic calculation
* History
* Unit conversion 
* Currency conversion
* Binary calculation

## Links
* Project page: https://invent.kde.org/plasma-mobile/kalk
* Issues: https://bugs.kde.org/enter_bug.cgi?product=Kalk
* Development channel: https://matrix.to/#/#plasmamobile:matrix.org

## Dependencies
* Qt5 
* Qt5 Feedback
* Cmake
* KI18n
* KUnitConversion
* Kirigami
* KConfig
* GNU Bison
* Flex
* GMP
* MPFR

## Building and Installing

```sh
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/path/to/prefix -G Ninja .. # add -DCMAKE_BUILD_TYPE=Release to compile for release
ninja install # use sudo if necessary
```

Replace `/path/to/prefix` to your installation prefix.
Default is `/usr/local`.

## Licensing
GPLv3, see [this page](https://www.gnu.org/licenses/gpl-3.0.en.html).
