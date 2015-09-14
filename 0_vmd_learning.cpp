= reset view


// ##### coloring method #####
ResType: non-polar white, basic blue, acidic red, polar green
Name: O red, N blue, C cyan S yellow
Structure: alpha-purple, beta-yellow, 3-10 helix-blue, turn-cyan, coil-white


// ##### Selections #####
protein, helix, 
resname LYS
(not helix) and (not betasheet) 
water and (within 3 of helix)
(within 3 of helix) and water
resid 1 4 5 to 9 22
* Extensions->analysis->Sequence viewer
// ref for selection:
http://www.ks.uiuc.edu/Research/vmd/vmd-1.3/ug/node132.html
http://www.ks.uiuc.edu/Research/vmd/vmd-1.8.3/ug/node81.html



// ##### Save figures, Rendering #####
Extensions-> visualization->ViewMaster	// keep view point
// ##### Creat new material for better representation #####
Graphics->Material	// duplicate transparent, and adjust, use white color looks good
// ***** Display->Rendermode->GLSL looks really good. I guess they use render resolution to display.
// ***** orthographic (close look with depth cueing); Perspective (remote view)



// ##### Extensions -> Tk console #####
 41 % source vmd_learning_2.vmd
>Main< (vmd) 42 % graphics top text { 40 0 20} "my dear molecule"


// recalculate secondary structure.
vmd_calculate_structure 0    // 0 is molID


// ##############################################
//            useful reference:
// ##############################################
1.vmd use program STRIDE ( Frishman et al. Proteins 23:566 1995 to compute the secondary structure according to an heuristic algorithm.
