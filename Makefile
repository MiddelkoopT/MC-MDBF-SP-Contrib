all: build/tbb.stamp build/papi.stamp

clean:
	./clean.sh

build/tbb.stamp:
	./tbb.sh

build/papi.stamp:
	./papi.sh
