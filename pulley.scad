//hub
hub = false;
hub_z = 7;
hub_r = 8;

//shaft
shaft = "round"; //"square" "rectangle", "round", "round_cut"
shaft_a = 4;//4.97/2;
shaft_b = 4.52/2;

//wheel
wheel_r = 15;

//grooves
grooves_num = 2;
groov_depth = 6;


//----------------------------------------------------
wheel_z = groov_depth*sqrt(2)*grooves_num-(1.25*(grooves_num-1));

module body() {
 total_z = hub_z + wheel_z;
 difference() {
   if(hub){
       cylinder(h=total_z,r=hub_r);
   }else{
       main_wheel();
   }
   shaft(total_z);
 }
 if(hub){
    main_wheel();
 }
}

module shaft(total_z){
  if(shaft == "square"){
    translate([-shaft_a/2,-shaft_a/2,-total_z/2]) {
      cube([shaft_a,shaft_a,total_z*2], 1);
    }
  }else if(shaft == "rectangle"){
    translate([-shaft_a/2,-shaft_b/2,-total_z/2]) {
      cube([shaft_a,shaft_b,total_z*2], 1);
    }
  }else if(shaft == "round"){
    translate([0,0,-total_z/2]) {
      cylinder_outer(total_z*2, shaft_a,24);
    }
  }else if(shaft == "round_cut"){
    translate([0,0,-total_z/2]) {
      difference() {
        cylinder_outer(total_z*2, shaft_a,24);
        translate([shaft_b,-shaft_a*2,-total_z/2]) {
          cube([shaft_a*4,shaft_a*4,total_z*2], 1);
        }
      }
    }
  }
}

module cylinder_outer(height,radius,fn){
 fudge = 1/cos(180/fn);
 cylinder(h=height,r=radius*fudge,$fn=fn);
}
module main_wheel(){
  cylinder(h=wheel_z,r=wheel_r);
}

module screws() {
  translate([0,0,wheel_z+(hub_z/2)]) 
    rotate(90,[0,1,0]) 
      translate([0,0,-15]) 
        cylinder(h=30,r=2);
}

module groove() {
 rotate_extrude(convexity = 100){ 
   for(i = [1: grooves_num]){
     translate([wheel_r+1.25, (groov_depth*sqrt(2)-1.25)*(i-1), 0])
       rotate(45)
         square([groov_depth,groov_depth],0); 
   }
 }
}

module no_screws() {
  difference() {
    body();
    groove();
  }
}

difference() {
  no_screws();
  screws();
}