

thickness    = 8;
//thickness    = 1.2;
batch1       = true;

d_wheelside  = 90.25;
d_gearside   = 73.25;
d_bolts      = 55;
d_bolt_holes = 5;

bolt_hole_tolerance = 0.5;

// batch 1 stuff. 
d_gear_side_cutout = 64 + 0.5;
h_gear_side_cutout = 1.75;


$fs = 0.2;
$fa = 1;

_d_bolt_holes = d_bolt_holes + bolt_hole_tolerance;
d_center_cutout = d_bolts - d_bolt_holes * 2.5; // originally 35.2 

///////
// OVERKILL
// polycircle related section
// make bolt hole polygons circumscribe 
// the desired circles
//
module regular_polygon(order, r=1, apothem=-1){
  _r = apothem == -1 ? r : apothem/cos(360/order/2);
  angles=[ for (i = [0:order-1]) i*(360/order) ];
  coords=[ for (th=angles) [_r*cos(th), _r*sin(th)] ];
  polygon(coords);
}

// create a polygon that circumscribes a circle of radius r.
// iow r is the apothem of the polygon. 
module polycircle(r,n) {
  angle = 180/n;
  radius = r / cos(angle); 
  rotate(angle) // rotate is mostly for comparision against the polygon produced by circle()
    regular_polygon(n, radius);
}

// given current $fn , $fa, $fs vars
// figure out how many fragments openscad would have picked for  circle()
function get_fragments_from_r(r) = 
  let( 
    grid_fine      = 0.00000095367431640625,
    fafs_fragments = min(360/$fa, r*2*PI/$fs),
    fnvfs          = $fn > 0 ? max($fn,3) : ceil(max(fafs_fragments,5))
  )
  r < grid_fine ? 3 : fnvfs;

// in openscad circles end up being polygons. 
// so make a polygon with current settings that circumscribes the desired circle.
module fpolycircle(r) {
  polycircle(r,get_fragments_from_r(r));
}

// end polycircle section
//////

module bolt_hole(thickness = thickness) {
  translate([0,0,-1])  {
    linear_extrude(thickness + 2) 
      fpolycircle(_d_bolt_holes/2);
  }
}

module test_bolt_hole() {
  difference() {
    cylinder(d=_d_bolt_holes + 4, h=4 );
    bolt_hole();
  }
}

module moondrive_spacer(
  d_wheelside = d_wheelside,
  d_gearside  = d_gearside,
  thickness   = thickness
) {

  difference() {
    cylinder(d1 = d_wheelside, d2 = d_gearside, h=thickness);

    translate([0,0,-1]) cylinder(d=d_center_cutout, h=thickness + 2);

    for (i = [0:5]) { 
      rotate(60 * i)
        translate([0,d_bolts/2,0]) 
          bolt_hole(thickness);
    }

  }
}

module batch1_45degree_spacer() {
  _thickness     = thickness + h_gear_side_cutout;
  d_wheelside_45 = d_gearside + _thickness * 2 ;
  _d_wheelside   = d_wheelside_45 < d_wheelside ? d_wheelside_45 : d_wheelside;

  translate([0,0,_thickness]) rotate([0,180,0])
    difference() { 
      moondrive_spacer(_d_wheelside, d_gearside, _thickness);
      translate([0,0,-1]) cylinder(d=d_gear_side_cutout, h=h_gear_side_cutout + 1);
    }
}

module batch1_alternate_test() { 
  difference() {
    moon_gear_spacer();
    translate([0,0,h_gear_side_cutout]) cylinder(d1=d_gear_side_cutout, d2=0, h=d_gear_side_cutout/2);
    translate([0,0,-1]) cylinder(d=d_gear_side_cutout, h=h_gear_side_cutout + 1);

    for (i = [0:5]) {
      rotate(60 * i) {
        hull() {
          bolt_hole();
          translate([0,d_bolts/2,0]) bolt_hole();
        }
      }
    }

  }
}



echo(batch1 = batch1, thickness = thickness);

if (batch1 == true) { 
  batch1_45degree_spacer();
} else { 
  moondrive_spacer();
}

