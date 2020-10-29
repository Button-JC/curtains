
rail_r = 28/2+0.5;
width = 15.1;

ring_width = 2;
pully_width = 12*sqrt(2)-1.25;
pully_height = 30;
pully_shaft_r = 7.6/2-0.3;
shaft_length = 6;
gate_bottom_space = 20;
gate_top_space = 1;
gate_width = ring_width;
cut_width = 0.4;

lock_type = "double"; // "none"/"single"/"double"

module gate(){
  difference(){
    translate([-pully_width/2-gate_width,-width/2,0]){
      cube([pully_width+gate_width*2, width, pully_height+gate_bottom_space+gate_top_space+rail_r]);
    }
    translate([-pully_width/2,-width,gate_width]){
      cube([pully_width, width*2, pully_height+gate_bottom_space+gate_top_space+rail_r-gate_width*2]);
    }
    translate([0,0,pully_height+gate_bottom_space+gate_top_space+rail_r-gate_width/2]){
      rotate([0,0,lock_type=="none"?45:0]){
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

module lock(){
  translate([0,0,pully_height + gate_bottom_space+rail_r+gate_width+ cut_width]){
    difference(){
      union(){
        cube([pully_width,width/2,gate_width],center = true);
        translate([-pully_width/4,0,-gate_width/2]){
          cube([pully_width/2-cut_width,width/2,gate_width],center = true);
        }
      }
      translate([+pully_width/4,0,0]){
        cube([pully_width/2-gate_width*2,width/2-gate_width,gate_width*2],center = true);
      }
    }
    X0 = (pully_width/2-gate_width*2)/2-cut_width;
    Y0 = (-width/4-gate_width)+2*cut_width;
    Z0 = gate_width+cut_width;
    translate([+X0+gate_width/2,-Y0/2,-Z0/2-cut_width]){
      prism_latch(X0,Y0,Z0) ;
    }
  }
}  
 module prism_latch(l, w, h){
   polyhedron(
       points=[
          [0,0,0],    //0
          [l*2,0,0],  //1
          [l*2,w,0],  //2
          [0,w,0],    //3
          [l,w/4,h],    //4
          [l*2,w/4,h],  //5
          [l*2,w/4*3,h],  //6
          [l,w/4*3,h]],    //7
       faces=[
          [0,1,2,3],  // bottom
          [4,5,1,0],  // front
          [7,6,5,4],  // top
          [5,6,2,1],  // right
          [6,7,3,2],  // back
          [7,4,0,3]   // left
       ]
   );
}
  
difference(){
  union(){
    ring();
    gate();
    if(lock_type=="single"){
      lock();
    }
    if(lock_type=="double"){
      translate([0,-width/4+cut_width,0]){
        lock();
      }
      translate([0,+width/4-cut_width,0]){
        lock();
      }
    }
  }
  rail();
}
