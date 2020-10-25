
hub = false;
hub_z = 7;
hub_r = 8;

shaft_a = 3;
shaft_b = 5;

v_depth = 6;

wheel_r = 15;
wheel_z = v_depth*sqrt(2);

module body() {
 carve_x = 10;
 total_z = hub_z + wheel_z;
 difference() {
   if(hub){
       cylinder(h=total_z,r=hub_r);
   }else{
       main_wheel();
   }
   translate([-shaft_a/2,-shaft_b/2,0]) {
     cube([shaft_a,shaft_b,total_z], 1);
   }
 }
 if(hub){
    main_wheel();
 }
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
 rotate_extrude(convexity = 100) 
   translate([wheel_r+1.25, 0, 0])
     rotate(45)
       square([v_depth,v_depth],0); 
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