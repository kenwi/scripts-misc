/*
OUTPUT: 
1 0
2 0.25
3 0.33300532016668060730779643563437
4 0.30575397266460024869871858754777
5 0.24044479776877564214387916763371
6 0.17561526812584971057873417521478
7 0.12463963518891081616590810199341
8 0.088859286896382921883130734386214
9 0.065394879566305935680858851810626
10 0.050690208684453438858774632080895
..
65 0.029445086917308672253001944341122
66 0.029445086917308668783554992387508
67 0.029445086917308665314108040433894

Che: 0.029445086917308665314108040433894
Euler Gamma: 0.57721566490153286554942724251305
Inverse alpha: 0.16025980299670170015069459168444
Fine structure constant (1/alpha): 6.2398678976323269651516056910623

https://drive.google.com/file/d/1WPsVhtBQmdgQl25_evlGQ1mmTQE0Ww4a/view 

Implementation is probably wrong (on my end (as well?)) 
and clearly outputs the wrong constant. */

#include <iostream>
#include <cmath>

int main() {
	std::cout.precision(32);
	const auto che = ([](const int iterations)
	{
		double sum = 0, previous = 0;
		for (double j = 1; j <= 100; j++)
		{
			std::cout << j << " " << sum / 2 << std::endl;
			
			const double integral = ((j + 1 / j)  * log(j) - j + 1 / j) / log(2);
			sum += pow(2, -j) * (1 - integral);
			
			if (sum == previous)
				break;
			previous = sum;
		}
		return sum / 2; 
	});

	double π = 3.14159265358979323846264338327950;
	double Ч = che(100);
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
