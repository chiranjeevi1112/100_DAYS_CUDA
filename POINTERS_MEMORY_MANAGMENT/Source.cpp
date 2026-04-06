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

	int *PT = (int*)malloc(sizeof(int));

		

	return 0;
}
