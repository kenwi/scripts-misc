using System;
using System.Linq;
using System.Collections.Generic;
using System.Diagnostics;

namespace MatheMagics
{
    public class SurrealNumber
    {
        List<SurrealNumber> LeftSet;
        List<SurrealNumber> RightSet;

        public SurrealNumber(List<SurrealNumber> LeftSet, List<SurrealNumber> RightSet)
        {
            if(!IsWellFormed(LeftSet, RightSet))
                throw new Exception($"Left {LeftSet}, right {RightSet}: not well-formed.");
            this.LeftSet = LeftSet;
            this.RightSet = RightSet;
        }
        
        // 1. A Surreal number is well-formed if no member of the right set is left-than or equal to a member of the left set.
        bool IsWellFormed(List<SurrealNumber> LeftSet, List<SurrealNumber> RightSet) => !RightSet.SelectMany(r => r.LeftSet, (left, right) => right <= left).SingleOrDefault();
        
        // 2. A Surreal number x is less than or equal to a surreal number y if and only if y is less than or equal to no member of the left
        //    set of x, and no member of the right set of y is less than or equal to x.
        public static bool operator <=(SurrealNumber x, SurrealNumber y) => !x.LeftSet.Exists(left => y <= left) && !y.RightSet.Exists(right => right <= x);

        public static bool operator >=(SurrealNumber Left, SurrealNumber Right) => !(Left <= Right);
        public static bool operator <(SurrealNumber Left, SurrealNumber Right) => Left <= Right;
        public static bool operator >(SurrealNumber Left, SurrealNumber Right) => !(Left < Right);
        public static bool operator ==(SurrealNumber Left, SurrealNumber Right) => Left <= Right && Right <= Left;
        public static bool operator !=(SurrealNumber Left, SurrealNumber Right) => !(Left == Right);
    }

    class Program
    {
        static void Main(string[] args)
        {
            var Ø = new List<SurrealNumber>();

            var zero = new SurrealNumber(Ø, Ø);
            var one = new SurrealNumber(new List<SurrealNumber> { zero }, Ø);
            var two = new SurrealNumber(new List<SurrealNumber> { one }, Ø);
            var three = new SurrealNumber(new List<SurrealNumber> { two }, Ø);
            var four = new SurrealNumber(new List<SurrealNumber> { three }, Ø);
            var five = new SurrealNumber(new List<SurrealNumber> { four }, Ø);
            var six = new SurrealNumber(new List<SurrealNumber> { five}, Ø);
            var seven = new SurrealNumber(new List<SurrealNumber> { six }, Ø);
            var eight = new SurrealNumber(new List<SurrealNumber> { seven }, Ø);
            var nine = new SurrealNumber(new List<SurrealNumber> { eight }, Ø);

            var minusZero = new SurrealNumber(Ø, Ø);
            var minusOne = new SurrealNumber(Ø, new List<SurrealNumber> { minusZero });            
            var minusTwo = new SurrealNumber(Ø, new List<SurrealNumber> { minusOne });            
            var minusThree = new SurrealNumber(Ø, new List<SurrealNumber> { minusTwo });
            var minusFour = new SurrealNumber(Ø, new List<SurrealNumber> { minusThree });
            var minusFive = new SurrealNumber(Ø, new List<SurrealNumber> { minusFour });
            var minusSix = new SurrealNumber(Ø, new List<SurrealNumber> { minusFive });
            var minusSeven = new SurrealNumber(Ø, new List<SurrealNumber> { minusSix });
            var minusEight = new SurrealNumber(Ø, new List<SurrealNumber> { minusSeven });
            var minusNine = new SurrealNumber(Ø, new List<SurrealNumber> { minusEight });
            
            Debug.Assert(one > zero == true);
            Debug.Assert(one < zero == false);
            Debug.Assert(minusOne > one == false);
            Debug.Assert(zero < minusOne == false);
            Debug.Assert(minusTwo < one == true);
            Debug.Assert(minusTwo > one == false);
            Debug.Assert(nine > minusNine == true);
            Debug.Assert(minusEight > eight == false);

            Debug.Assert(zero > minusZero == false);
            Debug.Assert(zero < minusZero == true);
            Debug.Assert(zero == minusZero);
        }
    }
}
