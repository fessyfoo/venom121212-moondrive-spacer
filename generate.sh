#!/bin/sh


PATH="/Applications/OpenSCAD.app/Contents/MacOS:$PATH"

b1_dir="STL/batch1"
b2_dir="STL/batch2+"
scad_filename="moon-geardrive-spacer.scad"
mkdir -p "$b1_dir" "$b2_dir"


for size in $(seq -f "%0.1f" 1 0.2 11.6) 
  do
    _size=$(echo $size | tr . _)
    b1_filename="$b1_dir/venom-moon-geardrive-spacer.b1.${_size}.stl"
    b2_filename="$b2_dir/venom-moon-geardrive-spacer.b2.${_size}.stl"

    #echo "$b1_filename"
    echo openscad $scad_filename -o "$b1_filename" -D batch1=true -D "thickness=$size"
    openscad $scad_filename -o "$b1_filename" -D batch1=true -D "thickness=$size"

    #echo "$b2_filename"
    echo openscad $scad_filename -o "$b2_filename" -D batch1=false -D "thickness=$size"
    openscad $scad_filename -o "$b2_filename" -D batch1=false -D "thickness=$size"
  done
