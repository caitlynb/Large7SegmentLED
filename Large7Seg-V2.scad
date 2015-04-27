/* [Basic Parameters] */

// Character Height.  Default = 200mm.  Includes wall thickness in this measurement.
character_height = 100;

// Wall Thickness.  Default = 1.6mm.
wall_thickness = 1.6;

// Which part do you want to make?
part = "Clock4"; // [DigitParts:Diffused Lenses and Case,DigitCase:Case Only,DigitLens:Diffused Segments,Clock4:4 Digit Clock (no lenses),Clock4Lens:4 Digit Clock Lenses,Clock6:6 Digit Clock (no lenses),Clock6Lens:6 Digit Clock Lenses]

// Segment Width:  Measured in Percentage of the segment's height.
segment_width_percentage = 15; // [10:25]

// How thick should the case be?
character_thickness = 25;

// How thick should a lens be?
lens_thickness = 1.6;

/* [Tweaks for advanced users] */

// What is the hole size you need for mounting?
mount_hole_size = 2.26;

// What type of digits?
digit_type = 7; // [7:7 Segment,8:7 Segment and Dot,9:7 Segment and Colon,10:7 Segment-Colon-Dot,11:7 Segment-Colon-Dot-Dot,14:Alphanumeric,15:Alphanumeric and Dot,16:Alphanumeric and Colon,17:Alphanumeric-Colon-Dot,18:Alphanumeric-Colon-Dot-Dot]

// Slant the digits by how many degrees?
slant = 10; // [0:25]

// How far should the characters be spaced?
spacing = 1;  // [1:Close Together,1.5:Loose,2:Far Apart

/* [Hidden] */

segment_height = (character_height - wall_thickness*2)/cos(slant)/2;
echo (segment_height=segment_height);
// notice - segment height is too long
// we will be subtracting off it with other objects.

segment_width = segment_height * segment_width_percentage / 100;
echo (segment_width=segment_width);

segment_shift_x = segment_height/2 * sin(slant);
segment_shift_y = segment_height/2 * cos(slant);
echo (segment_shift_x=segment_shift_x,segment_shift_y=segment_shift_y);

segments_14();
dotdot();
colon();

module segments_7(){
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
                #square([segment_height*3, wall_thickness],center=true);
            }
        }
        // remove the left overs on the x axis
        for( r = [0,180]){
            rotate([0,0,r]){
                translate([segment_height/2 ,0,0])
                rotate([0,0, (-45-slant/2)])
                #square([segment_width*2,segment_width*2]);
            }
        }
    }
}

module segments_14(){
    difference(){
        union(){
            segments_7();
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
            #square([segment_width*3, wall_thickness],center=true);
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
            echo( theta1=theta1, theta2=theta2);
            rotate([0,0,theta2])
            square([(segment_shift_y*2/sin(abs(theta2)))*2, segment_width], center = true);
        } // diagonal segments
        offset(wall_thickness)union(){
            segments_7();
            for (y = [1,-1]){
                // draw the basic segments
                translate([y * segment_shift_x, y * segment_shift_y,0])
                rotate([0,0,-slant])
                square([segment_width, segment_height],center=true);
            }
        }
    }
}

module dot(){
    translate([segment_height/2 - segment_shift_x*2 + segment_width*2, cos(slant) * -segment_height + segment_width/2, 0])
    circle(r = segment_width/1.5, $fs=.5);
}

module dotdot(){
    for( y = [-1,1]){
        translate([segment_height/2 +y * segment_shift_x*2 + segment_width*2, cos(slant) * y * segment_height - y * segment_width/2, 0])
        circle(r = segment_width/1.5, $fs=.5);
    }
}

module colon(){
    for( y = [-1, 1]){
        translate([segment_height/2 + y * segment_shift_x + segment_width*2, 0.5 * cos(slant) * y * segment_height, 0])
        circle(r = segment_width/1.5, $fs=.5);
    }
}