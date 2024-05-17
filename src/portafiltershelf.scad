
/* 
Customizable portafilter and espresso accessory shelf and holder
By: Christoph Steinbeck
version: 1.0
Date: 17 May 2024

This customizable portafilter and espresso accessory shelf and holder used code modules by Eric Buijs 
(https://www.printables.com/de/model/91734-parametric-hook-with-source-file/files)
and Daniel Upshaw (http://danielupshaw.com/openscad-rounded-corners/)
Thanks to both of them for open-sourcing their code. 




Changelog
Version 1.0 First version with two shelves with two little pits of portafilter size, one cut-out for the portafilter to hang and one hook to hold my brush for the brew group.

*/




portafilter_size = 58;
// the number of containers on one shelf, such as two little dips to hold damper and WDT and one recess for the portafilter itself
num_container = 3;
spacer_size = 10;

num_shelfs = 2;
wall_thickness = 5;
shelf_dist = portafilter_size * 1.5;
portafilter_hold_width = portafilter_size * 0.9;
portafilter_hold_depth = 40;
portafilter_hold_neck_width = 20;
shelf_width = portafilter_size * 2 + wall_thickness * 2 + 4 * spacer_size + portafilter_hold_width;
usable_space = shelf_width - 2 * wall_thickness;// The usable witdh on a shelf between the two stabilizers
edge_radius = 2;



// The backplate of the shelf
roundedcube([shelf_width, num_shelfs * shelf_dist * .82, wall_thickness], false, edge_radius);


translate([0, shelf_dist, 0]) {

  //shelf1();
    
  translate([0, 0, 0]) {
    difference() {
      shelf1();

      translate([wall_thickness + spacer_size + portafilter_size / 2, wall_thickness + 1, portafilter_size * .75 + wall_thickness / 2])
        58mm_pit();
      translate([wall_thickness + spacer_size * 2 + portafilter_size * 1.5, wall_thickness + 1, portafilter_size * .75 + wall_thickness / 2])
        58mm_pit();
    }
  }  
}


difference() {
  translate([0, 0, 0]) {
    difference() {
      shelf1();

      translate([wall_thickness + spacer_size + portafilter_size / 2, wall_thickness + 1, portafilter_size * .75 + wall_thickness / 2])
        58mm_pit();
      translate([wall_thickness + spacer_size * 2 + portafilter_size * 1.5, wall_thickness + 1, portafilter_size * .75 + wall_thickness / 2])
        58mm_pit();
    }
  }

  translate([wall_thickness + spacer_size * 3 + portafilter_size * 2, -2, 25 + wall_thickness / 2])
    portafilter_pit();
}


module stabiliser() {
  b = 50;
  h = 50;
  w = wall_thickness;

  //Start with an extruded triangle
  rotate(a = [0, -90, 0]) {
    linear_extrude(height = w, center = true, convexity = 10, twist = 0) {
      polygon(points = [
        [0, 0], 
        [h, 0], 
        [0, b]
      ], paths = [
        [0, 1, 2]
      ]);
    }

  }
}

module shelf1() {
  roundedcube([shelf_width, wall_thickness, portafilter_size * 1.5], false, edge_radius);
  translate([wall_thickness / 2 + edge_radius, wall_thickness, 0])
    stabiliser();
  translate([wall_thickness / 2 + shelf_width - wall_thickness - edge_radius, wall_thickness, 0])
    stabiliser();
}


module 58mm_pit() {
  rotate(a = [90, -90, 0]) {
    cylinder(h = wall_thickness / 3, r = portafilter_size / 2);
  }
}

module portafilter_pit() {
  roundedcube([portafilter_hold_width, wall_thickness + 10, portafilter_hold_depth], false, 5);
  translate([portafilter_size * 0.9 / 2 - 10, 0, 38])
    cube([portafilter_hold_neck_width, wall_thickness + 10, 30]);

}


  translate([(usable_space - portafilter_hold_width) /2, 5, 0]) {
      rotate(a = [0, -90, 0]) {
        wall_hook();
      }
  }

// More information: https://danielupshaw.com/openscad-rounded-corners/

// Set to 0.01 for higher definition curves (renders slower)
$fs = 0.15;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
  // If single value, convert to [x, y, z] vector
  size = (size[0] == undef) ? [size, size, size] : size;

  translate_min = radius;
  translate_xmax = size[0] - radius;
  translate_ymax = size[1] - radius;
  translate_zmax = size[2] - radius;

  diameter = radius * 2;

  obj_translate = (center == false) ? [0, 0, 0] : [-(size[0] / 2), -(size[1] / 2), -(size[2] / 2)];

  translate(v = obj_translate) {
    hull() {
      for(translate_x = [translate_min, translate_xmax]) {
        x_at = (translate_x == translate_min) ? "min" : "max";
        for(translate_y = [translate_min, translate_ymax]) {
          y_at = (translate_y == translate_min) ? "min" : "max";
          for(translate_z = [translate_min, translate_zmax]) {
            z_at = (translate_z == translate_min) ? "min" : "max";

            translate(v = [translate_x, translate_y, translate_z])
              if ((apply_to == "all") || (apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") || (apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") || (apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")) {
                sphere(r = radius);
              } else {
                rotate = (apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : ((apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] : [0, 0, 0]);
                rotate(a = rotate)
                  cylinder(h = diameter, r = radius, center = true);
              }
          }
        }
      }
    }
  }
}




// From https://github.com/gpambrozio/OpenSCAD/blob/master/door-hook.scad


wall_hole_d = 0;
wall_hole_offset = 10;

/* [Door parameters] */
// Door thickness (inner distance between front and back of door hook)
clip_depth = 37;
// Thickness of top and overhang (make sure it fits gap between door and frame)
top_and_back_thickness = 2;

/* [Hook parameters] */
// Width of entire hook
width = 30;
// Thickness of front piece and hanger hooks
hook_and_front_thickness = 4;
// Length of overhang on back side of the door
clip_length = 55;


number_of_hooks = 1;
// Distance between top of door and first hanger hook
first_hook_offset = 35;  // rounded: 60
// Distance between successive hanger hooks (if more than one)
hook_distance = 60;  // rounded: 60
// Radius of hanger hook curve
hook_radius = 15;

hook_style = "rounded"; // [simple:Simple,rounded:Rounded]

/* [Advanced] */

// Angle back of clip inwards (towards door), to help with friction; don't go crazy with this or you'll put too much stress on clip
clip_angle = 1;
// Add support buttress on hooks (except last); might help reduce flex, but looks a bit uglier (IMO)
inner_hook_buttress = 0; // [0:No,1:Yes]

double_sided = 1; // [0:No,1:Yes]

/* [Hidden] */

$fn = 72;
thickness = hook_and_front_thickness;
top_thickness = top_and_back_thickness;
back_thickness = double_sided ? thickness : top_thickness;

module hook_base() {
  difference() {
    cylinder(h=width, r=hook_radius+thickness);
    translate([0,0,-1])
      cylinder(h=width+2, r=hook_radius);
    translate([-hook_radius-thickness-1, 0, -1]) 
      cube([2*(hook_radius+thickness+1), hook_radius+thickness+1, width+2]); 
  }
}

module simple_hook() {
  translate([hook_radius+thickness, 0, 0]) union() {
    hook_base();
    translate([hook_radius+thickness/2, 0, 0])
      cylinder(h=width, r=thickness/2, $fn=18);
  }
}

module rounded_hook() {
  translate([0, -hook_radius-thickness, 0]) difference() {
    intersection() {
      cube([2*(hook_radius+thickness), 1.5*hook_radius+thickness+1, width]);
      translate([0, 0, width/2]) rotate([0, 90, 0]) cylinder(h=2*(hook_radius+thickness), r=1.5*hook_radius+thickness);
      translate([hook_radius+thickness, hook_radius+thickness, -1]) cylinder(r=hook_radius+thickness, h=width+2);
    }
    translate([hook_radius+thickness, hook_radius+thickness, -1]) cylinder(r=hook_radius, h=width+2);
    translate([-1, hook_radius+thickness, -1]) cube([hook_radius+thickness+2, hook_radius, width+2]);
  }
}

module hook() {
  if (hook_style == "simple") {
    simple_hook();
  } else if (hook_style == "rounded") {
    rounded_hook();
  }
}

module clip() {
  front_length = first_hook_offset + (number_of_hooks - 1) * hook_distance;
  back_length = double_sided ? front_length : clip_length;
  union() {
    translate([-clip_depth-back_thickness, 0, 0]) rotate([0, 0, clip_angle]) translate([0, -back_length, 0])
      cube([back_thickness, back_length, width]);
    translate([-clip_depth-back_thickness, 0, 0])
      cube([clip_depth + back_thickness + thickness, top_thickness, width]);
    translate([0, -front_length, 0])
      cube([thickness, front_length, width]);
  }
}

butt_theta = acos(hook_radius/(hook_radius+thickness));
module each_hook(i) {
  translate([0, -first_hook_offset-i*hook_distance+.1, 0]) union() {
    hook();
    if ((i < number_of_hooks-1) && (inner_hook_buttress != 0)) {
      translate([0,-(hook_radius+thickness)*tan(butt_theta),0]) rotate([0, 0, butt_theta]) translate([0, -thickness, 0]) cube([thickness*(1+1/cos(butt_theta)),thickness,width]);
    }
  }
}

module door_hook() {
  clip();
  for (i = [0:(number_of_hooks-1)]) {
    each_hook(i);
    if (double_sided) {
      translate([-clip_depth, 0, width])
      rotate([0, 0, clip_angle])
      rotate([0, 180, 0])
      each_hook(i);
    }
  }
}

module wall_hook() {
  difference() {
    union() {
      front_length = first_hook_offset + (number_of_hooks - 1) * hook_distance;
      translate([0, -front_length, 0]) cube([thickness, front_length, width]);
      for (i = [0:(number_of_hooks-1)]) {
        each_hook(i);
      }
    }
    translate([-1, -wall_hole_offset, width/2]) rotate([0, 90, 0]) cylinder(d=wall_hole_d, h=thickness+2);
    translate([thickness/2+.1, -wall_hole_offset, width/2]) rotate([0, 90, 0]) cylinder(d1=wall_hole_d, d2=wall_hole_d*2, h=thickness/2);
    
  }
}

