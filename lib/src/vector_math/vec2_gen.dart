/*
  Copyright (C) 2013 John McCutchan <john@johnmccutchan.com>
  
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/
part of vector_math;
class vec2 {
  double x;
  double y;
  /// Constructs a new [vec2]. Follows GLSL constructor syntax so many combinations are possible
  vec2([dynamic x_, dynamic y_]) {
    x = y = 0.0;
    if (x_ is vec2) {
      xy = x_.xy;
      return;
    }
    if (x_ is num && y_ is num) {
      x = x_.toDouble();
      y = y_.toDouble();
      return;
    }
    if (x_ is num) {
      x = y = x_.toDouble();
      return;
    }
  }
  /// Constructs a new [vec2] zero vector.
  vec2.zero() { makeZero(); }
  /// Make [this] the zero vector.
  vec2 makeZero() {
    x = 0.0;
    y = 0.0;
    return this;
  }
  /// Constructs a copy of [other].
  vec2.copy(vec2 other) {
    makeCopy(other);
  }
  /// Make [this] a copy of [other] [other].
  vec2 makeCopy(vec2 other) {
    x = other.x;
    y = other.y;
    return this;
  }
  /// Constructs a new [vec2] that is initialized with passed in values.
  vec2.raw(num x_, num y_) {
    makeRaw(x_, y_);
  }
  /// Components of [this] are set to the passed in values.
  vec2 makeRaw(num x_, num y_) {
    x = x_.toDouble();
    y = y_.toDouble();
    return this;
  }
  /// Constructs a new [vec2] that is initialized with values from [array] starting at [offset].
  vec2.array(List<num> array, [int offset=0]) {
    int i = offset;
    x = array[i].toDouble();
    i++;
    y = array[i].toDouble();
    i++;
  }
  /// Splats a scalar into all lanes of the vector.
  vec2 splat(num arg) {
    double a = arg.toDouble();
    x = a;
    y = a;
    return this;
  }
  /// Returns a printable string
  String toString() => '$x,$y';
  /// Returns a new vec2 from -this
  vec2 operator-() => new vec2.raw(-x, -y);
  /// Returns a new vec2 from this - [other]
  vec2 operator-(vec2 other) => new vec2.raw(x - other.x, y - other.y);
  /// Returns a new vec2 from this + [other]
  vec2 operator+(vec2 other) => new vec2.raw(x + other.x, y + other.y);
  /// Returns a new vec2 divided by [other]
  vec2 operator/(dynamic other) {
    if (other is num) {
      var o = 1.0 / other.toDouble();
      return new vec2.raw(x * o, y * o);
    }
    if (other is vec2) {
      return new vec2.raw(x / other.x, y / other.y);
    }
  }
  /// Returns a new vec2 scaled by [other]
  vec2 operator*(dynamic other) {
    if (other is num) {
      var o = other.toDouble();
      return new vec2.raw(x * o, y * o);
    }
    if (other is vec2) {
      return new vec2.raw(x * other.x, y * other.y);
    }
  }
  /// Returns a component from vec2. This is indexed as an array with [i]
  double operator[](int i) {
    assert(i >= 0 && i < 2);
    switch (i) {
      case 0: return x;
      case 1: return y;
    };
    return 0.0;
  }
  /// Assigns a component in vec2 the value in [v]. This is indexed as an array with [i]
  void operator[]=(int i, double v) {
    assert(i >= 0 && i < 2);
    switch (i) {
      case 0: x = v; break;
      case 1: y = v; break;
    };
  }
  /// Returns length of this
  double get length {
    double sum = 0.0;
    sum += (x * x);
    sum += (y * y);
    return Math.sqrt(sum);
  }
  /// Returns squared length of this
  double get length2 {
    double sum = 0.0;
    sum += (x * x);
    sum += (y * y);
    return sum;
  }
  /// Normalizes [this]. Returns [this].
  vec2 normalize() {
    double l = length;
    if (l == 0.0) {
      return this;
    }
    x /= l;
    y /= l;
    return this;
  }
  /// Normalizes [this]. Returns length.
  double normalizeLength() {
    double l = length;
    if (l == 0.0) {
      return 0.0;
    }
    x /= l;
    y /= l;
    return l;
  }
  /// Normalizes [this] returns new vector or optional [out]
  vec2 normalized([vec2 out = null]) {
    if (out == null) {
      out = new vec2.raw(x, y);
    }
    double l = out.length;
    if (l == 0.0) {
      return out;
    }
    out.x /= l;
    out.y /= l;
    return out;
  }
  /// Returns the dot product of [this] and [other]
  double dot(vec2 other) {
    double sum = 0.0;
    sum += (x * other.x);
    sum += (y * other.y);
    return sum;
  }
  /// Returns the cross product of [this] and [other], optionally pass in output storage [out]
  double cross(vec2 other) {
    return x * other.y - y * other.x;
  }
  /// Returns the relative error between [this] and [correct]
  double relativeError(vec2 correct) {
    double correct_norm = correct.length;
    double diff_norm = (this - correct).length;
    return diff_norm/correct_norm;
  }
  /// Returns the absolute error between [this] and [correct]
  double absoluteError(vec2 correct) {
    return (this - correct).length;
  }
  set xy(vec2 arg) {
    x = arg.x;
    y = arg.y;
  }
  set yx(vec2 arg) {
    y = arg.x;
    x = arg.y;
  }
  /// Returns true if any component is infinite.
  bool get isInfinite {
    bool is_infinite = false;
    is_infinite = is_infinite || x.isInfinite;
    is_infinite = is_infinite || y.isInfinite;
    return is_infinite;
  }
  /// Returns true if any component is NaN.
  bool get isNaN {
    bool is_nan = false;
    is_nan = is_nan || x.isNaN;
    is_nan = is_nan || y.isNaN;
    return is_nan;
  }
  set r(double arg) => x = arg;
  set g(double arg) => y = arg;
  set s(double arg) => x = arg;
  set t(double arg) => y = arg;
  set rg(vec2 arg) {
    r = arg.r;
    g = arg.g;
  }
  set gr(vec2 arg) {
    g = arg.r;
    r = arg.g;
  }
  set st(vec2 arg) {
    s = arg.s;
    t = arg.t;
  }
  set ts(vec2 arg) {
    t = arg.s;
    s = arg.t;
  }
  vec2 get xx => new vec2(x, x);
  vec2 get xy => new vec2(x, y);
  vec2 get yx => new vec2(y, x);
  vec2 get yy => new vec2(y, y);
  vec3 get xxx => new vec3(x, x, x);
  vec3 get xxy => new vec3(x, x, y);
  vec3 get xyx => new vec3(x, y, x);
  vec3 get xyy => new vec3(x, y, y);
  vec3 get yxx => new vec3(y, x, x);
  vec3 get yxy => new vec3(y, x, y);
  vec3 get yyx => new vec3(y, y, x);
  vec3 get yyy => new vec3(y, y, y);
  vec4 get xxxx => new vec4(x, x, x, x);
  vec4 get xxxy => new vec4(x, x, x, y);
  vec4 get xxyx => new vec4(x, x, y, x);
  vec4 get xxyy => new vec4(x, x, y, y);
  vec4 get xyxx => new vec4(x, y, x, x);
  vec4 get xyxy => new vec4(x, y, x, y);
  vec4 get xyyx => new vec4(x, y, y, x);
  vec4 get xyyy => new vec4(x, y, y, y);
  vec4 get yxxx => new vec4(y, x, x, x);
  vec4 get yxxy => new vec4(y, x, x, y);
  vec4 get yxyx => new vec4(y, x, y, x);
  vec4 get yxyy => new vec4(y, x, y, y);
  vec4 get yyxx => new vec4(y, y, x, x);
  vec4 get yyxy => new vec4(y, y, x, y);
  vec4 get yyyx => new vec4(y, y, y, x);
  vec4 get yyyy => new vec4(y, y, y, y);
  double get r => x;
  double get g => y;
  double get s => x;
  double get t => y;
  vec2 get rr => new vec2(r, r);
  vec2 get rg => new vec2(r, g);
  vec2 get gr => new vec2(g, r);
  vec2 get gg => new vec2(g, g);
  vec3 get rrr => new vec3(r, r, r);
  vec3 get rrg => new vec3(r, r, g);
  vec3 get rgr => new vec3(r, g, r);
  vec3 get rgg => new vec3(r, g, g);
  vec3 get grr => new vec3(g, r, r);
  vec3 get grg => new vec3(g, r, g);
  vec3 get ggr => new vec3(g, g, r);
  vec3 get ggg => new vec3(g, g, g);
  vec4 get rrrr => new vec4(r, r, r, r);
  vec4 get rrrg => new vec4(r, r, r, g);
  vec4 get rrgr => new vec4(r, r, g, r);
  vec4 get rrgg => new vec4(r, r, g, g);
  vec4 get rgrr => new vec4(r, g, r, r);
  vec4 get rgrg => new vec4(r, g, r, g);
  vec4 get rggr => new vec4(r, g, g, r);
  vec4 get rggg => new vec4(r, g, g, g);
  vec4 get grrr => new vec4(g, r, r, r);
  vec4 get grrg => new vec4(g, r, r, g);
  vec4 get grgr => new vec4(g, r, g, r);
  vec4 get grgg => new vec4(g, r, g, g);
  vec4 get ggrr => new vec4(g, g, r, r);
  vec4 get ggrg => new vec4(g, g, r, g);
  vec4 get gggr => new vec4(g, g, g, r);
  vec4 get gggg => new vec4(g, g, g, g);
  vec2 get ss => new vec2(s, s);
  vec2 get st => new vec2(s, t);
  vec2 get ts => new vec2(t, s);
  vec2 get tt => new vec2(t, t);
  vec3 get sss => new vec3(s, s, s);
  vec3 get sst => new vec3(s, s, t);
  vec3 get sts => new vec3(s, t, s);
  vec3 get stt => new vec3(s, t, t);
  vec3 get tss => new vec3(t, s, s);
  vec3 get tst => new vec3(t, s, t);
  vec3 get tts => new vec3(t, t, s);
  vec3 get ttt => new vec3(t, t, t);
  vec4 get ssss => new vec4(s, s, s, s);
  vec4 get ssst => new vec4(s, s, s, t);
  vec4 get ssts => new vec4(s, s, t, s);
  vec4 get sstt => new vec4(s, s, t, t);
  vec4 get stss => new vec4(s, t, s, s);
  vec4 get stst => new vec4(s, t, s, t);
  vec4 get stts => new vec4(s, t, t, s);
  vec4 get sttt => new vec4(s, t, t, t);
  vec4 get tsss => new vec4(t, s, s, s);
  vec4 get tsst => new vec4(t, s, s, t);
  vec4 get tsts => new vec4(t, s, t, s);
  vec4 get tstt => new vec4(t, s, t, t);
  vec4 get ttss => new vec4(t, t, s, s);
  vec4 get ttst => new vec4(t, t, s, t);
  vec4 get ttts => new vec4(t, t, t, s);
  vec4 get tttt => new vec4(t, t, t, t);
  vec2 add(vec2 arg) {
    x = x + arg.x;
    y = y + arg.y;
    return this;
  }
  vec2 sub(vec2 arg) {
    x = x - arg.x;
    y = y - arg.y;
    return this;
  }
  vec2 multiply(vec2 arg) {
    x = x * arg.x;
    y = y * arg.y;
    return this;
  }
  vec2 div(vec2 arg) {
    x = x / arg.x;
    y = y / arg.y;
    return this;
  }
  vec2 scale(num arg) {
    double a = arg.toDouble();
    x = x * a;
    y = y * a;
    return this;
  }
  vec2 scaled(num arg) {
    return clone().scale(arg);
  }
  vec2 negate() {
    x = -x;
    y = -y;
    return this;
  }
  vec2 absolute() {
    x = x.abs();
    y = y.abs();
    return this;
  }
  vec2 clone() {
    return new vec2.copy(this);
  }
  vec2 copyInto(vec2 arg) {
    arg.x = x;
    arg.y = y;
    return arg;
  }
  vec2 copyFrom(vec2 arg) {
    x = arg.x;
    y = arg.y;
    return this;
  }
  vec2 set(vec2 arg) {
    x = arg.x;
    y = arg.y;
    return this;
  }
  vec2 setComponents(num x_, num y_) {
    x = x_.toDouble();
    y = y_.toDouble();
    return this;
  }
  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<num> array, [int offset=0]) {
    int i = offset;
    array[i] = x;
    i++;
    array[i] = y;
    i++;
  }
  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<num> array, [int offset=0]) {
    int i = offset;
    x = array[i].toDouble();
    i++;
    y = array[i].toDouble();
    i++;
  }
}
