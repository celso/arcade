CFLAGS = -O
SHELL =		/bin/sh

RANLIB =		ranlib
CC =		cc

CFLAGS =	-I.
CLFLAGS =	-Wl -lm -L.
P      =	
BINDIR	=	/home/sapo/BASE/cgi-bin/

LIBS = 

all: 	killuae keycodes

killuae: $(P) killuae.o $(LIBS)
	$(CC) killuae.o $(LIBS) $(CLFLAGS) -o killuae
	@echo "$(OUTP) compiled."

keycodes: $(P) keycodes.o $(LIBS)
	$(CC) keycodes.o $(LIBS) $(CLFLAGS) -o keycodes
	@echo "$(OUTP) compiled."

clean:
	rm -f keycodes killuae
	rm -f *.a *.o core errs *~ \#* TAGS *.E a.out
	@echo "All clean. Type make all to rebuild."

# DO NOT DELETE THIS LINE -- make depend depends on it.
killuae.o:
keycodes.o:
