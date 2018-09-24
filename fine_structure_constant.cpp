/*
OUTPUT: 

1 0.25
2 0.4856737602222408467511627
3 0.5214986115037046898734729
4 0.4830854916148251132490543
...
12 0.2974209407321649067945657
...
56 0.2934900048873357869538836
57 0.2934900048873348987754639
58 0.293490004887334454686254
59 0.2934900048873342326416491
60 0.2934900048873341216193467
61 0.2934900048873340661081954
62 0.2934900048873340105970442
63 0.2934900048873340105970442
...
100 0.2934900048873340105970442

Che: 0.2934900048873340105970442
Euler Gamma: 0.5772156649015328655494272
Inverse alpha: 1.597368365623565100719361
Fine structure constant (1/alpha): 0.6260296757596234273890445

https://drive.google.com/file/d/1WPsVhtBQmdgQl25_evlGQ1mmTQE0Ww4a/view 

Implementation is probably wrong (on my end (as well?)) 
and clearly outputs the wrong constant. */

#include <iostream>
#include <cmath>

int main() {
	std::cout.precision(25);
	/*
		Ч/γ = Ж/π
		Ч = Ж/π * γ
	*/
	auto che = ([](int iterations, double(integral)(int j) )
	{
		long double sum = 0, previous = 0;
		for (int j = 1; j <= iterations; ++j)
		{
			sum += pow(2, -j) * (1 - integral(j));
			if (sum == previous) {
				std::cout << "Completed" << std::endl;
				break;
			}
			std::cout << j << " " << sum / 2 << std::endl;
			previous = sum;
		}
		return sum / 2; 
	});

	auto integral = ([](int j) { return ((j + 1 / j)  * log(j) - j + 1 / j) / log(2); });
	double π = 3.14159265358979323846264338327950;
	double Ч = che(100, integral);
	double γ = 0.5772156649015328606065120900824024310421;
	double α = Ч * π / γ;
	double Ж = 1 / α;

	std::cout <<std::endl;
	std::cout << "Che: "  << Ч << std::endl;
	std::cout << "Euler Gamma: " << γ << std::endl;
	std::cout << "Inverse alpha: " << α << std::endl;
	std::cout << "Fine structure constant (1/alpha): " << Ж << std::endl;

	return 0;
}
