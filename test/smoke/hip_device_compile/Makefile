include ../Makefile.defs

TESTNAME     = hip_device_compile
TESTSRC_MAIN = hip_device_compile.cpp
TESTSRC_AUX  =
TESTSRC_ALL  = $(TESTSRC_MAIN) $(TESTSRC_AUX)
ifeq (sm_,$(findstring sm_,$(AOMP_GPU)))
CFLAGS = -x cuda -I/usr/local/cuda/include --offload-arch=${AOMP_GPU} -std=c++11
LINK_FLAGS =  -L$(CUDA)/targets/$(UNAMEP)-linux/lib -lcudart -Wl,-rpath,/usr/local/cuda/targets/x86_64-linux/lib
else
AOMPHIP ?= $(AOMP)
VERS = $(shell $(AOMP)/bin/clang --version | grep -oP '(?<=clang version )[0-9.]+')
ifeq ($(shell expr $(VERS) \>= 12.0), 1)
  RPTH = -Wl,-rpath,$(AOMPHIP)/lib
  LLIB = -L$(AOMPHIP)/lib
endif
CFLAGS = -x hip --offload-arch=${AOMP_GPU} -std=c++11 $(LLIB) -lamdhip64 $(RPTH)
endif
OMP_FLAGS    =
AOMPROCM ?= /opt/rocm
ifeq ($(EPSDB),1)
OMP_BIN      = $(AOMPROCM)/bin/hipcc
else
CLANG        = clang++
OMP_BIN      = $(AOMP)/bin/$(CLANG)
endif
CC           = $(OMP_BIN) $(VERBOSE)

#-ccc-print-phases
#"-\#\#\#"

include ../Makefile.rules
