/*
This program is and adaptation of CSS algorithm for a C++ programming course

Check original work at https://github.com/SamuelJansen/Prime-Numbers/
*/

//- Libraries
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

//- Global constant
#define Size 100000

//- Function prototype
int BoleanPrime(int Input);

//- Function definition
int BoleanPrime(int Input){
	//- Setting Variables
	bool PrimeMatrix[Size];
	int P[Size], n=0;
	int i=0, j=0;
	float SquareRootInput=0.0;
	
	//- Matrix initial values step
	for ( i=0 ; i<Size ; i++ ){
		PrimeMatrix[i]=true;
	}	
	
	//- Processing data	
	SquareRootInput = int(pow(Input, 1.0/2.0));
	for ( i=1 ; i<=SquareRootInput ; i++ ){
		if (PrimeMatrix[i]){
			n++;
			P[n] = i+1;
			for ( j=P[n] ; j*P[n]<=Input ; j++ ){ //it's not the really really good choice, but it's good enough
				PrimeMatrix[j*P[n]-1] = false;
			}
		}
	}
	
	//- Data return
	return PrimeMatrix[Input-1];
}

int main ()
{
//- Setting variables
int Input=0;

//- Input User
printf("  This program can verify if a number is prime or not\n");
printf("  since it's inside the interval I=[1,%d]\n",Size);
printf("  due to either C or machine constrains.\n");
printf("  (Probably C, as this seems to be the maximum size of a bolean vector in C)\n\n");
printf("  Write the number you would like to check if it's a prime number or not: ");
scanf("%d", &Input);

//- Output User
printf("\n\n");
if (BoleanPrime(Input)) //- FUNCTION CALL HERE!
{
	printf("  %d is a prime number.",Input);
} 
else
{
	printf("  %d is a not prime number.",Input);
}
printf("\n\n");
}
