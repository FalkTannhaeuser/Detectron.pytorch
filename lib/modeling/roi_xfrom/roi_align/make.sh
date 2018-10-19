#!/usr/bin/env bash

if [ $(uname -o) != "Cygwin" ] ; then
    CUDA_PATH=/usr/local/cuda/
    Xcompiler_opt=-fPIC
else
    echo "Using system-wide CUDA_PATH=$CUDA_PATH"
    Xcompiler_opt=/MD
fi

cd src
echo "Compiling my_lib kernels by nvcc..."
nvcc -c -o roi_align_kernel.cu.o roi_align_kernel.cu -x cu -Xcompiler $Xcompiler_opt -arch=sm_61

cd ../
python build.py
