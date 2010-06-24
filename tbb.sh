#!/bin/zsh

TBB=tbb30_035oss
TBB_URL=http://www.threadingbuildingblocks.org/uploads/78/155/3.0%20update%201/tbb30_035oss_src.tgz

PACKAGE=$PWD
MAKEOPTS=( CPLUS=g++ -j8 )

## Common
set -e
install -dv download build include lib

## TBB
if [ ! -r download/${TBB}_src.tgz ] ; then
    wget ${TBB_URL} -P download
fi

if [ ! -d build/${TBB} ] ; then
    ( cd build ; tar -xzf ../download/${TBB}_src.tgz )
fi

( cd build/${TBB} && make ${MAKEOPTS} )

LIBS=( tbb_debug tbbmalloc_debug tbb tbbmalloc )
for L in ${LIBS} ; do 
  cp -v build/$TBB/build/linux_*/lib${L}.so* ${PACKAGE}/lib
done
cp -Rv build/$TBB/include/tbb ${PACKAGE}/include/tbb
rm -v ${PACKAGE}/include/tbb/index.html

rm -rf build/$TBB
touch build/tbb.stamp
