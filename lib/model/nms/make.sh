#!/usr/bin/env bash

if [ $(uname -o) != "Cygwin" ] ; then
    CUDA_PATH=/usr/local/cuda/
    Xcompiler_opt=-fPIC
else
    echo "Using system-wide CUDA_PATH=$CUDA_PATH"
    Xcompiler_opt=/MD
fi

cd src
echo "Compiling stnm kernels by nvcc..."
nvcc -c -o nms_cuda_kernel.cu.o nms_cuda_kernel.cu -x cu -Xcompiler $Xcompiler_opt -arch=sm_52

cd ../
python build.py
