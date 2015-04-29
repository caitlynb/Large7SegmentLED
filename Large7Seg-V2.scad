/* [Basic Parameters] */

// Character Height.  (Full height of the printed block, not the height of the individual segments.)
character_height = 175;

// Wall Thickness.  Default = 1.6mm.
wall_thickness = 1.6;

// Which part do you want to make?
part = "DigitParts"; // [DigitParts:Diffused Lenses and Case,DigitCase:Case Only,DigitLens:Diffused Segments,Clock4:4 Digit Clock (no lenses),Clock4Lens:4 Digit Clock Lenses,Clock6:6 Digit Clock (no lenses),Clock6Lens:6 Digit Clock Lenses]

// Segment Width:  In mm
segment_width = 20;

// How thick should the case be?
character_thickness = 25;

// How thick should a lens be?
lens_thickness = 1.6;

/* [Tweaks for advanced users] */

// What is the hole size you need for mounting?
mount_hole_size = 2.26;

// What type of digits?
digit_type = 8; // [7:7 Segment,8:7 Segment and Dot,9:7 Segment and Colon,10:7 Segment-Colon-Dot,11:7 Segment-Colon-Dot-Dot,14:Alphanumeric,15:Alphanumeric and Dot,16:Alphanumeric and Colon,17:Alphanumeric-Colon-Dot,18:Alphanumeric-Colon-Dot-Dot]

// Slant the digits by how many degrees?
slant = 10; // [0:25]

// How far should the characters be spaced?
spacing = 1;  // [1:Close Together,1.5:Loose,2:Far Apart

/* [Hidden] */

segment_height = (character_height - wall_thickness*2 - segment_width)/cos(slant)/2;
echo (segment_height=segment_height);
echo (segment_width=segment_width);

/* 
 * Example Code
 */
 

difference(){
    linear_extrude(20)
    case(segment_height, segment_width, slant, wall_thickness,    spacing, digit_type);
    translate([0,0,-5])
    linear_extrude(30){
        segments_7(segment_height, segment_width, slant, wall_thickness);
        colon(segment_height, segment_width, slant, spacing);
        dotdot(segment_height, segment_width, slant, spacing);
    }
}

module segments_7(segment_height = 100, segment_width = 10, slant=10, wall_thickness=1.6){
    segment_shift_x = segment_height/2 * sin(slant);
    segment_shift_y = segment_height/2 * cos(slant);    
    difference(){
        union(){
            for (x = [1, -1]){
                for (y = [1,-1]){
                    // draw the basic segments
                    translate([x * segment_height/2 + y * segment_shift_x, y * segment_shift_y,0])
                    rotate([0,0,-slant])
                    square([segment_width, segment_height],center=true);
                    // round the corners
                    translate([x * segment_height/2 + y * segment_shift_x * 2, y * cos(slant) * segment_height, 0])
                    circle(r = segment_width/2, $fs=.5);
                }
            }
            for (y = [-1:1:1]){
                translate([y * segment_shift_x*2 , y * cos(slant) * segment_height,0])
                square([segment_height, segment_width], center= true);
            }
        } // end union for segments
        for (y = [-1,1]){ // split the segments
            for (r = [-1,1]){
                translate([y * segment_shift_x, y * segment_shift_y])
                rotate([0,0,r * 45-slant/2])
                square([segment_height*3, wall_thickness],center=true);
            }
        }
        // remove the left overs on the x axis
        for( r = [0,180]){
            rotate([0,0,r]){
                translate([segment_height/2 ,0,0])
                rotate([0,0, (-45-slant/2)])
                square([segment_width*2,segment_width*2]);
            }
        }
    }
}

module segments_14(segment_height = 100, segment_width = 10, slant=10, wall_thickness=1.6){
    segment_shift_x = segment_height/2 * sin(slant);
    segment_shift_y = segment_height/2 * cos(slant);
    difference(){
        union(){
            segments_7(segment_height, segment_width, slant);
            for (y = [1,-1]){
                // draw the basic segments
                translate([y * segment_shift_x, y * segment_shift_y,0])
                rotate([0,0,-slant])
                square([segment_width, segment_height],center=true);
            }
        } // union
        for (r = [-1,1]){
            translate([y * segment_shift_x, segment_shift_y])
            rotate([0,0,r * 45-slant/2])
            square([segment_width*3, wall_thickness],center=true);
        }
        for (y = [-1,1]){
            translate([y * segment_shift_x*2 , y * cos(slant) * segment_height - y * (segment_width/2+wall_thickness/2),0])
            square([segment_width*2, wall_thickness], center= true);
        }
    }
    difference(){
        union(){
            theta1 = atan2(cos(slant) * segment_height,segment_height/2 + segment_shift_x * 2);
            rotate([0,0,theta1])
            square([(segment_shift_y*2/sin(theta1))*2, segment_width], center = true);
            theta2 = atan2(cos(slant) * -segment_height, segment_height/2 - segment_shift_x*2);
            rotate([0,0,theta2])
            square([(segment_shift_y*2/sin(abs(theta2)))*2, segment_width], center = true);
        } // diagonal segments
        offset(wall_thickness)union(){
            segments_7(segment_height, segment_width, slant);  // basic outline
            for (y = [1,-1]){ // vertical middle segments
                translate([y * segment_shift_x, y * segment_shift_y,0])
                rotate([0,0,-slant])
                square([segment_width, segment_height],center=true);
            }
        }
    }
}

module dot(segment_height = 100, segment_width = 10, slant=10, spacing=1){
    dot_shift_x = (segment_height-segment_width) * sin(slant);
    translate([segment_height/2 - dot_shift_x + segment_width*(spacing+0.5), cos(slant) * -segment_height + segment_width, 0])
    circle(r = segment_width/1.5, $fs=.5);
}

module dotdot(segment_height = 100, segment_width = 10, slant=10, spacing=1){
    dot_shift_x = (segment_height-segment_width) * sin(slant);
    for( y = [-1,1]){
        translate([segment_height/2 +y * dot_shift_x + segment_width*(spacing+.5), cos(slant) * y * segment_height - y * segment_width, 0])
        circle(r = segment_width/1.5, $fs=.5);
    }
}

module colon(segment_height = 100, segment_width = 10, slant=10, spacing=1){
    dot_shift_x = segment_height/2 * sin(slant);
    for( y = [-1, 1]){
        translate([segment_height/2 + y * dot_shift_x + segment_width*(spacing+0.5), 0.5 * cos(slant) * y * segment_height, 0])
        circle(r = segment_width/1.5, $fs=.5);
    }
}

module case(segment_height = 100, segment_width = 10, slant=10, wall_thickness=1.6, spacing = 1, digit_type=7){
    corner_x = (segment_height + (segment_width/2 + wall_thickness)/cos(slant)) * sin(slant) ;
    corner_y = segment_height * cos(slant) + segment_width/2  + wall_thickness;
    if (digit_type % 7 == 0){
        // no dots to deal with
        #polygon([[-segment_height/2 - spacing * segment_width + corner_x, corner_y], 
            [segment_height/2 + spacing * segment_width + corner_x, corner_y],
            [segment_height/2 + spacing * segment_width- corner_x, -corner_y],
            [-segment_height/2 - spacing * segment_width - corner_x, -corner_y]]);
    } else {
        // have to account for dots
        #polygon([[-segment_height/2 - spacing * segment_width + corner_x, corner_y], 
            [segment_height/2 + segment_width*(spacing+.5) + spacing * segment_width + corner_x, corner_y],
            [segment_height/2 + segment_width*(spacing+.5) + spacing * segment_width- corner_x, -corner_y],
            [-segment_height/2 - spacing * segment_width - corner_x, -corner_y]]);

    }
}