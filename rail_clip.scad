
rail_r = 28/2;
width = 15.1;

ring_width = 2;
pully_width = 12*sqrt(2)-1.25;
pully_height = 30;
pully_shaft_r = 7.6/2;
shaft_length = 4;
gate_bottom_space = 20;
gate_top_space = 1;
gate_width = ring_width;
cut_width = 0.2;

module gate(){
  difference(){
    translate([-pully_width/2-gate_width,-width/2,0]){
      cube([pully_width+gate_width*2, width, pully_height+gate_bottom_space+gate_top_space+rail_r]);
    }
    translate([-pully_width/2,-width,gate_width]){
      cube([pully_width, width*2, pully_height+gate_bottom_space+gate_top_space+rail_r-gate_width*2]);
    }
    translate([0,0,pully_height+gate_bottom_space+gate_top_space+rail_r-gate_width/2]){
      rotate([0,0,45]){
        cube([cut_width, width*2, gate_width*2],center = true);
      }
    }
  }
    
  translate([-pully_width/2-gate_width/2,0,pully_height/2+  gate_bottom_space+rail_r-gate_width]){
    rotate([0,90,0]){
      difference(){
        cylinder(h=pully_width+gate_width,r=pully_shaft_r);
        translate([0,0,+gate_width/2+shaft_length]){
          groove();
        }
        translate([0,0,pully_width+gate_width/2-shaft_length]){
          groove();
        }
        translate([0,0,+gate_width/2+pully_width/2]){
          cube([50,50,pully_width-2*shaft_length],center = true);
        }
      }
    }
    
  }
}

module groove() {
 rotate_extrude(convexity = 100){ 
   translate([pully_shaft_r, 0, 0]){
     rotate(45){
       square([pully_shaft_r/2,pully_shaft_r/2],center = true); 
     }
   }
 }
 
}

module rail(){
  rotate([90,0,0]){
    translate([0,0,-width]){
      cylinder_outer(width*2,rail_r,32);
    }
  }
}

module ring(){
  rotate([90,0,0]){
    translate([0,0,-width/2]){
      cylinder(h=width,r=rail_r+ring_width);
    }
  }
}

module cylinder_outer(height,radius,fn){
 fudge = 1/cos(180/fn);
 cylinder(h=height,r=radius*fudge,$fn=fn);
}

difference(){
  union(){
    ring();
    gate();
  }
  rail();
}
