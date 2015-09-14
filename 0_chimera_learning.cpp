Similarly, the selection scope can be narrowed using the ↓ key. The → key inverts the selection so that selected atoms become deselected and vice versa. 


open 1zik;   close 0;   stop; // close model #0; stop chimera; 
copy png file ~/home/john/Dropbox/  // save image, awesome.
windowsize 800 600
copy png file /home/abc/xxx.png  width 1600  height 1200  // OMG, it saves high resolution so easy!!!, damn VMD.
copy png file ../pic_tp/iii.png  unit inches dpi 300
set bg_color white // set background color.
  
preset apply int 2
preset apply pub 1
start Side View

delete solvent
delete :.a;    delete solvent | ligand | ions
delete #0:.b-f

focus ligand & #0
scale 2
savepos pos1 //A position includes the scale, locations, and orientations of the structures. 
reset pos1 30  // Amazing!!!!!
reset pos2 120 // the number following 

split 
color sea green #0.1
color medium purple #0.2
//Splitting the model facilitates moving the chains independently, and is also one way to make molecular surfaces enclose each chain separately instead of both chains collectively. The original model #0 is now model #0.1 (green) containing chain A, and model #0.2 (purple) containing chain B. Models are listed in the Model Panel (under Favorites in the menu). 

color hot pink :lys
color cyan :.a
colors: yellow; orange; cyan; magenta; green; 
colors: coral, turquoise, and medium purple, sea green, dodger blue
~color
color byelement; byhet (heteroatoms, not include carbon.)
color white C // color carbon atoms white, !
color red,a,s,r ligand  // a is for atoms only; s,r  for surface and ribbon
help color

rangecolor bfactor key 2 blue 30 red 50 yellow

// Selection:   ~sel (de select)
#model_number
:residue number/name
:.chain ID
@atom_name
* = ? wildcard
z< ; z>
& | ~  // and or not
//e.g.
col orange :5-9.a,12.a,8.b
color magenta :14-18
:hoh   :dc,da,dt   solvent   :leu.b   
:.a@n,ca,c,o // backbone of chain A.
#0:296-end  // = #0:296,
sel :168,170 & without CA/C1'  // side chain without base CA


// in preset int 1, chimera always display the sidechains around ligand, ligand, and ions. "~disp" can remove them.
disp :leu.b
disp solvent
disp :hoh
~disp solvent
show @ca // display "only" atom named CA

alias myres  #0:17,138,190#1:38,158,221#2:86,247,342
show myres
// alias commands (use as functions), ^ means only apply at the beginning of the command.
alias  ^separate  move x $1 model  #0.2; focus //$1 is a function argument. (distance along x direction that you want to move model #0.2)
alias  ^face-me  set independent;  turn y -90 model  #0.1; turn y 90 model  #0.2; ~set independent
  // usage:
  separate 20
  face-me
  separate -5

represent sphere
repr bs :.a // ball and stick for bs
repr stick; setattr m stickScale 0.5

ribbon
ribrep edged; flat; rounded
~ribbon #0:296-end
ribspline cardinal // which more closely follows the alpha carbon positions.
ribspline cardinal smoothing strand; 
ribspline bspline

surface
surface ligand
surf :gly setattr m residueLabelPos 2
surfrep mesh | solid
color red,s ligand
~surf :da.b,dt.b (da dt are in DNA sequence)

transp 50,s,a,v,r
transparency 80,a,r ligand zr>5
transp 75,s #3:60-100 frames 50 

    a - atoms (and normally, bond halves match the flanking atoms; see b for bonds-only control)
    f - ring fill
    r - ribbons
    s - molecular surfaces and nonmolecular surface models
    v - VDW surfaces
    l - atom and residue labels
    la (or al) - atom labels
    lr (or rl) - residue labels
    lb (or bl) - bond labels
    b - bonds only (not the flanking atoms); however, bond-only transparency will not be visible unless halfbond mode has been turned off, for example, by using color with the ,b specifier 

// De-Emphasizing the Ribbons
transparency 75,r
set flatTransparency //The transparent ribbons will be less obtrusive with non-angle-dependent transparency.
//Ribbon Style Editor. Start that tool (under Tools... Depiction in the menu) and adjust the Ribbon Scaling values: adjust them....Click Save As... to name and save the scaling for later use. For example, if the scaling is named slim, it could also be applied with: Command: ribscale slim 


//“hydrophobicity surface” preset: from dodger blue for the most hydrophilic, to white, to orange red for the most hydrophobic. 
rangecolor kdHydrophobicity min dodger blue 0 white max orangered
(hydrophobicity on the Kyte-Doolittle scale)
rangecol kdHydrophobicity min medium purple 0 white max orange
rangecolor kdHydrophobicity min medium purple 0 white max tan

//Electrostatic Potential: Coulombic colored surface.
Coulombic Surface Coloring (under Tools... Surface/Binding Analysis).
command: coulombic -10 red 0 white 10 blue
// convexity coloring; Attribute Calculator (Tools... Structure Analysis... Attribute Calculator). Calculate a new attribute named convexity for residues using the Formula: residue.areaSAS/residue.areaSES 
rangecolor convexity min purple 1 white max yellow

//set attribute
setattr ( a | r | m | M | b | p | g | s )  attr_name  attr_value  atom-spec
setattr m stickScale 2 


label sel // atom name by default 
rlabel sel // res_name res_number.chain
~label
Command: rlab @/display //place the labels near α-carbons instead of residue centroids.
Command: setattr m residueLabelPos 2

2dlabels create cdr2 text CDR2 color dodger blue size 24 xpos 0.65 ypos 0.75 style bold


// special display for nucleic acid.
 nuc side tube/slab  shape ellipsoid  orient false  style skinny
 nuc side tube/slab  shape box        orient true   style skinny :8-10.a
 nuc side ladder  radius 0.3 
~nuc




//###################################
//   Actions:
//###################################

match  #1:38,158,221@n,ca,c,o  #0:17,138,190@n,ca,c,o
match  #2:86,247,342@n,ca,c,o  #0:17,138,190@n,ca,c,o
//the number of points used for fitting and the resulting RMSD values are reported in the Tool > Utility > Reply Log.
match iterate 2.0 site2 site1  // 2.0 is the cutoff. iterate gives better results.


// align models in sequence, then in 3D 
matchmaker (for which the reference structure is given first):
mm  #0  #1
mm  #0  #2
savepos pos2 


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
light mode ambient //If you prefer a simple “line drawing” appearance, try ambient-only lighting
light mode two-point

~set depthcue

//ranges from 1 to 20 (default 1.5). Increase smoothness by increasing the subdivision: 
set subdivision 5
set subdivision 10; set flatTransparency; ribspline cardinal; set depthcue // personal good settings

set projection ortho | perspective | orthographic
set shadows


//Silhouettes are outlines that highlight boundaries and discontinuities. Turn on silhouettes:
set silhouette 
~set silhouette 
set silhouetteWidth 3

// turn off silhouette for selected part
Actions... Inspect > model > silhouette

// The contrast, or darkness of shading, is another important contributor to the clarity of figures. Decrease the contrast (default 0.83):
light contrast 0.55 


// Hide this dashed line “pseudobond”:
~longbond 

// find clash, find contact
findclash  #0.1  test #0.2  intersub true  overlap -1  hb 0  make false select true
namesel contacts // naming selection
color yellow contacts & #0.1
color hot pink contacts & #0.2


// get hbond in MD trajectories.
color yellow :.j; color byhet :.j; ~rib ~:.j; ~disp ~:.j; color white ~:.j
rib; transp 85,r ~:.j; set flatTransparency; ribspline cardinal; set depthcue; ~set silhouette

~disp; sel :.j;  hbond LineWidth 3 selRestrict cross relax false reveal true  save hbond_<F>.txt log true

~disp; sel #1:.j;  hbond LineWidth 3 selRestrict cross relax false reveal true  save hbond_<F>.txt log true intermodel false

~disp #3; sel #3:866-891.k;  
hbond LineWidth 3 selRestrict cross relax false reveal true  save hbond_<F>.txt log true intermodel false  intraMol false intraRes false

rib; transp 85,r ~:.j; set flatTransparency; ribspline cardinal; set depthcue

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
for tp/docking record.

reset g_3

~disp #0; sel #2.1 z < 1.2 & #0; disp sel; col byhet sel; ~sel


savepos hairpin_top
Section_Ghf1_3_hairpin_top_disp.py
savepos hairpin_top_concise


Gfh1   Gld
polar and charge:
ASP42  GLU837
asp44  asn838
asp45  asn839
glu38  asp834
Hydrophobic
ala50  lys840(long chain)
and hydrophobic core.
cys and pro vs leu,33,36,48 and ala51 in Ghf1.

Section_Ghf1_3_hairpin_top_disp_concise.py

savepos gld_where
Section_gld_where_colored.py


savepos complex_orth
Where_is_gld_whole_rnap_orthx
Cut_rnap_in_purple
Session: RNAP_whole_orth_Cut.py

copy png file ../pic_tp/Contacts_charged_surface.png  unit inches dpi 300
savepose contact1


savepos hairpin_top_ribbon
copy png file ../pic_tp/Contacts_hairpin_top_ribbon.png  unit inches dpi 300
Section saved.

savepos contacts2_vertical
Section saved.


