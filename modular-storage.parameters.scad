
//
// Enter the dimensions of the stock you are
// using
//
draw_stock_thickness      = 3;
cabinetry_stock_thickness = 10;

//
// the base "modules" width (I wanted an internal dimension of 300mm)
//
cabinetry_width           = 300;
cabinetry_height          = 300;
cabinetry_depth           = 300;


//
// the spared, shared, between two drawers, or the draw and a wall
//
draws_gap                 = 0.9;
draw_front_back_thickness = draw_stock_thickness;
draw_bottom_thickness     = draw_stock_thickness;
draw_side_thickness       = draw_stock_thickness;
draw_grab_hole_height     = 15;
drawer_depth              = cabinetry_depth - cabinetry_stock_thickness;


// dovetail finger size
dovetail_finger_size      = 20;
dovetail_finger_gap       = 15;
dovetail_finger_clearance = 5; // how far from ends should we keep clear

//                               total             - left and right outer walls         n+1 extra space of the gap 
function draws_width_n_by(n)  = ( cabinetry_width  - (cabinetry_stock_thickness * 2) - ((n + 1) * draws_gap) ) / n;

//                               total             - top and bottom                  - shelves for drawers               - draw gap 
function draws_height_n_by(n) = ( cabinetry_height - (cabinetry_stock_thickness * 2) - ((n-1)*cabinetry_stock_thickness) - (n* draws_gap) ) / n;

