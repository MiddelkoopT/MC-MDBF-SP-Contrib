## Eclipse Contrib Project.  Copyright 2010 Timothy Middelkoop. GPL/CPL/BSD

all: build/tbb.stamp build/papi.stamp

clean:
	./clean.sh

download:
	./clean.sh

build/%.stamp:
	./$*.sh
