/*
https://julekalender.knowit.no/luker/qTYR3HY7HjTPmoLgq

Oppgave:
Fibonaccirekken er en tallrekke som genereres ved at man adderer de to foregående tallene i rekken. f.eks. 
om man starter med 1 og 2 blir de første 10 termene 1, 1, 2, 3, 5, 8, 13, 21, 34 og 55
Finn summen av alle partall i denne rekken som er mindre enn 4.000.000.000

Resultat:
= 1.48561e+09
2.35e+08 iterations run in 8.17514e+09ns total, average : 34.7878ns.

Løsning:
*/
#include <iostream>
#include <chrono>
#include <cmath>
int main()
{
    auto begin = std::chrono::high_resolution_clock::now();

    double i, sum, fib, run;
    for (run = 0; run < 5e6; run++)
    {
        for (i = fib = 0; fib < 13e8; (fib += floor(pow((1 + sqrt(5)) / 2, i+=3) / sqrt(5) + 0.5)));
    }

    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin).count();
    std::cout << "= " << sum << std::endl;
    std::cout << (i*run) << " iterations run in " << duration << "ns total, average : " << duration / (i*run) << "ns." << std::endl;

    return 0;
}
