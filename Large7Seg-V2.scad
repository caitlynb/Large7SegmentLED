/* [Basic Parameters] */

// Character Height.  (Full height of the printed block, not the height of the individual segments.)
character_height = 150;

// Wall Thickness.  Default = 1.6mm.
wall_thickness = 1.6;

// Which part do you want to make?
part = "DigitParts"; // [DigitParts:Diffused Lenses and Case,DigitCase:Case Only,DigitLens:Diffused Segments,Clock4:4 Digit Clock (no lenses),Clock4Lens:4 Digit Clock Lenses,Clock6:6 Digit Clock (no lenses),Clock6Lens:6 Digit Clock Lenses]

// Segment Width:  In mm
segment_width = 17;

// How thick should the case be?
character_thickness = 18;

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
spacing = 1;  // [1.5:Close Together,2:Loose,2.5:Far Apart

/* [Hidden] */

/* 
 * Example Code
 */
single();

module example1(){
    for (slant = [0,25]){
        segment_height = (character_height - wall_thickness*2 - segment_width)/cos(slant)/2;
        translate([slant*8,0,0])
        difference(){
            linear_extrude(20)
            case(segment_height, segment_width, slant, wall_thickness,    spacing, digit_type);
            translate([0,0,-5])
            linear_extrude(30){
                segments_7(segment_height, segment_width, slant, wall_thickness);
                
            }
            translate([segment_height/2+segment_width*1.5+wall_thickness,0,-5])
            linear_extrude(30){
                colon(segment_height, segment_width, slant, spacing);
                dotdot(segment_height, segment_width, slant, spacing);
            }
        }
    }
}

module example2(){
    translate([0,character_height*.75,0])
    clock4(character_height, segment_width, 0, wall_thickness, spacing,         digit_type, character_thickness);
    translate([0,-character_height*.75,0])
    clock4(character_height, segment_width, 25, wall_thickness, spacing,         digit_type, character_thickness);
}

module single(){
    segment_height = (character_height - wall_thickness*2 - segment_width)/cos(slant)/2;
    difference(){
        linear_extrude(20)
        case(segment_height, segment_width, slant, wall_thickness, spacing, digit_type);
        translate([0,0,-5])
        linear_extrude(30){
            if(floor(digit_type/7)==1){    
                segments_7(segment_height, segment_width, slant, wall_thickness);
            } else {
                segments_14(segment_height, segment_width, slant, wall_thickness);
            }
            
            for(x = [-1,1]){
                translate([x*segment_height/3*2*sin(slant),x*segment_height/3*2,0])
                circle(d = mount_hole_size, $fs=1, center=true);
                translate([x*(segment_height/2+segment_width/2-mount_hole_size/2),0,0])
                circle(d = mount_hole_size, $fs=1, center =true);
            }
        }
        translate([segment_height/2+segment_width*1.5+wall_thickness,0,-5])
        linear_extrude(30){
            if(digit_type%7==1){
                dot(segment_height,segment_width, slant, spacing);
            }
            if(digit_type%7==2){
                colon(segment_height, segment_width, slant, spacing);
            }
            if(digit_type%7==3){
                dot(segment_height,segment_width, slant, spacing);
                colon(segment_height, segment_width, slant, spacing);
            }
            if(digit_type%7==4){
                dotdot(segment_height,segment_width, slant, spacing);
                colon(segment_height, segment_width, slant, spacing);
            }
            
            
        }
    }
}

module slants(){
    xspace = sin(slant)*character_height;
    linear_extrude(character_thickness)
    for(x = [0,180]){
        rotate(x)
        polygon([[-xspace,-character_height/2],[-xspace,character_height/2],[-0,character_height/2]]);
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
    dot_shift_x = -(segment_height-segment_width/3) * sin(slant);
    translate([dot_shift_x, cos(slant) * -segment_height + segment_width/3, 0])
    circle(r = segment_width/1.5, $fs=.5);
}

module dotdot(segment_height = 100, segment_width = 10, slant=10, spacing=1){
    dot_shift_x = (segment_height-segment_width/3) * sin(slant);
    for( y = [-1,1]){
        translate([y * dot_shift_x, cos(slant) * y * segment_height - y * segment_width/3, 0])
        circle(r = segment_width/1.5, $fs=.5, center=true);
    }
}

module colon(segment_height = 100, segment_width = 10, slant=10, spacing=1){
    dot_shift_x = segment_height/2 * sin(slant);
    for( y = [-1, 1]){
        translate([y * dot_shift_x, 0.5 * cos(slant) * y * segment_height, 0])
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

module clock4(character_height = 100, segment_width = 10, slant=10, wall_thickness=1.6, spacing = 1, digit_type=7, character_thickness = 10){
    segment_height = (character_height - wall_thickness*2 - segment_width)/cos(slant)/2;
    echo(slant=slant);
    echo(segment_height=segment_height);
    space_factor1 = segment_height/2 + segment_width*spacing/2+segment_width*1.5/2+wall_thickness;
    space_factor2 = segment_height+segment_width + segment_width*spacing;
    box_factor = (segment_height)*sin(slant);
    echo(box_factor=box_factor);
    difference(){
        // Case 
        linear_extrude(character_thickness)
        square([space_factor1*4-segment_width+wall_thickness*2+space_factor2*2+box_factor*2
        ,character_height], center=true);
        
        for(x = [-space_factor1 - space_factor2,
            -space_factor1, space_factor1,
            space_factor1 + space_factor2]){
            translate([x,0,-5])
            linear_extrude(character_thickness+10){
                segments_7(segment_height, segment_width, slant, wall_thickness);
            }
        }
            
        translate([0,0,-5])
        linear_extrude(character_thickness+10){
            colon(segment_height, segment_width, slant, spacing);
            dotdot(segment_height, segment_width, slant, spacing);
        }
    }
    
}