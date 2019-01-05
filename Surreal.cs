using System;
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
            IsWellFormed(LeftSet, RightSet);
            this.LeftSet = LeftSet;
            this.RightSet = RightSet;
        }

        /* 
            A Surreal number is well-formed is no member of the right set
            is left-than or equal to a member of the left set. 
        */
        bool IsWellFormed(List<SurrealNumber> LeftSet, List<SurrealNumber> RightSet)
        {
            foreach (var r in RightSet)
            {
                foreach (var l in LeftSet)
                {
                    if (l == r)
                        throw new Exception($"Left {l}, right {r} not well-formed.");
                }
            }
            return true;
        }

        /*
            A Surreal number x is less than or equal to a surreal number y
            if and only if y is less than or equal to no member of the left
            set of x, and no member of the right set of y is less than or equal to x.     
         */
        public static bool operator <=(SurrealNumber x, SurrealNumber y)
        {
            foreach (var l in x.LeftSet)
                if (y <= l)
                    return false;
            foreach (var r in y.RightSet)
                if (r <= x)
                    return false;
            return true;
        }
        public static bool operator >=(SurrealNumber x, SurrealNumber y) => !(x <= y);
        public static bool operator <(SurrealNumber x, SurrealNumber y) => x <= y;
        public static bool operator >(SurrealNumber x, SurrealNumber y) => !(x < y);
    }

    class Program
    {
        static void Main(string[] args)
        {
            var Ø = new List<SurrealNumber>();
            var zero = new SurrealNumber(Ø, Ø);
            var zero2 = new SurrealNumber(Ø, Ø);

            Debug.Assert(zero > zero2 == false);
            Debug.Assert(zero < zero2 == true);

            var one = new SurrealNumber(new List<SurrealNumber> { zero }, Ø);
            Debug.Assert(one > zero == true);
            Debug.Assert(one < zero == false);

            var minusOne = new SurrealNumber(Ø, new List<SurrealNumber> { zero });
            Debug.Assert(minusOne > one == false);
            Debug.Assert(zero < minusOne == false);

            var minusTwo = new SurrealNumber(Ø, new List<SurrealNumber> { minusOne });
            Debug.Assert(minusTwo < one == true);
            Debug.Assert(minusTwo > one == false);
        }
    }
}
