#include <iostream>
#include<cuda_runtime.h>
#include<device_launch_parameters.h>

// small kernal for writing the addition of the vectors in the cuda 
__global__ void vectorAdd(const float* A, const float* B, float* C, int N) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if (idx < N)
	{
		C[idx] = A[idx] + B[idx];
	}
}

int main()
{ 
	// The number of variable or the size of the array
	const int N = 1024;
	const int size = N * sizeof(int);

	//The host address where we are going to store the data 
	float *h_A = new float[N];
	float *h_B = new float[N];
	float* h_C = new float[N];

	// assigning those value sin the hoset memory gpu memory
	for (int i = 0; i < N; i++)
	{
		h_A[i] = 1;
		h_B[i] = 1;
	}

	//pointers for the gpu memory 
	float* d_A, * d_B, * d_C;


	//allocationg the gpu memory
	cudaMalloc((void**)&d_A, size);
	cudaMalloc((void**)&d_B, size);
	cudaMalloc((void**)&d_C, size);

	

	//copy input data from the host to the device
	cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

	//The number of blocks and the threads
	int threadsperBlock = 256;
	int blocksPerGrid = (N + threadsperBlock - 1) / threadsperBlock;

	//the vector kernel addition
	vectorAdd <<< blocksPerGrid, threadsperBlock >>>(d_A, d_B, d_C, N);

	cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

	for (int i = N - 10; i < N; i++)
	{
		std::cout << "C[" << i << "]=" << h_C[i] << std::endl;

	}
	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);

	delete[] h_A;
	delete[] h_B;
	delete[] h_C;
    
	return 0;





}