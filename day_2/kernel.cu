#include <iostream>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__device__ float square(int x)
{
	return x * x *x;
	//__device__ marked fucntion can only be called from another device fucntion
	// or a kernel mathod
}

__global__ void voidKernel(int* input, int* output, int N) {
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if (i < N)
	{
		output[i] = square(input[i]);
	}
}


int main()
{
	int N = 10;
	int size = N * sizeof(int);
	int *h_input = new int[N];
	int *h_output = new int[N];

	for (int i = 0; i < N; i++) {
		h_input[i] = i + 1;
	}

	int* d_input, * d_output;
	cudaMalloc((void**)&d_input, size);
	cudaMalloc((void**)&d_output, size);
	cudaMemcpy(d_input, h_input, size, cudaMemcpyHostToDevice);

	int threadsPerBlock = 256;
	int blockGrid = (N + threadsPerBlock - 1) / threadsPerBlock;
	voidKernel <<<blockGrid, threadsPerBlock >>> (d_input, d_output, N);
	cudaMemcpy(h_output, d_output, size, cudaMemcpyDeviceToHost);

	std::cout << "squred array:";
	for (int i = 0; i < N; i++)
	{
		std::cout << h_output[i] << " ";

	}
	std::cout << std::endl;

	delete[] h_input;
	delete[] h_output;
	cudaFree(d_input);
	cudaFree(d_output);

	return 0;




}
