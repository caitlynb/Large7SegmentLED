/* [Basic Parameters] */

// Character Height.  Default = 200mm.  Includes wall thickness (below) in this measurement.
char_height = 70;

// Wall Thickness in mm
wall_thickness = 1.6;

// Which part would you like to see?
part = "DigitParts"; // [DigitParts:Diffused 'Lenses' and Case,DigitCase:Case Only,DigitLens:Diffused Segments Only,Clock:4 Digit Clock]

// *Percent* of char_height that the segment's width will be.
segment_width = 15; //[5:30]

// How thick (from the mounting surface) should the case be?
char_thick = 25;

// How thick should the lens layer be? (mm)
diff_thick = 1.2;

/* [Detailed Parameters] */

// What is the Tap Drill size of the screws you will mount with?  (mm)
tap_hole_size = 2.26;

// Do you want the centers of the 8 removed?
cutouts = true;   // [true,false]

// should the case follow the edge of the segments?
chamfer = false;  // [true,false]

// do you want mounting holes?
mounting_holes = true; // [true,false]

// Where would you like the holes placed?
mounting_type = "corners";  // [topbottom,corners,centersides,insides]

// Do you want the digit to expand the case size?
expand_case = true; // [true,false]


segwidth = char_height * segment_width / 100;
walltriangle = sqrt( pow(wall_thickness,2) / 2);
segheight = (char_height - wall_thickness * 2 - segwidth - walltriangle * 4) / 2;
segriser = segheight - segwidth;
case_x_out = segheight/2 + segwidth/2 + walltriangle + wall_thickness;
case_y_out = segheight + segwidth/2 + walltriangle*2 + wall_thickness;
spacer_x = segwidth/4+wall_thickness*2;
dot_x = segwidth/2+wall_thickness*2;
//tapx = case_x_out - wall_thickness - tap_hole_size*2;
//tapy = case_y_out - wall_thickness - tap_hole_size*2;
tapx = case_x_out - tap_hole_size*1.5;
tapy = case_y_out - tap_hole_size*1.5;

print_part();

module clockcase(){
    translate([-case_x_out*2-spacer_x-dot_x+wall_thickness*2,0,0])doublecase();
    translate([case_x_out*2+spacer_x+dot_x-wall_thickness*2,0,0])doublecase();
    dotscase();
}

module doublecase(){
    spacercase();
    translate([-case_x_out-spacer_x+wall_thickness,0,0])
        difference(){
            case();
            cornertaps();
        };
    translate([case_x_out+spacer_x-wall_thickness,0,0])
        difference(){
            case();
            cornertaps();
        };
}

module print_part(){
    if(part == "DigitParts"){
        diffuse_segments();
        case();
    } else if (part == "DigitCase"){
        if (mounting_holes == true){
            if(mounting_type == "centersides"){
                case();
                sidetabs();
            }
            if(mounting_type == "corners"){
                difference(){
                    case();
                    cornertaps();
                }
            }
        }
    } else if (part == "DigitLens"){
        diffuse_segments();
    } else if (part == "Spacer") {
        spacer();
    } else if (part == "Dots") {
        dots();
    } else if (part == "Clock") {
        clockcase();
    }
    
    
            
    
}

module spacercase(){
    difference(){
        linear_extrude(height=char_thick)
        polygon([[spacer_x, case_y_out],
            [spacer_x, -case_y_out],
            [-spacer_x, -case_y_out],
            [-spacer_x, case_y_out]]);
        translate([0,0,diff_thick])linear_extrude(height=char_thick)
        polygon([[spacer_x-wall_thickness, case_y_out-wall_thickness-segwidth/2],
            [spacer_x-wall_thickness, -case_y_out+wall_thickness+segwidth/2],
            [-spacer_x+wall_thickness,-case_y_out+wall_thickness+segwidth/2],
            [-spacer_x+wall_thickness, case_y_out-wall_thickness-segwidth/2]]);
        translate([0,tapy,char_thick/2+1])
        cylinder(r=tap_hole_size/2, h=char_thick, center=true, $fs = 1);
        translate([0,-tapy,char_thick/2+1])
        cylinder(r=tap_hole_size/2, h=char_thick, center=true, $fs = 1);
    }
}

module dotscase(){
    difference(){
        union(){
            difference(){
            linear_extrude(height=char_thick)
            polygon([[dot_x, case_y_out],
                [dot_x, -case_y_out],
                [-dot_x, -case_y_out],
                [-dot_x, case_y_out]]);
            translate([0,0,diff_thick])linear_extrude(height=char_thick)
            polygon([[dot_x-wall_thickness, case_y_out-wall_thickness-segwidth/2],
                [dot_x-wall_thickness, -case_y_out+wall_thickness],
                [-dot_x+wall_thickness,-case_y_out+wall_thickness],
                [-dot_x+wall_thickness, case_y_out-wall_thickness-segwidth/2]]);
            translate([0,tapy,char_thick/2+1])
            cylinder(r=tap_hole_size/2, h=char_thick, center=true, $fs = 1);
            }
            difference(){
                linear_extrude(height=char_thick)
                polygon([[dot_x-wall_thickness, -segwidth/3], 
                    [dot_x-wall_thickness,segwidth/3],
                    [-dot_x+wall_thickness,segwidth/3],
                    [-dot_x+wall_thickness,-segwidth/3]]);
                translate([0,0,char_thick/2+1])
                cylinder(r=tap_hole_size/2, h=char_thick, center=true, $fs = 1);
            }
            translate([0,-segheight/2-walltriangle,0])
                cylinder(r = segwidth/3+wall_thickness, h=char_thick);
            translate([0,segheight/2+walltriangle,0])
                cylinder(r = segwidth/3+wall_thickness, h=char_thick);
            translate([0,-segheight-walltriangle,0])
                cylinder(r = segwidth/3+wall_thickness, h=char_thick);
            translate([0,-segheight/2-walltriangle,char_thick/2])
                cube(size=[dot_x*2,wall_thickness,char_thick], center=true);
            translate([0,segheight/2+walltriangle,char_thick/2])
                cube(size=[dot_x*2,wall_thickness,char_thick], center=true);
            translate([0,-segheight-walltriangle,char_thick/2])
                cube(size=[dot_x*2,wall_thickness,char_thick], center=true);
        }
        translate([0,-segheight/2-walltriangle,0])
        cylinder(r = segwidth/3, h=char_thick*3,center=true);
        translate([0,segheight/2+walltriangle,0])
        cylinder(r = segwidth/3, h=char_thick*3,center=true);
        translate([0,-segheight-walltriangle,0])
        cylinder(r = segwidth/3, h=char_thick*3,center=true);
    }

}


module sidetabs(){
    difference(){
        translate([0,0,char_thick-wall_thickness]){
            linear_extrude(height=wall_thickness){
                polygon([[segheight/2,0],
                    [case_x_out, -segwidth/2-wall_thickness],
                    [case_x_out, segwidth/2+wall_thickness]]);
                polygon([[-segheight/2, 0],
                    [-case_x_out, -segwidth/2 -wall_thickness],
                    [-case_x_out, segwidth/2+wall_thickness]]);
            }
        }
        translate([-segheight/2-segwidth/2+wall_thickness,0,char_thick])
        cylinder(r=tap_hole_size/2,h=1, center=true);
        translate([-segheight/2-segwidth/2+wall_thickness,0,char_thick])
        cylinder(r=1,h=1.5, center=true);
        translate([segheight/2+segwidth/2-wall_thickness,0,char_thick])
        cylinder(r=tap_hole_size/2,h=1, center=true);
        translate([segheight/2+segwidth/2-wall_thickness,0,char_thick])
        cylinder(r=1,h=1.5, center=true);
    }
}

module cornertaps(){
    translate([tapx,0,char_thick/2+1])
    cylinder(r=tap_hole_size/2, h=char_thick, center=true, $fs = 1);
    translate([-tapx,0,char_thick/2+1])
    cylinder(r=tap_hole_size/2, h=char_thick, center=true, $fs = 1);
    translate([tapx,tapy,char_thick/2+1])
    cylinder(r=tap_hole_size/2, h=char_thick, center=true, $fs = 1);
    translate([-tapx,tapy,char_thick/2+1])
    cylinder(r=tap_hole_size/2, h=char_thick, center=true, $fs = 1);
    translate([tapx,-tapy,char_thick/2+1])
    cylinder(r=tap_hole_size/2, h=char_thick, center=true, $fs = 1);
    translate([-tapx,-tapy,char_thick/2+1])
    cylinder(r=tap_hole_size/2, h=char_thick, center=true, $fs = 1);
}

module case(){
    difference(){
        linear_extrude(height = char_thick)
        if (cutouts == true) {
            if (chamfer == true) {
                difference(){
                    chamfered_case();
                    case_cutouts();
                }
            } else {
                difference(){
                    straight_case();
                    case_cutouts();
                }
            }
        } else {
            if (chamfer == true){
                chamfered_case();
            } else {
                straight_case();
            }  
        }
        linear_extrude(height = char_thick*3, center=true)segments_poly();
    }
    
}

module case_cutouts(){
    translate([0,segheight/2+walltriangle,0])square(segheight-segwidth-wall_thickness, center = true);
    translate([0,-segheight/2-walltriangle,0])square(segheight-segwidth-wall_thickness, center = true);
}

module chamfered_case(){
	/* Old polygon - close, but not perfect
	polygon( points = [
	        [-segheight/2-walltriangle*2, 0], 
	        [-case_x_out, segwidth/2],
	        [-case_x_out, segheight-segwidth/2 + walltriangle*2], 
	        [-segheight/2 +segwidth/2 -walltriangle, case_y_out],
	        [segheight/2 - segwidth/2 + walltriangle, case_y_out],
	        [case_x_out, segheight-segwidth/2 + walltriangle*2],
	        [case_x_out, segwidth/2],
	        [segheight/2+walltriangle*2, 0],
	        [case_x_out, -segwidth/2],
	        [case_x_out, -segheight+segwidth/2-walltriangle*2],
	        [segheight/2 - segwidth/2 + walltriangle, -case_y_out],
	        [-segheight/2 + segwidth/2 - walltriangle, -case_y_out],
	        [-case_x_out, -segheight + segwidth/2 - walltriangle*2],
	        [-case_x_out, -segwidth/2]
	    ], paths = [
	        [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
	    ]);
	*/
	offset(r=wall_thickness){
		segments_poly();
	}
}

module straight_case(){
    square([case_x_out*2, case_y_out*2], center = true);
}

module diffuse_segments(){
    linear_extrude(height = diff_thick)segments_poly();
}

module segments_poly(){ // returns polygons!
    translate([-segheight/2-walltriangle,-segheight/2-walltriangle,0])segment();
    translate([-segheight/2-walltriangle,segheight/2+walltriangle,0])segment();
    translate([segheight/2+walltriangle,-segheight/2-walltriangle,0])segment();
    translate([segheight/2+walltriangle,segheight/2+walltriangle,0])segment();
    rotate([0,0,90])segment();
    translate([0,segheight+walltriangle*2,0])rotate([0,0,90])segment();
    translate([0,-segheight-walltriangle*2.,0])rotate([0,0,90])segment();
}

module segment(){  // returns polygon.
    polygon (points = [
            [-segwidth/2, -segriser/2], [-segwidth/2, segriser/2], [0,segheight/2],
            [segwidth/2, segriser/2], [segwidth/2, -segriser/2], [0,-segheight/2]], 
            paths = [[ 0,1,2,3,4,5]]);
}
