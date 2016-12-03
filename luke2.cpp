/*
https://julekalender.knowit.no/luker/qTYR3HY7HjTPmoLgq

Output:
+ 1.48561e+09
2.35e+08 iterations run in 8.17514e+09ns total, average : 34.7878ns.

Code:
*/
#include <iostream>
#include <chrono>
#include <cmath>
int main()
{
    auto begin = std::chrono::high_resolution_clock::now();

    double i, sum, fib, run;
    for (run = 0; run < 1e6; run++)
    {
        for (i = sum = fib = 0; fib < 13e8; sum += ((int)fib & 1) ? fib : 0, (fib = floor(pow((1 + sqrt(5)) / 2, i++) / sqrt(5) + 0.5)));
    }

    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin).count();
    std::cout << "+ " << sum << std::endl;
    std::cout << (i*run) << " iterations run in " << duration << "ns total, average : " << duration / (i*run) << "ns." << std::endl;

    return 0;
}
