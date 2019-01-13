/*

Testing SIMD for .NET core

Output:
[0] Elapsed = 00:00:00.0588736 SIMD
[1] Elapsed = 00:00:00.1233100 NO SIMD
[0] Elapsed = 00:00:00.0611137 SIMD
[1] Elapsed = 00:00:00.1282144 NO SIMD
[0] Elapsed = 00:00:00.0640393 SIMD
[1] Elapsed = 00:00:00.1328272 NO SIMD
[0] Elapsed = 00:00:00.0598064 SIMD
[1] Elapsed = 00:00:00.1213708 NO SIMD
[0] Elapsed = 00:00:00.0621704 SIMD
[1] Elapsed = 00:00:00.1270899 NO SIMD
[0] Elapsed = 00:00:00.1129701 SIMD
[1] Elapsed = 00:00:00.1769870 NO SIMD
[0] Elapsed = 00:00:00.0589078 SIMD
[1] Elapsed = 00:00:00.1218389 NO SIMD
[0] Elapsed = 00:00:00.0593559 SIMD
[1] Elapsed = 00:00:00.1214641 NO SIMD
[0] Elapsed = 00:00:00.0621073 SIMD
[1] Elapsed = 00:00:00.1272637 NO SIMD
[0] Elapsed = 00:00:00.0615560 SIMD
[1] Elapsed = 00:00:00.1275641 NO SIMD

*/
using System;
using System.Numerics;
using System.Runtime.CompilerServices;
using System.Linq;
using System.Diagnostics;

namespace SimdAdd
{
    class SIMD
    {
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static void Add(ref int[] a, ref int[] b, out int[] result)
        {
            result = new int[a.Length];
            var simdLength = Vector<int>.Count;
            int i;
            for (i = 0; i <= a.Length - simdLength; i += simdLength) {
                var va = new Vector<int>(a, i);
                var vb = new Vector<int>(b, i);
                (va + vb).CopyTo(result, i);
            }
            for (; i < a.Length; ++i) {
                result[i] = a[i] + b[i];
            }
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            if (!Vector.IsHardwareAccelerated)
                throw new Exception("No hw acceleration available.");

            var rnd = new Random();
            var a = Enumerable.Repeat(0, 7680 * 4320).Select(i => rnd.Next(0, 20)).ToArray();
            var b = Enumerable.Repeat(0, 7680 * 4320).Select(i => rnd.Next(0, 20)).ToArray();
            Stopwatch sw = new Stopwatch();
            
            for (int x=0; x<10; x++)
            {
                sw.Start();
                SIMD.Add(ref a, ref b, out int[] result);
                sw.Stop();
                Console.WriteLine($"[0] Elapsed = {sw.Elapsed} SIMD");

                var result2 = new int[a.Length];
                sw.Start();
                for (int i = 0; i < a.Length; i++)
                    result2[i] = a[i] + b[i];
                sw.Stop();
                Console.WriteLine($"[1] Elapsed = {sw.Elapsed} NO SIMD");
            }
            Console.ReadKey();
        }
    }
}
