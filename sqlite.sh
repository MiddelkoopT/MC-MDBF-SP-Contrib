#!/bin/zsh

CONTRIB=$PWD
: ${GCC:=gcc}

SQLITE_VERSION=3.6.23.1
SQLITE_URL=http://www.sqlite.org/sqlite-amalgamation-${SQLITE_VERSION}.tar.gz
SQLITEJDBC_URL=http://files.zentus.com/sqlitejdbc/sqlitejdbc-v056.jar
PYSQLITE_URL=http://pysqlite.googlecode.com/files/pysqlite-2.6.0.tar.gz

## Build
set -e

[ -r download/$(basename $SQLITE_URL) ] || wget $SQLITE_URL -P download
[ -r download/$(basename $SQLITEJDBC_URL) ] || wget $SQLITEJDBC_URL -P download
[ -r download/$(basename $PYSQLITE_URL) ] || wget $PYSQLITE_URL -P download

install -dv build

## Sqlite
SRC=( build/sqlite-${SQLITE_VERSION} )
[ -d $SRC ] || ( cd build && tar -xzf ../download/$(basename $SQLITE_URL) )

( cd $SRC && CC=${GCC} CXX=${GCC} ./configure --prefix=$CONTRIB && make && make install )

## Python
SRC=( build/pysqlite-2.6.0 )
[ -d $SRC ] || ( cd build && tar -xzf ../download/$(basename $PYSQLITE_URL) )

cat >$SRC/setup.cfg <<EOF
[build_ext]
#define=
include_dirs=${CONTRIB}/include
library_dirs=${CONTRIB}/lib
libraries=sqlite3
define=SQLITE_OMIT_LOAD_EXTENSION
EOF

## Java
install -dv download/$(basename $SQLITEJDBC_URL) share/java/sqlitejdbc.jar

( cd $SRC && python setup.py build )
( cd $SRC && python setup.py install --prefix ${CONTRIB} )

rm -rf ${SRC}
touch build/sqlite.stamp
