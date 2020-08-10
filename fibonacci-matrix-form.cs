using System.Text;
using MathNet.Numerics.LinearAlgebra.Double;

namespace fibs
{
    class Program
    {
        static void Main(string[] args)
        {
            var nth = 5;
            var m0 = DenseMatrix.OfArray(new[,] { { 1.0, 1.0 }, { 1.0, 0.0 } });
            var m1 = m0.Power(nth + 1);

            var fib = m1[1, 1];
            var sum = m1[0, 0] - 1;
            System.Console.WriteLine($"The n={nth} f(n) fibonacci number is {fib} and the sum from 1 to {nth} included, is {sum}");

            StringBuilder output = new StringBuilder();
            var v0 = DenseVector.OfArray(new [] { 0.0, 1.0 });
            for (; v0[0] < 1e16; output.Append($"{(v0 *= m0)[0]} "));
            System.Console.WriteLine(output);
        }
    }
}
