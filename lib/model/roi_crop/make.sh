#!/usr/bin/env bash

if [ $(uname -o) == "Cygwin" ] || [ $(uname -o) == "Msys" ] ; then
    if [ -z "$CUDA_PATH" ] ; then
        echo "Can't find CUDA_PATH - check your Nvidia CUDA istallation!"
        exit 1
    fi
    echo "Using system-wide CUDA_PATH=$CUDA_PATH"
	if [ $(uname -o) == "Msys" ] ; then
		# Git Bash misinterprets single /
		Xcompiler_opt=//MD
	else
		Xcompiler_opt=/MD
	fi
else
    CUDA_PATH=/usr/local/cuda/
    Xcompiler_opt=-fPIC
fi

cd src
echo "Compiling my_lib kernels by nvcc..."
nvcc -c -o roi_crop_cuda_kernel.cu.o roi_crop_cuda_kernel.cu -x cu -Xcompiler $Xcompiler_opt -arch=sm_52

cd ../
python build.py
