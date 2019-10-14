// http://mathworld.wolfram.com/UniformSumDistribution.html
// Converges to the number e

namespace UniformSUmDistribution
{
    class Program 
    {
        static void Main(string[] args) 
        {
            var rng = new Random();
            double a = 0, b = 0;
            while(true) 
            {
                double x = 0, t = 0;
                while(x < 1.0) 
                {
                    x += rng.NextDouble();
                    t += 1.0;
                }
                a += t;
                b += 1.0;
                Console.WriteLine(a / b);
            }
        }
    }
}
