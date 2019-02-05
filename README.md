AOMP - V 0.6-0
==============

aomp:  AMD OpenMP Compiler 

This is README.md for https:/github.com/ROCM-Developer-Tools/aomp .  This is the base repository for AOMP,  Use this for issues, documentation, packaging, examples, build.  

AOMP is an experimental PROTOTYPE that is intended to support multiple programming models including OpenMP 4.5+,
, HIP, and cuda clang.  It supports offloading to multiple GPU acceleration targets(multi-target).  It also supports different host platforms such as AMD64, PPC64LE, and AARCH64. (multi-platform). 

The bin directory of this repository contains a README.md and build scripts needed to build and install AOMP. However, we recommend that you install from the debian or rpm packages described below.

Attention Users!  Use this repository for issues. Do not put issues in the source code repositories.  Before creating an issue, you may want to see the developers list of TODOs.  See link below.

Table of contents
-----------------

- [Copyright and Disclaimer](#Copyright)
- [Software License Agreement](LICENSE)
- [Install](#Install)
- [Examples](examples)
- [Development](bin/README.md)
- [TODOs](bin/TODOs) List of TODOs for this release
- [Limitations](#Limitations)

## Copyright and Disclaimer

<A NAME="Copyright">
Copyright (c) 2019 ADVANCED MICRO DEVICES, INC.

AMD is granting you permission to use this software and documentation (if any) (collectively, the 
Materials) pursuant to the terms and conditions of the Software License Agreement included with the 
Materials.  If you do not have a copy of the Software License Agreement, contact your AMD 
representative for a copy.

You agree that you will not reverse engineer or decompile the Materials, in whole or in part, except for 
example code which is provided in source code form and as allowed by applicable law.

WARRANTY DISCLAIMER: THE SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY 
KIND.  AMD DISCLAIMS ALL WARRANTIES, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT 
LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
PURPOSE, TITLE, NON-INFRINGEMENT, THAT THE SOFTWARE WILL RUN UNINTERRUPTED OR ERROR-
FREE OR WARRANTIES ARISING FROM CUSTOM OF TRADE OR COURSE OF USAGE.  THE ENTIRE RISK 
ASSOCIATED WITH THE USE OF THE SOFTWARE IS ASSUMED BY YOU.  Some jurisdictions do not 
allow the exclusion of implied warranties, so the above exclusion may not apply to You. 

LIMITATION OF LIABILITY AND INDEMNIFICATION:  AMD AND ITS LICENSORS WILL NOT, 
UNDER ANY CIRCUMSTANCES BE LIABLE TO YOU FOR ANY PUNITIVE, DIRECT, INCIDENTAL, 
INDIRECT, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING FROM USE OF THE SOFTWARE OR THIS 
AGREEMENT EVEN IF AMD AND ITS LICENSORS HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGES.  In no event shall AMD's total liability to You for all damages, losses, and 
causes of action (whether in contract, tort (including negligence) or otherwise) 
exceed the amount of $100 USD.  You agree to defend, indemnify and hold harmless 
AMD and its licensors, and any of their directors, officers, employees, affiliates or 
agents from and against any and all loss, damage, liability and other expenses 
(including reasonable attorneys' fees), resulting from Your use of the Software or 
violation of the terms and conditions of this Agreement.  

U.S. GOVERNMENT RESTRICTED RIGHTS: The Materials are provided with "RESTRICTED RIGHTS." 
Use, duplication, or disclosure by the Government is subject to the restrictions as set 
forth in FAR 52.227-14 and DFAR252.227-7013, et seq., or its successor.  Use of the 
Materials by the Government constitutes acknowledgement of AMD's proprietary rights in them.

EXPORT RESTRICTIONS: The Materials may be subject to export restrictions as stated in the 
Software License Agreement.

## AOMP Install

<A NAME="Install">

### Debian/Ubunutu install

On Ubuntu 18.04 LTS (bionic beaver), run these commands:
```
wget https://github.com/ROCm-Developer-Tools/aomp/releases/download/rel_0.6-0/aomp_0.6-0_amd64.deb
sudo dpkg -P hcc2
sudo dpkg -P libamdgcn
sudo dpkg -P amdcloc
sudo dpkg -P mymcpu
sudo dpkg -i aomp_0.6-0_amd64.deb
```
The "dpkg -P" commands are used to delete previous versions of hcc2, libamdgcn, amdcloc, and mymcpu which may conflict with the installation.  If these are not installed it is ok to just let the "dpkg -P" commands fail.

The AOMP bin directory (which includes the standard clang and llvm binaries) is not intended to be in your PATH for typical operation.

### RPM Install
For rpm-based Linux distributions, use this rpm
```
wget https://github.com/ROCm-Developer-Tools/aomp/releases/download/rel_0.6-0/aomp-0.6-0.x86_64.rpm
sudo rpm -i aomp-0.6-0.x86_64.rpm
```

### No root Install

The current packages are built without listing dependencies.
By default, they install their content to the release directory /opt/rocm/aomp_0.X-Y and then a  symbolic link is created at /opt/rocm/aomp to the release directory. This requires root access.  You can use the --prefix option of the rpm install command to change the location so as not to require root access.

```
   wget https://github.com/ROCm-Developer-Tools/aomp/releases/download/rel_0.6-0/aomp-0.6-0.x86_64.rpm
   mkdir -p $HOME/rocm/aomp
   rpm -i aomp-0.6-0.x86_64.rpm --prefix=$HOME/rocm/aomp
```
Then permanently set the environment variable AOMP to $HOME/rocm/aomp.  For example in .bash_profile add the command 
```
   export AOMP=$HOME/rocm/aomp
```

### Source Install
Build and install from sources is possible.  However, the source build for AOMP is complex for several reasons.  
- Many repos are required.  The clone_aomp.sh script ensures you have all repos and the correct branch.
- Requires that both the Cuda SDK and ROCm are installed regardless of which graphic cards you have.
- It is a bootstrapped build. The built and installed LLVM compiler is used to build library components. 
- Additional package dependencies are required that are not required when installing the AOMP package. 

To build AOMP from source run these commands. 

```
   sudo apt-get install FIXME GET DEPS FIXME 
   sudo apt-get install cuda
   cd $HOME ; mkdir -p git/aomp ; cd git/aomp
   git clone https://github.com/rocm-developer-tools/aomp
   cd $HOME/git/aomp/aomp/bin
   git checkout master
   ./clone_aomp.sh
   ./build_aomp.sh
```
Depending on your system, the last two commands could take a very long time.

The source build process above builds the development version of AOMP by checking out the master branch of AOMP.   The development version is the next version to be released.  It is possible that the development version is broken due to regressions that often occur during development.  If you want to build from the sources of a previous release such as 0.6-0, run these commands before running clone_aomp.sh.
```
   git checkout rel_0.6.0
   git pull
```
You only need to do this in the aomp repository. The file "bin/aomp_common_vars" lists the branches of each repository for a particular aomp release. In the master branch of aomp, aomp_common_vars lists the development branches. It is a good idea to run clone_aomp.sh twice after you checkout a release to be sure you pulled all the checkouts for a particular release.

If your are interested in joining the development of AOMP, please read the details on the source build at [README](bin/README.md).


## AOMP Limitations

<A NAME="Limitations">

See the release notes in github.  Here are some limitations. 

```
 - Dwarf debugging is turned off for GPUs. -g will turn on host level debugging only.
 - Some simd constructs fail to vectorize on both host and GPUs.  
 - There are debug versions of the runtime libraries.  However, these use printf on the device
   which currently print when the kernel terminates.  So it is not a very useful debug feature if the GPU 
   kernel crashes. 
```