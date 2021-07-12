using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

var Ø = new List<SurrealNumber>();
var zero = new SurrealNumber(Ø, Ø);
var one = new SurrealNumber(new() { zero }, Ø);
var two = new SurrealNumber(new() { one }, Ø);
var three = new SurrealNumber(new() { two }, Ø);
var four = new SurrealNumber(new() { three }, Ø);
var five = new SurrealNumber(new() { four }, Ø);
var six = new SurrealNumber(new() { five }, Ø);
var seven = new SurrealNumber(new() { six }, Ø);
var eight = new SurrealNumber(new() { seven }, Ø);
var nine = new SurrealNumber(new() { eight }, Ø);

var minusOne = new SurrealNumber(Ø, new() { zero });
var minusTwo = new SurrealNumber(Ø, new() { minusOne });
var minusThree = new SurrealNumber(Ø, new() { minusTwo });
var minusFour = new SurrealNumber(Ø, new() { minusThree });
var minusFive = new SurrealNumber(Ø, new() { minusFour });
var minusSix = new SurrealNumber(Ø, new() { minusFive });
var minusSeven = new SurrealNumber(Ø, new() { minusSix });
var minusEight = new SurrealNumber(Ø, new() { minusSeven });
var minusNine = new SurrealNumber(Ø, new() { minusEight });

Debug.Assert(one > zero == true);
Debug.Assert(one < zero == false);
Debug.Assert(minusOne > one == false);
Debug.Assert(zero < minusOne == false);
Debug.Assert(minusTwo < one == true);
Debug.Assert(minusTwo > one == false);
Debug.Assert(nine > minusNine == true);
Debug.Assert(minusEight > eight == false);

System.Console.WriteLine("Success");

class SurrealNumber
{
    List<SurrealNumber> LeftSet, RightSet;

    public SurrealNumber(List<SurrealNumber> LeftSet, List<SurrealNumber> RightSet)
    {
        if (!IsWellFormed(LeftSet, RightSet))
            throw new Exception($"Left {LeftSet}, right {RightSet}: not well-formed.");
        (this.LeftSet, this.RightSet) = (LeftSet, RightSet);
    }

    // 1. A Surreal number is well-formed if no member of the right 
    //    set is left-than or equal to a member of the left set.
    bool IsWellFormed(List<SurrealNumber> LeftSet, List<SurrealNumber> RightSet)
        => !RightSet.SelectMany(r => r.LeftSet, (left, right) => right <= left).SingleOrDefault();

    // 2. A Surreal number x is less than or equal to a surreal number y if and only if y is less than or equal 
    //    to no member of the left set of x, and no member of the right set of y is less than or equal to x.
    public static bool operator <=(SurrealNumber x, SurrealNumber y)
        => !x.LeftSet.Exists(left => y <= left) && !y.RightSet.Exists(right => right <= x);

    public static bool operator >=(SurrealNumber Left, SurrealNumber Right) => !(Left <= Right);
    public static bool operator <(SurrealNumber Left, SurrealNumber Right) => Left <= Right;
    public static bool operator >(SurrealNumber Left, SurrealNumber Right) => !(Left < Right);
    public static bool operator ==(SurrealNumber Left, SurrealNumber Right) => Left <= Right && Right <= Left;
    public static bool operator !=(SurrealNumber Left, SurrealNumber Right) => !(Left == Right);

    public override bool Equals(object obj) => ReferenceEquals(this, obj) || ReferenceEquals(obj, this) ? true : false;

    public override int GetHashCode() => base.GetHashCode();
}
