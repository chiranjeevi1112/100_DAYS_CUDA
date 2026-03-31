
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <chrono>
#include <stdio.h>
#include <iostream>


//void matrix_MUL_CPU(float* M, float* N, float* P, int M_width)
//{
//    for (int i=0;i<width;++i)
//        for (int j = 0; j < width; ++j)
//        {
//
//            float sum = 0;
//            for (int k = 0; k < width; ++k)
//            {
//                float a = M[i * width + k];
//                float b = N[k * width + j];
//                sum += a * b;
//            }
//            P[i * width + j] = sum;
//
//        }
//}

void matrix_MUL_CPU(float* M, float* N, float* P, const int M_width, const int N_width, const int P_width)
{
    for (int i = 0; i < M_width; ++i)
    {
        for (int j = 0; j < N_width; ++j)
        {
            float sum = 0;
            for (int k = 0; k < P_width; ++k)
            {
                float a = M[i * M_width + k];
                float b = N[k * N_width + j];  
                sum += a * b;
            }
            P[i * P_width + j] = sum;
        }
    }
    //for (int l = 0; l < P_width * P_width; l++)
    //{
    //    std::cout <<"P:" << P[l] << "\n";
    //}
}

__global__ void addKernel(int *c, const int *a, const int *b)
{
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}

__global__ void MatrixMulKernel(float* Md, float* Nd, float* Pd, int width)
{
    // 2D thread ID
    int tx = threadIdx.x;
    int ty = threadIdx.y;

    //Pvalue stores the Pd element that is compute by the thread
    float Pvalue = 0;
    for (int k = 0; k < width; ++k)
    {
        float Mdelement = Md[ty * width + k];
        float Ndelement = Nd[k * width + tx];
        Pvalue += Mdelement * Ndelement;

    }
    //matrix to device memory each thread writes one element
    Pd[ty * width + tx] = Pvalue;
}

void MatrixMultiplication(float* M, float* N, float* P, int widthX,int widthY) {




    int size = widthX * widthY * sizeof(float);
    int matrixBytes = sizeof(float) * size;
    float *Md, *Nd, *Pd;

    auto startCPU = std::chrono::high_resolution_clock::now();
    matrix_MUL_CPU(M, N, P, widthX,widthY,widthX);
    auto endCPU = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> CPUDURATION = endCPU - startCPU;

    //Transfer M and N to device memory
    cudaMalloc((void**)&Md, size);
    cudaMemcpy(Md, M, size, cudaMemcpyHostToDevice);
    cudaMalloc((void**)&Nd, size);
    cudaMemcpy(Nd, N, size, cudaMemcpyHostToDevice);
    //Allocate P on the device
    cudaMalloc((void**)&Pd, size);

    int BLOCK_SIZE = 1024;
    dim3 blockDim(BLOCK_SIZE, BLOCK_SIZE);
    dim3 gridDim((size + BLOCK_SIZE - 1) / BLOCK_SIZE, (size + BLOCK_SIZE - 1) / BLOCK_SIZE);

    auto startCUDA = std::chrono::high_resolution_clock::now();
    MatrixMulKernel<<<gridDim, blockDim>>>(Md, Nd, Pd, size);
    cudaDeviceSynchronize();
    auto endCUDA = std::chrono::high_resolution_clock::now();
    cudaMemcpy(P, Pd, matrixBytes, cudaMemcpyDeviceToHost);
    //std::chrono::duration<double> cpuDuration = endCPU - startCPU;
    
    std::chrono::duration<double> cudaDuration = endCUDA - startCUDA;


    //free device matrices
    cudaFree(Md); 
    cudaFree(Nd); 
    cudaFree(Pd);
    std::cout << "CUDA Execution Time: " << cudaDuration.count() << " seconds\n";
    std::cout << "CPU EXecution Time:" << CPUDURATION.count() << "seconds\n";

}
int main()
{
    //const int arraySize = 5;
    //const int a[arraySize] = { 1, 2, 3, 4, 5 };
    //const int b[arraySize] = { 10, 20, 30, 40, 50 };
    //int c[arraySize] = { 0 };

    //// Add vectors in parallel.
    //cudaError_t cudaStatus = addWithCuda(c, a, b, arraySize);
    //if (cudaStatus != cudaSuccess) {
    //    fprintf(stderr, "addWithCuda failed!");
    //    return 1;
    //}

    //printf("{1,2,3,4,5} + {10,20,30,40,50} = {%d,%d,%d,%d,%d}\n",
    //    c[0], c[1], c[2], c[3], c[4]);

    //// cudaDeviceReset must be called before exiting in order for profiling and
    //// tracing tools such as Nsight and Visual Profiler to show complete traces.
    //cudaStatus = cudaDeviceReset();
    //if (cudaStatus != cudaSuccess) {
    //    fprintf(stderr, "cudaDeviceReset failed!");
    //    return 1;
    //}

    //return 0;


    const int sizeX = 32 * 16;
    const int sizeY = 32* 16;
    const int sizeP = 32* 16;
    //const int size = 1024 * 16;
    const int matrixSize = sizeX * sizeY;

    float* cpu_A = new float[matrixSize];
    float* cpu_B = new float[matrixSize];
    float* cpu_C = new float[matrixSize];

    for (int i = 0; i < matrixSize; i++) {
        cpu_A[i] = 10.0f;
        cpu_B[i] = static_cast<float>(i);
    }
    MatrixMultiplication(cpu_A, cpu_B, cpu_C, sizeX,sizeY);

    //matrix_MUL_CPU(cpu_A, cpu_B, cpu_C, sizeX, sizeY, sizeP);

    /*for (int i = 0; i < matrixSize; ++i)
    {
        std::cout << cpu_A[i] << "\n";
        std::cout << cpu_B[i] << "\n";
    }*/

    delete[] cpu_A;
    delete[] cpu_B;
    delete[] cpu_C;

    return 0;


}

