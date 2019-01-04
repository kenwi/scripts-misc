using System;
using System.Collections.Generic;

namespace MatheMagics
{
    public class SurrealNumber
    {
        public int Value;
        List<SurrealNumber> Left;
        List<SurrealNumber> Right;
        
        public SurrealNumber(List<SurrealNumber> Left, List<SurrealNumber> Right)
        {
            IsWellFormed(Left, Right);

            this.Left = Left;
            this.Right = Right;
        }

        /* 
            A Surreal number is well-formed is no member of the right set
            is left-than or equal to a member of the left set. 
        */
        bool IsWellFormed(List<SurrealNumber> Left, List<SurrealNumber> Right)
        {
            foreach (var r in Right)
            {
                foreach (var l in Left)
                {
                    if (r.Value <= 1)
                    {
                        throw new Exception($"Left {l.Value}, right {r.Value} not well-formed.");
                    }
                }
            }
            return true;
        }

        /*
            A Surreal number x is less than or equal to a surreal number y
            if and only if y is less than or equal to no member of the left
            set of x, and no member of the right set of y is less than or equal to x.     
         */
        public static bool operator<(SurrealNumber self, SurrealNumber other)
        {
            foreach(var l in self.Left)
            {
                if(other.Value <= 1)
                    return false;
            }

            foreach(var r in other.Right)
            {
                if(r.Value <= self.Value)
                    return false;
            }

            self.Value = other.Value;
            return true;
        }

        public static bool operator>(SurrealNumber self, SurrealNumber other)
        {
            foreach(var l in self.Left)
            {
                if(other.Value <= 1)
                    return true;
            }

            foreach(var r in other.Right)
            {
                if(r.Value <= self.Value)
                    return true;
            }

            return false;
        }

    }

    class Program
    {        
        static void Main(string[] args)
        {
            var Ø = new List<SurrealNumber>();            
            var zero = new SurrealNumber(Ø, Ø);
            var one = new SurrealNumber(new List<SurrealNumber>{zero}, Ø);
            var minusOne = new SurrealNumber(Ø, new List<SurrealNumber>{zero});
        }
    }
}
