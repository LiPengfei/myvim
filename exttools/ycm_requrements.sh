#!/bin/bash

yum install clang-devel
yum install cmake
yum install mono-core
yum install mono-devel
yum install boost-devel
yum install python-devel
yum install golang
yum install gcc-g++

sudo ./install.sh --clang-completer --system-libclang --omnisharp-completer --gocode-completer --system-boost
