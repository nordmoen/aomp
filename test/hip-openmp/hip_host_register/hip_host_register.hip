#include <hip_runtime_api.h>
#include <stdlib.h>

const int expect = 42;

__global__ void write_kernel(int *d) { *d = expect; }

int main() {
  size_t size = sizeof(int);

  bool use_hip_malloc = true;   // works
  bool use_hip_register = true; // memory access fault by gpu

  if (use_hip_malloc) {
    void *pt;
    hipHostMalloc(&pt, size, 0);
    int *ipt = (int *)pt;
    *ipt = 0;
    write_kernel<<<1, 1>>>(ipt);
    hipDeviceSynchronize();
    if (*ipt != expect) {
      fprintf(stderr, "hipHostMalloc: %d\n", *ipt);
      return 1;
    }
  }

  if (use_hip_register) {
    void *pt = aligned_alloc(4096, size);

    hipError_t err = hipHostRegister(pt, size, hipHostRegisterDefault);
    if (err != hipSuccess) {
      fprintf(stderr, "hipHostRegister ret %u\n", err);
      return 1;
    }
    int *ipt = (int *)pt;
    *ipt = 0;
    write_kernel<<<1, 1>>>(ipt);
    hipDeviceSynchronize();
    if (*ipt != expect) {
      fprintf(stderr, "hipHostRegister: %d\n", *ipt);
      return 1;
    }
  }

  return 0;
}