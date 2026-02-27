$fn=20;

depth=10; 
plate_thickness=2;
wall_thickness=2;
angle=10;

extension=100;

render_tilt_wall = false;
render_wall=true;
render_plate=true;

layout = [
    [[],[],[],[],[],[]],
    [[],[],[],[],[],[]],
    [[],[],[],[],[],[]],
    [[],[],[],[],[],[]],
    [[],[],[]],
];

rows=len(layout);
cols=len(layout[0]);
        
key_size=19.05;
hole=14;


function u_mm(u) = u*key_size;
function hole_offset(u) = (key_size-hole)/2+u_mm(u-1)/2;        
        
module side_plate(){
    for (i = [0:rows-1]){
        translate([u_mm(0),u_mm(i),0])
        square([u_mm(len(layout[i])),u_mm(1)]);
    }
}


module base(){
    linear_extrude(plate_thickness)
        side_plate();
}

module key_holes(){
    for (i = [0:rows-1]){
        for ( j = [0:len(layout[i])-1]){
            translate([hole_offset(1)+u_mm(j), 
                        hole_offset(1)+u_mm(i),
                        -hole/2]) 
            linear_extrude(10)    
                square(hole);            
        }
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

module extruded_wall(extend=0){
    height = depth + extend;
    translate([0,0,-height+(plate_thickness*2)]){
        linear_extrude(height)
            base_wall();
        linear_extrude(height)
            offset(r=wall_thickness/2)
                base_wall();
    }    
}

module support_wall(tilt=false){
    difference(){
        minkowski(){
            if (tilt){
            extruded_wall(extension);
            }
            else{
                extruded_wall();
            }
            sphere(r=1);
        }
        
        scale([1,1,plate_thickness * 4])
            base();
    }
}
module tilt_wall(){
    difference(){
        translate([0,0,depth*2])
        rotate([0,angle,0])
            translate([0,0,depth])
                support_wall(tilt=true);
        translate([-50,-50,-100])
            cube([200,200,100]);
    }
}

if (render_tilt_wall) tilt_wall();
if (render_wall) support_wall();
if (render_plate) key_plate();
