
// Alter these first four values to change the size and
// thickness of your cabinet.
//
// Note: Dimensions are INTERNAL, that is, your cabinet will
// be this big INSIDE.   It will be bigger by twice the thickness
// on the outside.   Sorry, no Time Lord technology in use here.
//
// Default size fits a Wanhao Duplicator i3 plus
// For a Tronxy X3A: 600,600,600
// For a Tranxy X5-400: 800, 700, 700, thickness=18

width = 500;
depth = 500;
height = 700;
thickness = 12;

// Only change the below if you want to change the proportions
// of the windows and drawer
//
top = depth / 5;
border = 50;
borderradius = border/2;
windowrebate=10;

drawer_thickness = 12;
drawer_height = 120;

// You should only need to change the drawer border if
// you are not using standard ballbearing drawer slides

drawer_side_border = 25;
drawer_bottom_border = 20;
drawer_top_border = 10;

// You should not need to change anything beyond here

topwindow_width = width+2*thickness;
topwindow_depth = depth+thickness-top;

frontwindow_width = width+2*thickness;
frontwindow_depth = (height+2*thickness-drawer_height)/2;

fuzz = 0.4;

module piece(w, d, name) {
    echo(str("  Cut one ", name, " piece ", w, " wide by ", d, " deep."));
    cube([w,d,thickness]);
    translate([w/2, d/2, thickness+fuzz]) color("blue") { //linear_extrude(height=50) { 
        text(text=name, 
            halign="center", valign="center",
            size=50,
            font="Avenir Next Condensed:style=Demi Bold"
        ); 
    }
}

module base() {
    piece(width+2*thickness, depth+thickness, "base");
}
//base();

module back() {
    piece(width+2*thickness, height, "back");
}
//back();

module side() {
    piece(depth, height, "side");
}
//side();

module top() {
    piece(width+2*thickness, top, "top rail");
}
//top();

module window(w, d, name) {
    c = border + borderradius; // center offset
    rr = borderradius+windowrebate; //rebate radius
    rc = border + borderradius - windowrebate; // rebate center offset

    difference() {
        piece(w, d, str(name, " window"));
        echo(str("   Drill four ", 2*borderradius, " dia holes centered ", c, " in from the edges."));
        echo(str("   Join the four holes with a jigsaw, then use a router to cut a ", windowrebate, " mm rebate (or rabbet if are Amerikanski)."));
        hull() {
            translate([c, c,-fuzz]) cylinder(r=borderradius, h=thickness+2*fuzz);
            translate([w-c,c,-fuzz]) cylinder(r=borderradius, h=thickness+2*fuzz);
            translate([c,d-c,-fuzz]) cylinder(r=borderradius, h=thickness+2*fuzz);
            translate([w-c,d-c,-fuzz]) cylinder(r=borderradius, h=thickness+2*fuzz);
        }
        hull() {
            translate([rc, rc,-fuzz]) cylinder(r=rr, h=thickness/2+fuzz);
            translate([w-rc,rc,-fuzz]) cylinder(r=rr, h=thickness/2+fuzz);
            translate([rc,d-rc,-fuzz]) cylinder(r=rr, h=thickness/2+fuzz);
            translate([w-rc,d-rc,-fuzz]) cylinder(r=rr, h=thickness/2+fuzz);
        }
    }
}

module topwindow() {
    window(topwindow_width, topwindow_depth, "top");
}
//topwindow();

module frontwindow() {
    window(frontwindow_width, frontwindow_depth, "front");
}

module drawerfalsefront() {
    piece(width+2*thickness, drawer_height, "drawer false front");
}

module drawerbase() {
    piece(width-2*drawer_side_border, depth-drawer_thickness, "drawer base");
}

module drawerside() {
    piece(depth-drawer_thickness, drawer_height-drawer_top_border-drawer_thickness-drawer_bottom_border, "drawer side");
}

module drawerfrontback(name) {
    piece(width-2*drawer_side_border-2*drawer_thickness, drawer_height-drawer_top_border-drawer_thickness-drawer_bottom_border, str("drawer ",name));
}

module drawer_assembled() {
    drawerbase();
    translate([drawer_thickness, drawer_thickness, drawer_thickness]) rotate([90,0,0]) color("orange") drawerfrontback("front");
    translate([drawer_thickness, depth-drawer_thickness, drawer_thickness]) rotate([90,0,0]) color("black") drawerfrontback("back");
    translate([0, 0, drawer_thickness]) rotate([90,0,90]) color("yellow") drawerside();
    translate([width-2*drawer_side_border-drawer_thickness, 0, drawer_thickness]) rotate([90,0,90]) color("red") drawerside();
}


module assembled() {
    base();
    translate([0,depth+thickness, thickness]) rotate([90,0,0]) color("black") back();
    translate([0,0,thickness]) rotate([90,0,90]) color("yellow") side();
    translate([width+thickness,0,thickness]) rotate([90,0,90]) color("red") side();
    translate([0, depth+thickness-top, height+thickness]) color("blue") top();
    translate([0, 0, height+thickness]) color("cyan") topwindow();
    translate([0, 0, 0]) rotate([90,0,0]) color("orange") drawerfalsefront();
    translate([0, 0, drawer_height]) rotate([90,0,0]) color("magenta") frontwindow();
    translate([0, 0, drawer_height+frontwindow_depth]) rotate([90,0,0]) color("green") frontwindow();

    translate([-width-drawer_height, 0, 0]) drawer_assembled();
}
//assembled();

module parts() {
    g = 4*thickness; // gap
    base();
    translate([width+g,0,0]) side();
    translate([width+g+depth+g,0,0]) side();
    translate([0, depth+g, 0]) back();
    translate([0, depth+g+height+g, 0]) top();
    translate([width+g,height+g,0]) topwindow();
    translate([width+g,height+g+topwindow_depth+g,0]) drawerfalsefront();
    translate([width+g+depth+g,0,0]) side();
    translate([width+g+depth+g, height+g]) {
        frontwindow();
        translate([0,frontwindow_depth+g,0]) frontwindow();
    }

    do = width+g+depth+g+width+g; // drawer offset
    translate([do,0,0]) drawerbase();
    translate([do,depth+g,0]) drawerfrontback("front");
    translate([do,depth+g+drawer_height,0]) drawerfrontback("back");
    translate([do,depth+g+2*drawer_height,0]) drawerside("");
    translate([do,depth+g+3*drawer_height,0]) drawerside("");

//    translate([drawer_thickness, depth-drawer_thickness, drawer_thickness]) rotate([90,0,0]) color("black") drawerfrontback("back");
//    translate([0, 0, drawer_thickness]) rotate([90,0,90]) color("yellow") drawerside();
//    translate([width-2*drawer_side_border-drawer_thickness, 0, drawer_thickness]) rotate([90,0,90]) color("red") drawerside();

}

echo("");
echo("PARTS LIST STARTS HERE");
echo(str("To make cabinet with internal dimensions ", width, " wide by ", depth, " deep by ", height, " tall:"));
translate([-width-drawer_height,0,0]) assembled();
echo("PARTS LIST ENDS HERE");
echo("");
echo("(ignore further instructions)");

parts();
