MP4BUILD = 1
#host_debug_flag = -g
host_debug_flag ?=

# --- Standard Makefile check for AOMP installation ---
ifeq ("$(wildcard $(AOMP))","")
  ifneq ($(AOMP),)
    $(warning AOMP not found at $(AOMP))
  endif
  AOMP = $(HOME)/rocm/aomp
  ifeq ("$(wildcard $(AOMP))","")
    $(warning AOMP not found at $(AOMP))
    AOMP = /opt/rocm/aomp
    ifeq ("$(wildcard $(AOMP))","")
      $(warning AOMP not found at $(AOMP))
      $(error Please install AOMP or correctly set env-var AOMP)
    endif
  endif
endif
# --- End Standard Makefile check for AOMP installation ---
INSTALLED_GPU  = $(shell $(AOMP)/bin/mygpu -d gfx900)
AOMP_GPU ?= $(INSTALLED_GPU)
AOMP_GPUTARGET = amdgcn-amd-amdhsa
# Default is Radeon vega/gfx900, for nvidia "export AOMP_GPU=sm_35"
ifeq (sm_,$(findstring sm_,$(AOMP_GPU)))
  AOMP_GPUTARGET = nvptx64-nvidia-cuda
endif
AOMP_CPUTARGET ?= x86_64-pc-linux-gnu
DEBUG_LEVEL ?= 0

ifeq ($(VERBOSE),1)
  $(info    Compilation and linking VERBOSE Mode ON)
  VERBOSE = -v
endif

ifeq ($(TEMPS),1)
  $(info    Compilation and linking save-temp Mode ON)
  VERBOSE += -save-temps
endif

ifdef MP4BUILD
CLANG=$(AOMP)/bin/clang++

CXXFLAGS = $(host_debug_flag) -O3 -I${OMPIDIR}/include -target $(AOMP_CPUTARGET) -fopenmp -fopenmp-targets=$(AOMP_GPUTARGET) -Xopenmp-target=$(AOMP_GPUTARGET) -march=$(AOMP_GPU) $(VERBOSE) $(CDEFS)
CXX = $(AOMP)/bin/clang++
LFLAGS = -fopenmp -fopenmp-targets=$(AOMP_GPUTARGET) -target $(AOMP_CPUTARGET)
ifeq (nvptx,$(findstring nvptx,$(AOMP_GPUTARGET)))
   CUDA ?= /usr/local/cuda
   LFLAGS += -L$(CUDA)/lib64 -lcuda -lcudart -lelf -lffi
endif
CXXLNKFLAGS = $(host_debug_flag)

else
CXXFLAGS = $(host_debug_flag) -O3 -I${OMPIDIR/include
CXXLNKFLAGS = $(host_debug_flag)
LFLAGS =
LIBS = -lm
endif

ifeq ($(DEBUG_LEVEL),0)
  SETDEBUGLIB =
  SETDEBUGRUNENV =
else
# if DEBUG_LEVEL != 0, build with the debug libraries which are slow.
  SETDEBUGLIB = LIBRARY_PATH=$(AOMP)/lib-debug
# Once you build with debug libs, you have different levels of debug
# by setting these environment variables.
# LIBOMPTARGET_DEBUG: Host device runtime debug messages
  SETDEBUGRUNENV = LIBOMPTARGET_DEBUG=1
# LIBOMPTARGET_DEVICE_RTL_DEBUG: Device runtime debug messages.
#SETDEBUGRUNENV = LIBOMPTARGET_DEVICE_RTL_DEBUG=-1
# ATMI_DEBUG: Print ATMI debug messages
#SETDEBUGRUNENV = ATMI_DEBUG=1
endif

# NOTE: You do NOT need debug libs to turn kernel tracing on.
# Set LIBOMPTARGET_KERNEL_TRACE anytime to get kernel launch trace.
# Uncomment next line to activate kernel launch trace in this makefile.
#SETDEBUGRUNENV += LIBOMPTARGET_KERNEL_TRACE=1

SRCS = 	omp_band.cpp

OBJS = $(SRCS:%.cc=objs/%.o)
all: objs omp_band

objs:
	mkdir objs

omp_band: objs $(OBJS)
	@echo
	@echo linking omp_band
	@echo
	$(SETDEBUGLIB) $(CLANG) $(CXXFLAGS) $(OBJS) $(CXXLNKFLAGS) -o $@ $(LIBS) $(LFLAGS)

run: omp_band
	$(SETDEBUGRUNENV) ./omp_band

objs/omp_band.o: omp_band.cpp
	$(CLANG) $(CXXFLAGS) -c omp_band.cpp -o $@

objs/%.o: %.c
	$(CLANG) $(CXXFLAGS) -c $< -o $@

.PHONY: clean

clean:
	rm -f omp_band objs/*.o
