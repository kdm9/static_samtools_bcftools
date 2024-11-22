USE_GSL=1
include Makefile

vcfplugin.o: EXTRA_CPPFLAGS =
static_bcftools: $(OBJS) plugins
	$(CC) $(DYNAMIC_FLAGS) $(ALL_LDFLAGS) -o bcftools $(OBJS) -l:libgsl.a -l:libgslcblas.a -l:libhts.a -l:libdeflate.a -l:libbz2.a -l:liblzma.a  -l:libz.a -lm -ldl -lpthread

.PHONY: static_bcftools
