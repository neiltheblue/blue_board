include <keyboard.scad>

$fn=20;

depth=10; 
plate_thickness=1;
wall_thickness=2;
angle=15;

extension=100;

render_wall=true;
render_plate=true;

layout = [
    [[],[],[],[],[],[]],
    [[],[],[],[],[],[]],
    [[],[],[],[],[],[]],
    [[],[],[]],
];

rows=len(layout);
cols=6;
        
module side_plate(){
    for (i = [0:3]){
        translate([u_mm(0),u_mm(i),0])
        square([u_mm(len(layout[i])),u_mm(1)]);
    }
}

module base(){
    linear_extrude(plate_thickness)
        side_plate();
}

module key_holes(){
    translate([u_mm(gap_offset), 0, 0])
    difference(){
        cube([u_mm(cols), u_mm(rows), plate_thickness]);
        
        translate([0,0,5])
        top_plate(layout, margin=0);        
    }
}

module key_plate(){
    difference(){
        base();
        key_holes();
    }
}

module base_wall(){    
    difference(){
        offset(r=wall_thickness/2)
        side_plate();               
        side_plate();
    }
}

module extruded_wall(){
    translate([0,0,-depth+(plate_thickness*2)-extension]){
        linear_extrude(depth+extension)
            base_wall();
        linear_extrude(depth+extension)
            offset(r=wall_thickness/2)
                base_wall();
    }    
}

module support_wall(){
    difference(){
        minkowski(){
            extruded_wall();
            sphere(r=1);
        }
        
        scale([1,1,plate_thickness * 4])
            base();
        
        //translate([0,0,-plate_thickness*2])
        //    cube([10,10,4], center=true);        
    }
}

difference(){
    translate([0,0,depth*2])
    rotate([0,10,0])
        translate([0,0,depth])
            support_wall();
    translate([-50,-50,-100])
        cube([200,200,100]);
}

if (render_wall) support_wall();
if (render_plate) key_plate();
