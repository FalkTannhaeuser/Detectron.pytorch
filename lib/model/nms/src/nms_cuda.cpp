#include <THC/THC.h>
extern "C" {
#include "nms_cuda.h"
}
#include <ATen/ATen.h>
#include <stdio.h>
#include "nms_cuda_kernel.h"

THCState *state = at::globalContext().getTHCState();

int nms_cuda(THCudaIntTensor *keep_out, THCudaTensor *boxes_host,
		     THCudaIntTensor *num_out, float nms_overlap_thresh) {

    nms_cuda_compute(THCudaIntTensor_data(state, keep_out),
                     THCudaIntTensor_data(state, num_out),
                     THCudaTensor_data(state, boxes_host),
                     THCudaTensor_size(state, boxes_host, 0),
                     THCudaTensor_size(state, boxes_host, 1),
                     nms_overlap_thresh);

	return 1;
}
