#!/bin/zsh

TBB=tbb41_20130116oss
TBB_URL=http://threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb41_20130116oss_src.tgz # md5:3809790e1001a1b32d59c9fee590ee85

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
