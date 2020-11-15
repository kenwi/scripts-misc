namespace fibs
{
    using System;
    using System.Text;
    using MathNet.Numerics.LinearAlgebra.Double;

    class Program
    {
        static void Main(string[] args)
        {
            System.Console.WriteLine(@"Fibonaccirekken er en tallrekke som genereres ved at man adderer de to foregående tallene i rekken. f.eks. om man starter med 1 og 2 blir de første 10 termene 1, 1, 2, 3, 5, 8, 13, 21, 34 og 55 
Finn summen av alle partall i denne rekken som er mindre enn 4.000.000.000" + Environment.NewLine);

            var limit = 100;
            var phi = (1 + Math.Sqrt(5)) * 0.5;
            var nth = (int)Math.Floor((Math.Log(limit + 0.5) + (0.5 * Math.Log(5))) / Math.Log(phi));
            var m0 = DenseMatrix.OfArray(new[,] { { 1.0, 1.0 }, { 1.0, 0.0 } });
            var m1 = m0.Power(nth + 1);
            var fib = m1[1, 1];

            System.Console.WriteLine($"Fibonacci-tall nr. {nth} er {fib}, og summen av alle fibonacci partall opp til {limit}, er {(fib - 1) * 0.5}.");
        }
    }
}
