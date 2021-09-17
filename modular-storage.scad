include <modular-storage.parameters.scad>;
include <common-functions.scad>;


show_assembled     = false;
display_separation = 10;


//
// a dovetail is a set of blocks
// (use it in a difference, or as an add)
// it lays out the subtractive cuts, modulo up to the space made available
// offset true adds extra for difference and moves it
//
module dovetail_maker(dt_width, dt_height, dovetail_sep, panel_thickness, dt_height_space, offset = true, extra = true) { 

    // we take away one finger (theory is we alaways can fit one)
    // then divide the remaining space with a separator space and a finger
    dt_count = floor(( dt_height_space - dt_height)  / ( dt_height + dovetail_sep)) ;

    gap = (dt_height_space - ( (dt_count * ( dt_height + dovetail_sep) ) + dt_height )) / 2;
    

    move( y= gap) {
      for (i = [ 0 : dt_count ]) {
        move(y = (i * ( dovetail_sep + dt_height) ) )
            move(x=( offset ? -1 : 0), z=(extra? -0.5 : 0)) cube([dt_width + (extra? 1 : 0), dt_height, panel_thickness + (extra? 1 : 0)]);
      }
    }

}


module drawer_side_maker(height_stacked_count) { 

    d_depth          = drawer_depth;
    d_height         = draws_height_n_by(height_stacked_count);
    d_thickness      = draw_side_thickness;

    // where, on sides, do we put the dovetails ?
    dovetail_bottom_offset = draw_bottom_thickness + dovetail_finger_clearance;
    dovetail_total = dovetail_finger_gap + dovetail_finger_size;

    difference() { 
        cube([d_depth, d_height, d_thickness]);
        // cut off a front strip, so we can put the dovetails in place
        move(y=-0.5, x=-1, z=-0.5)cube([draw_front_back_thickness+1, d_height+1, d_thickness + 1]);

        // cut off a rear strip, so we can put the dovetails in place
        move(y=-0.5, x=d_depth - draw_front_back_thickness, z=-0.5)cube([draw_front_back_thickness+1, d_height+1, d_thickness + 1]);

        // bottom dovetail cutouts
        move(y=draw_bottom_thickness, x=draw_side_thickness + dovetail_finger_clearance)
            move(rz=-90)
                dovetail_maker(dt_width       = draw_bottom_thickness
                        , dt_height       = dovetail_finger_size
                        , dovetail_sep    = dovetail_finger_gap
                        , panel_thickness = d_thickness
                        , dt_height_space = (d_depth - (2* dovetail_finger_clearance) -(2 * draw_side_thickness))
                        , offset = false);

    }
    
    // front dovetails
    move(y=dovetail_bottom_offset)
        dovetail_maker(dt_width        = draw_side_thickness
                    , dt_height       = dovetail_finger_size
                    , dovetail_sep    = dovetail_finger_gap
                    , panel_thickness = d_thickness
                    , dt_height_space = (d_height - (2* dovetail_finger_clearance)- dovetail_bottom_offset)
                    , offset = false
                    , extra = false);

    // rear dovetails
    move(y=dovetail_bottom_offset, x=d_depth- draw_front_back_thickness)
        dovetail_maker(dt_width        = draw_side_thickness
                    , dt_height       = dovetail_finger_size
                    , dovetail_sep    = dovetail_finger_gap
                    , panel_thickness = d_thickness
                    , dt_height_space = (d_height - (2* dovetail_finger_clearance) - dovetail_bottom_offset)
                    , offset = false,
                    , extra = false);

}


module drawer_base_n(width_stacked_count) {
    
    d_width          = draws_width_n_by(width_stacked_count);
    d_thickness      = draw_bottom_thickness;
    d_depth          = drawer_depth;

    // where, on sides, do we put the dovetails ?
    dovetail_bottom_offset = draw_bottom_thickness + dovetail_finger_clearance;
    dovetail_total = dovetail_finger_gap + dovetail_finger_size;
    
    difference() { 
        cube([d_width, d_depth, d_thickness]);
        
        // front cut
        move(z=-0.5, y = -1, x=-0.5) cube([d_width+1, draw_front_back_thickness+1, d_thickness+1]);

        // back cut
        move(z=-0.5, y = d_depth - draw_front_back_thickness, x=-0.5) cube([d_width+1, draw_front_back_thickness+1, d_thickness+1]);

        // left cut
        move(z=-0.5, y = -0.5 , x=-1) cube([draw_side_thickness+1, d_depth + 1, d_thickness+1]);

        // right cut
        move(z=-0.5, y = -0.5 , x=d_width - draw_side_thickness) cube([draw_side_thickness+1, d_depth + 1, d_thickness+1]);

    }
    
    // left
    move(y=draw_front_back_thickness + dovetail_finger_clearance)
    dovetail_maker(dt_width       = draw_side_thickness
            , dt_height       = dovetail_finger_size
            , dovetail_sep    = dovetail_finger_gap
            , panel_thickness = d_thickness
            , dt_height_space = (d_depth - (2* dovetail_finger_clearance) - (2 * draw_front_back_thickness))
            , offset = false
            , extra = false);

    //right
    move(x=d_width - draw_side_thickness, y=draw_front_back_thickness + dovetail_finger_clearance) 
        dovetail_maker(dt_width       = draw_side_thickness
            , dt_height       = dovetail_finger_size
            , dovetail_sep    = dovetail_finger_gap
            , panel_thickness = d_thickness
            , dt_height_space = (d_depth - (2* dovetail_finger_clearance) - (2 * draw_front_back_thickness))
            , offset = false
            , extra = false);


    // front
    move(rz=-90, y=draw_front_back_thickness, x = dovetail_finger_clearance + draw_side_thickness)
        dovetail_maker(dt_width       = draw_front_back_thickness
            , dt_height       = dovetail_finger_size
            , dovetail_sep    = dovetail_finger_gap
            , panel_thickness = d_thickness
            , dt_height_space = (d_width - (2* dovetail_finger_clearance) - (2 * draw_side_thickness))
            , offset = false
            , extra = false);

    // back
    move(rz=-90, y=d_depth, x = dovetail_finger_clearance + draw_side_thickness)
        dovetail_maker(dt_width       = draw_front_back_thickness
            , dt_height       = dovetail_finger_size
            , dovetail_sep    = dovetail_finger_gap
            , panel_thickness = d_thickness
            , dt_height_space = (d_width - (2* dovetail_finger_clearance) - (2 * draw_side_thickness))
            , offset = false
            , extra = false);

}

//
// a front or a back of a drawer
//
module drawer_front_back_n_by_n(width_stacked_count, height_stacked_count, isfront=true) {
    
    d_width          = draws_width_n_by(width_stacked_count);
    d_height         = draws_height_n_by(height_stacked_count);
    d_thickness      = draw_front_back_thickness;

    // where, on sides, do we put the dovetails ?
    dovetail_bottom_offset = draw_bottom_thickness + dovetail_finger_clearance;
    dovetail_total = dovetail_finger_gap + dovetail_finger_size;


    difference() { 
       cube([d_width, d_height, d_thickness]);
       if ( isfront) move(y=d_height,z=-0.5, x=d_width/2) cylinder(r=draw_grab_hole_height, h=d_thickness+1);

        // left dovetail cutouts
        move(y=dovetail_bottom_offset)
            dovetail_maker(dt_width        = draw_side_thickness
                        , dt_height       = dovetail_finger_size
                        , dovetail_sep    = dovetail_finger_gap
                        , panel_thickness = d_thickness
                        , dt_height_space = (d_height - (2* dovetail_finger_clearance)- dovetail_bottom_offset)
                        , offset = true);

        // right dovetail cutouts
        move(y=dovetail_bottom_offset, x=d_width- d_thickness)
            dovetail_maker(dt_width        = draw_side_thickness
                        , dt_height       = dovetail_finger_size
                        , dovetail_sep    = dovetail_finger_gap
                        , panel_thickness = d_thickness
                        , dt_height_space = (d_height - (2* dovetail_finger_clearance)- dovetail_bottom_offset)
                        , offset = false);

        

        // bottom dovetail cutouts
        move(y=draw_bottom_thickness, x=draw_side_thickness + dovetail_finger_clearance)
           move(rz=-90)
                dovetail_maker(dt_width       = draw_bottom_thickness
                        , dt_height       = dovetail_finger_size
                        , dovetail_sep    = dovetail_finger_gap
                        , panel_thickness = d_thickness
                        , dt_height_space = (d_width - (2* dovetail_finger_clearance)- (2 * draw_side_thickness))
                        , offset = false);



        }


}

module drawer_front_n_by_n(ws, hs) { drawer_front_back_n_by_n(ws,hs, isfront = true); }
module drawer_back_n_by_n(ws, hs) { drawer_front_back_n_by_n(ws,hs, isfront = false); }


module draw(a, b) { 

    move(x=draws_width_n_by(a) + display_separation) drawer_front_n_by_n(a,b);
    drawer_back_n_by_n(a,b);

    move ( y = draws_height_n_by(b) + display_separation) {
        drawer_side_maker(b);
    }

    move ( y = (draws_height_n_by(b) + display_separation) * 2 ) {
        drawer_side_maker(b);
    }

    move ( y = draws_height_n_by(b) + display_separation, x = drawer_depth + display_separation) {
        drawer_base_n(a);
    }
    // dovetail_maker(dt_width=3,  dt_height = 10 , dovetail_sep= 20 , panel_thickness = 3 , dt_height_space = 90, offset = false);    
}

draw(3,3);