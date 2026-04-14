#include <stdio.h>
#include <iostream>

int main()
{

	//int distance = 10;

	////& is for the address of the variable , * is like pointer that points the variable using this & is called referece of the variable 
	//int* ptr1 = &distance;
	//std::cout << "address of the pointer ::" << ptr1 << std::endl;

	int payment = 10;
	int *p = &payment;

	// again using the * is for the deferece of the variable so that we can directly modify the value inside that address
	*p = 15;
	std::cout << "value of the pointer variable p by deferencing::" << *p << std::endl;
	std::cout << "value of the payment::" << payment<< std::endl;

	int distance = 250, fuel=10;
	float economy1, economy2;
	int* pd, * pf;
	pd = &distance;
	*pd = *pd + 10;
	pf = &fuel;

	*pf += 5;
	economy1 = distance / fuel;

	//this is like &address of the econmy and we are dererececing it mena it becoem the economy variable agin and we are using it for changing it
	*(&economy2) = economy1 / 15;

	std::cout << "EConomy1::" << economy1 << std::endl;
	std::cout << "economy2::" << economy2 << std::endl;

	int *PA = (int*)malloc(5*sizeof(int));

	int *bigspace = (int*)malloc(20 * sizeof(int));
	//derefereccing the first element in the array so that we can intialize the value in it 
	*bigspace = 10;
	*(bigspace + 1) = 20;
	*(bigspace + 2) = 30;

	long* bigints = (long*)malloc(100*sizeof(long));

	for (int i = 0; i < 100; i++, bigints++)
	{
		*bigints = 0;
	}

	//this because we are poinitng the values from the address so that the pointer changes the value from pointning the first element ot the some other element so we
	// subtracting with the size so that it will point only the first elememt in the array 
	bigints -= 100;

	int space1[20];
	int* space2 = space1;

	*space1 = 10;


	std::cout << "value of the space1" << *space1 << std::endl;
	

	space2[1] = 20;
	std::cout << "value of the space2" << *(space1+1) << std::endl;

	//This double pointer for accessing the elements in the multidimentional array 
	long table[10][20];
	long (*ptr )[20] = table;
	long** ptr_1 = new long* [10];

	long* racing = (long*)malloc(40 * sizeof(long));







	 

	return 0;
}
