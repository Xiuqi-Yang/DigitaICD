all:compile sim 

compile:
	vcs -debug +v2k\
		-full64      \
	    -sverilog    \
	    -timescale=1ns/1ps \
	    -l com.log \
	    -LDFLAGS \
	    -Wl,--no-as-needed -sverilog \
		-f rtl_list.f \
	    -f dv_list.f 
sim:
	./simv -l sim.log
simu:
	./simv -gui


clean:
	-rm -rf         simv.daidir	\
			verdiLog	\
			csrc		\
			ucli.key	\
			simv		\
			*.log		\
			*.fsdb		\
			*.conf		\
			./DVEfiles	\
			*.vpd		\
