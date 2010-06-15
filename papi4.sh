#!/bin/zsh

CONTRIB=$PWD
VERSION=4.0.0
PATCH=papi400patch3
FILE=papi-${VERSION}.tar.gz
MIRROR=http://icl.cs.utk.edu/projects/papi/downloads/
URL=${MIRROR}/${FILE}
SRC=build/papi-${VERSION}

CONFIGURE=( --with-pcl=yes --with-pcl-incdir=/lib/modules/$(uname -r)/build/include/linux )
OPTS=( -j1 )

echo @@@ Build papi4
set -e
install -dv build download

if [ ! -r download/${FILE} ] ; then
  wget ${URL} -P download
fi

if [ ! -r download/${PATCH}.diff ] ; then
  wget ${MIRROR}/patches/${PATCH}.diff -P download
fi

tar -xzf download/${FILE} -C build
( cd ${SRC} ; patch -p1 < ../../download/${PATCH}.diff )
( cd ${SRC}/src ; ./configure --prefix=${CONTRIB} ${CONFIGURE}  ; make ${OPTS} && make install )

rm -rf ${SRC}
touch build/papi4.stamp

echo @@@ Done papi4
