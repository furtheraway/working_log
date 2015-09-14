###############################################3333
"July 16th"

# 1. transfer files from tg813162@lonestar to yao@gordon
directory: work/02020/tg813162/dimer/analysis 
login1$ ls
1arr  1cop  1f36  1gvb  1xso  3ssi    Q3_all_80000  xiakun
1bet  1cta  1flb  1lmb  2oz9  Q3_all  wham_me
#login1$ scp -r 1arr 1lmb 1flb Q3_all 1cop  yao@gordon.sdsc.edu:/home/yao/dimer


###############################################3333
"July 18th"
# possible beta3 replacement protein WW domain of 2F21
ref:Ten-Microsecond Molecular Dynamics Simulation of a Fast-Folding WW Domain # this is amutation
The Pin WW domain gene was incorporated into a GST fusion protein expression system
(PGEX-2T vector). Fip35 was made by site-directed mutagenesis. The sequence of the
protein is: GSKLPPGWEKRMSRDGRVYYFNHITNASQFERPSG. The protein was
expressed and purified as described in [1].


# Force field stability test ff12SB ff03.r1 ff99SBildn
remd ff12SB, ff99SBildn, ff03r1, 
remd 1yrf, 1l2y, beta3, lch@lonestar.tacc.utexas.edu


1bet 12 hot spot testing at @ tg813162@lonestar # finished
dimer 84 1gvb 2oz9 3ssi : 1bet 1xso 1f36 (good now, not long run yet)


###############################################3333
"July 24th"

"to do list"
#1. test 1yrf ff99sb, compare with ff99idln 
# done on lch@lonestar. 


########## log
2D free_i_a & dos_i_a plot matlab code and instruction is located at:
Desktop/Matlab/2d_free_plot
file: MATLABPLOT.m  0_remd_free_energy_plot.txt
not syn on any one



###############################################3333
"July 27th"

2D free_i_a_temp ploting for 1lmb
all free_i_a_102.xxxx files have been copied to 
locate: @abc-desktop:~/Matlab/2d_free_plot/1lmb$
first pre-process by before_plot_process.sh
then in matlabe use plot_2D_free_i_a_temp.m



###############################################3333
"July 29th"




###############################################3333
"July 29th"

## log, use -n index.ndx with g_rms_s to get RMSD value for each single monomer
/work/02020/tg813162/gromacs.4.5.5/bin/g_rms_s -s $Dimer/1lmb/1lmb.gro -f $Dimer/1lmb/remd/1lmb.remd.0.xtc -n $Dimer/1lmb/1lmb.ndx -o foo2
## not used since I am not sure if we need that data.


##1lmb have something wrong with COM restrain, since 670 710 monomer atom numbers.


## log, set default real in ifort to double precision real8
ifort ...... -check bounds -r8



###############################################3333
"July 31th"

1flb 2D free_q , Tf is between 111.1000 to 111.2000  
     Q at folded minimal is 87/ out of 187 = 375/2
cat temperature_84_1flb.dat
    54	110.6
    55	111.409

"to do"
change energygrps = system in dimer.remd.mdp file to get genergy of each monomer
check tutorial




###############################################3333
"Aug 1st"

1. pr + awk to extract the extremals of dihedrial + improper energy
locate: /work/02020/tg813162/dimer/analysis/find_extrame.sh
results: 1lmb 1flb 1cop 1arr  in analysis/extreme_log/1arr.log ...


2. use setup.sh to implement 2d or 3d wham fr each dimer
locate: /work/02020/tg813162/dimer/analysis/wham_me
usage: .setup.sh  1lmb 2d 1000(iter)



###############################################3333
"Aug 3rd"

What enery term I have in ALL-Atom-Go model? 
dihedral and LJ_14 is the only converged energy terms.

what are the significance of each?
only LJ_sr is neglectable

#awk to get averaged energy terms in each replica, even with discard beginning frames
locate: awk script at "peripheral analysis " part of 0_dimer_readme.c-dropbox



add  energygrp 1 2 into 1n2.mdp and thus grompp into .1n2.tpr file before rerun,
     after all you need to rerun to get COLVAR files 

use make_ndx to build new.ndx file to be used by g_rms to get chain A, chain B Ca_rmsd.


# make_new_ndx.sh at lch@lonestar /dimer/template/
#used to generate name.new.ndx wiht 3 4 for each chain
# backbone_g_rms has been changed to give monomer Ca rmsd
# after make_new_ndx.sh, you can use remd.nn.x to get rmsd info

# also, after make_new_ndx.sh, you can use /scripts/rerun.sh to add energygrps 1 2 in to AB.mdp
# and get AB.tpr and LJ14 details in A, B and between A B

# rerun.sh is good on lch but not on tg813162 yet, BUT rerun.job is only good on tg...

 1058  vi test1.mdp 

 1059  /work/02020/tg813162/gromacs.4.5.5/bin/grompp_s -f test1.mdp -c ../../1xso.gro -p ../../1xso.top -n ../../1xso.ndx -o test1.tpr -po test1.out

 1061  /work/02020/tg813162/gromacs.4.5.5/bin/mdrun_s -plumed ../plumed.dat -s test1.tpr -rerun ../1xso.remd.0.xtc 

 1063  /work/02020/tg813162/gromacs.4.5.5/bin/g_energy_s -f ener.edr -s test1.tpr -o foo

 1069  /work/02020/tg813162/gromacs.4.5.5/bin/g_energy_s -f ener.edr -s test.tpr -o potential12.xvg 
	

###############################################3333
"Aug 5 rd"
make_index works well
g_rms accept index file to get saparate rmsd
but g_energy does not, you have to rerun with new tpr file with energygrp specified


shift_to_0.sh is developed under tg813162@lonestar/work/dimer/analysis/wham_me/1arr
used to shift all the dos_e files to start at 0 


###############################################3333
"Aug 20 rd"

12 replica tests fro "1l2y" and "1yrf" has been processed
remd1.s_all.*   "remd1.temp.$temp07" has been made at lch@lonestar/remd


2D_free_energy_profile and before_plot_process.sh 
locate: Dropbox/0_matlab_script/task/2d_free


# test force fields for 1l2y and 1yrf with 99sb 99sbildn 12sb 03r1
/work/02037/lch/remd/shift_potential.sh  # produce r_vs_p files
# purpose: shift potential energy to 



###############################################3333
"Aug 20 rd"

# dimer analysis process:
mkdir wham_me/mol_name/free -p
wham_3d, get free_i_a_temp in free
scp back to matlab/2D_free
process by before_plot_process.sh at /Dropbox/0_matlab_scripts/task/
matlab to locate Qa_f Qi_b,
1xxx_screen.x Qa_f Qi_b get REMDc
change setup.sh file in Qa_f Qi_b REMDc ...
run wham_1d.x folded/unfoled/all



###############################################3333
"Aug 30 rd"

"Questions"
how to divide folded and unfoled state?
1. fr 1arr at Tf, there is intermediate state in Qi, 
    3ssi have similar thing but not obvious

2. fr 1flb, Qa_f, Qi_b have to be read from diff temp
   since the binding and folding are seperated clearly.
   
#dimer
/home/abc/Dropbox/0_matlab_scripts/tasks/tangent_tf/shift_to_0.sh
use to shift 1d dos before analysis.m



###############################################3333
"Sept 24 rd"
to do:

add section in wham_nd.f90 to save fl_rst file automatically!








#*************************************************
# learning steps

1. simple to complex   
   order to disorder
   specific to general
   easy to hard

2. Think about how to do it?
   How to construct the structure, how to realize the process?
    
   step by step, one by one
























