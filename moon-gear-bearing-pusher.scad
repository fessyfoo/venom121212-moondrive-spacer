

d1 = 36;
d2 = 41;

h1 = 6;
h2 = 11;

//$fs=0.5;
//$fa=1;
//
n_arms = 12;

module a() {
  cylinder(d=d2, h=h2);
  translate([0,0,h2]) cylinder(d1=d2, d2=d1, h=h1);
}

difference() {
  a();
  translate([0,0,-1]) cylinder(d=d1-4, h=h1+h2 +2);
}
