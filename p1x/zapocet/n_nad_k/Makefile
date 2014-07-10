all: comb

comb: main.c libcomb.o
	gcc main.c libcomb.o -o comb

libcomb.o: libcomb.c
	gcc -Wall -c libcomb.c

clean:
	rm -f *.o comb
