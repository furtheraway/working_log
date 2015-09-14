// location : tg823262@lonestar

// everything fron lonestar is backed up on Stampede in the following manner.
login1.stampede(14)$ rsync -aur --progress lch@lonestar.tacc.utexas.edu:/work/02037/lch/ lonestar/


Free energy profile temperatures
1cop   1d 113.0  2d 113.2  3d 113.1 (replica #50 (from 0), temp 51)
       remd_7 is 113.5   


sbatch
showq -u lch
scancel job_id1 job_id2 ...


// survival analysis files ##############################
// suffix _2 is for 1cop version.

// for ez phi value maps (uf, f, TS, phi), then add filter, and then 2 linear phi value plots
/home/abc/Dropbox/0_matlab_scripts/tasks/pair_evl/Contact_phi_ez_high_frames_2.m

// from wham_aq results, change Tf in each case of switch.
/home/abc/Dropbox/0_matlab_scripts/tasks/2D_free_energy_profile/2d_free_energy_profile_aq_enhanced_2.m

// for wham_4d results; change name{1}{1} directly for different file input. 
/home/abc/Dropbox/0_matlab_scripts/tasks/2D_free_energy_profile/3d_free_energy_contours_Qiab_2.m

//##########################################################
//# set up before run
//##########################################################

1. set /dimer/template/temperature.dat  for temperatures

2. v 1 // start test from nothing but the smog.tar.gz file 
	run steps.test.sh mol_name
   v 2 // production run
       // back up:    mv remd remd_t
     run steps.dimer.84.sh
	  // cp remd_t/plumed.dat remd	if necessary

3. change the name.nn.remd.job file for 
	development or normal
 	01:00:00    or 24:00:00
	qsub xxx.job

// ##### for kit run, use same rmsd protocal but with exchange rate in .job file extremely large, to achieve the fact that no exchange going on actually.

steps.test.sh not used, since plumed.dat .. etc has been generated in prevous remd run
temperature_84_name.dat ==> temperature_kit_name.dat (12 temperatures)
steps.84.dimer.remd.sh  ==> steps.kit.sh
setup_grompp_dimer_remd.sh  ==> setup_grompp_dimer_kit.sh
dimer.remd.mdp ==> dimer.kit.mdp (0.0005-> 0.001 ps/step) // 0.001 ps may be too large! this is NOT a good change
dimer.remd.job ==> dimer.kit.job (-replex 1000 -> 2000000000)
(* note: all the above changed files have remd replaced by remd_k)

@/work/02037/lch/dimer
name=3ssi; cd $name; sed -i 's/development/normal/g' $name.kit.job; sed -i 's/=01:/=24:/g' $name.kit.job; qsub $name.kit.job; cd ..

sed -i 's/development/normal/g' *job; sed -i 's/=01:/=24:/g' *.job; qsub *.job

//##########################################################
//# Extract preliminary data after run
//##########################################################

1. produce energitic info (dihedrial, LJ_14, etc) and RMSD 
// dimer/scripts/backbone.g_rms has been independent of remd.c, just directly use it: 
note, remember to toggle on/off the switches in the file.
 for name in 1cop 1flb 1lmb ; do for i in {0..11}; do $Dimer/scripts/backbone.g_rms $name $i remd ; done ;done

2. produce # of native contacts 
//dimer/scripts/q3_setup.sh  used to make jobs for Q3 calculating for remd_k 12 runs
./q3_setup.sh 3ssi remd_k
q3_setup.sh modified based on setup.sh(analysis/wham_aq/), adding # of chainA atoms $n_atom and total $atoms for dimers.
name.12.q3.job is a template job file, sedded by q3_setup.sh file.


// kit_pathways.m demostrate the contact number envolve in 3D, Qa, Qb, Qi in kinetic trajectories.
// kit_pathways.m @ /home/john/Dropbox/0_matlab_scripts/tasks; also handle remd run, kit run(folding at T_80), as well as remd_k run.
//1 john@desktop:~/matlab/kit$ name=1gvb; scp lch@lonestar.tacc.utexas.edu:/scratch/02037/lch/all/$name/kit/*/*/Q3.$name.*  $name/*/
//2 john@desktop:~/matlab/kit$ for name in 2oz9 1f36 1bet 1cta 1gvb 3ssi  ; do cd $name/[67]*/; ls * > $name.foldpath.log; cd ../..; done
//3 john@desktop:~/matlab/kit$ for name in 2oz9 1f36 1bet 1cta 1gvb 3ssi  ; do cd $name/[67]*/; while read fname ; do mv $fname $fname.txt;done < $name.foldpath.log; cd ../..; done

"./plot_Q3.sh 3ssi xxx 0 11" at scratch/02037/lch/all/

// extend certain replica for longer runs, at which temp, back forth is more likely be observed:
./q3_setup.sh 3ssi one 4  // 4 is the replica index
// the above do not work due to the domain decomposition issure in paralell runs. so use the following strategy:
@ dimer/all.one.job to run several dimers, each with one cpu
then at /scratch/02037/lch/all/long/q3_all_long.job. to calculate Q3 values
then ./plot_Q3.sh 1lmb xxx 2 2 long

//##########################################################
//# analysis after run
//##########################################################
//  exchange rate/prob info, just to asure myself:
./prob.84.10000.s.x name_list_1lmb //@ dimer/scripts
plot '1lmb/1lmb.prob.log' matrix every 1:2 w l

// extract all energy and rmsd info
use make_ndx to build new.ndx file to be used by g_rms to get chain A, chain B Ca_rmsd.
# make_new_ndx.sh at lch@lonestar /dimer/template/
#used to generate name.new.ndx with index 3 4 for each chain
# backbone_g_rms has been changed to give monomer Ca rmsd 
// note, change $Data=work or scratch, remd or remd_k accordingly!
//              $Analysis also...
name=1arr; for i in {0..11}; do $Dimer/scripts/backbone.g_rms $name $i remd ; done

// to see the correlation between rmsd_all and dihedrial and LJ_14 energy. 
name=1arr; i=4; sed '1,13d' $name.rmsd_all.remd.$i.xvg > $name.$i.rmsd_all ; sed '1,19d' $name.dihedrial.remd.$i.xvg > $name.$i.dihedrial; sed '1,19d' $name.LJ_14.remd.$i.xvg > $name.$i.LJ_14; pr -t -m -s\  $name.$i.rmsd_all $name.$i.dihedrial $name.$i.LJ_14 > $name.$i.all3;  awk '{print $1" "$2" "$4" "$6" "$4+$6}' $name.$i.all3 > $name.$i.all3p

// all the following line about remd.c remd.job is over date, since i would prefer to modify backbone_g_rms directly and call it in bash loops >>>>>>>>>>>
# after make_new_ndx.sh, you can use remd.nn.x to get rmsd info (use remd.c.job if needed)
 and remd.c call backbone.g_rms to do the job
@ /scripts/remd.c -> remd.nn.x  / gcc remd.c -o remd.nn.x
usage: remd.nn.x name_list_file remd 
@ tg813162@lonestar I cp backbone_gms to *_sup and remd.c to remd.sup.c
in order to produce 1xxx.rmsda_Ca.n.xvg to provide Ca_rmsd of chain A (actually this is all atom rmsd instead of Ca, you can see this from backbone.g_rms_sup file. But this havs been corrected by rename. Also, rmsd_noh have been renamed to rmsd_all; rmsda_Ca have been renamed correctly into rmsd_A_all;THis is consistent with that in lch@lonestar)
Also, backbone.g_rms at tg813162 has been changed/updated according to lch@lonestar (backup as backbone.g_rms_bp); with bb and mc RMSD removed(and not produced therefore). (But before use, check the if[] toggles in the file) 

@ lch@lonestar this is not necessary since backbone_gms has been modified 
to give rmsd_A_Ca file, corresponding call in wham_nd.f90 is also changed.
/ these separated files can be directly used by wham_me codes below, 
/ and they should be, reduce intermediate steps as few as possible!
// <<<<<<<<<<<<<

// contact number for dimer, both A I B , atomic and residul level
@ /scratch/all/try.f90
compile: ifort try.f90 -o try.x -check all
out dated >>>>>>>>>>>>
usage: call by 1lmb.q3.job, which calls Contact.lonestar.perl, which call try.x 
       you need to sed 1lmb with other mol_name and//!!! important, change n_atom in 1xxx.q3.job to atoms in monomer A
Attantion: there is a string cut in try.f90, which give results Q3.temp.1lmb.0.pdb at tg813162
                                                          but   Q3.1gvb.0.pdb at lch
so, you need to change the following line 
write (f_q3(i),"(7A,I0,A)") Analysis,"Q3_all/",mol_name,"/","Q3.",mol_name,".",i-1,".pdb" ! // in wham_xd.f90 accordingly
<<<<<<<<<<<<<<<<

//1 /scripts/q3_setup.sh store all the limits of the range of unfolded folded and TS states,it will sed(replace) the tags in template file name.84/12/1/fold_q3.q3.job with proper values for each dimer. And these job file will call scripts/Contact.map.sh
./q3_setup.sh name remd/remd_k/one/ etc

//2 /scripts/Contact.map.sh been built to call scratch/lch/all/contact_map.x
//           Contact_s.map.sh    is for remd 84 located at scratch
//           Contact.map.sh      is for remd_k 12 located at remd_k at work 
//           Contact_kit.map.sh  is for kit/name/temp folding trajectories

//3 contact formation probability in native, non-native and TS. for Phi value calculation:
@scratch/lch/all, contact.f90, compiled into contact_map.x 
./contact_map.x /work/02037/lch/dimer/1arr/1arr.pdb /work/02037/lch/dimer/1arr/1arr.top 435 /scratch/02037/lch/all/1arr/temp.1arr.3.pdb_long 870 0 5 0 40 58 90 58 92 45 50 43 53 $idx $name (the last two arg are used to produce correct output name and location)
    (Contact.f90 is covering try.f90, but somewhat cubersome. so try.f90 still useful is you just care about Q3 file, they produce the same Q3 file, tested.)

contact.f90 has been corrected to take into consideration that the Qastep!=1 and Qistep!=1. Keep contact.f90 there in the scripts folder, compile into the /scratch/all folder.
ifort contact.f90 -o /scratch/02037/lch/all/contact_map.x -check all

// produce a third file /scratch/02037/lch/all/1arr/remd/Q3.map.1arr.pdb
// used by /home0_matlab_scripts/tasks/phi_value_map.m generate map
 ls Q3.map.*.pdb > namelist; while read name; do mv $name ${name:0:${#name}-4}.txt ; done < namelist // since matlab can not use importdata to import pdb, change suffix to txt.   @ home/john/matlab/contact_map/remd_k or /remd

//4 contact_evl.f90 has been built from contact.f90. Used in the same way as contact.f90.
// this have been build to calculate the contact pair formation along a piece of a kinetic unfolding run. (need to modify contact_evl.f90 and recompile for different dimers and trajectories.) % it only take single frames along a mannually picked transition trajectory and get the contact pair formation, no probability. (see below //6 for a better one with prob, from replica trajectories.)
"it's actually about contact pair evolution, for residue contact formation evl, see contact.res_evl.f90"
ifort contact_evl.f90 -o /scratch/02037/lch/all/contact_map.x -check all (contact_map.x is also used for try.f90, contact.f90 to save the need to change names)
called by the same Contact.sh and job file.

For each remd_k trajectory, change the limits of the frames in the contact_evl.f90 file directly. and then 

cp name.q3.12.job Evl.name.n.sh and then modify, perform reach by a small piece which includes a transition event. You can use plot_q3.sh to help you choose the region. (note, Evl.name.n.sh this not job file, no need to qsub)

contact_evl.f90 can produce bunch of files each lists all the contact pair formed, named by "Evl.",name,".",trim(idx),".",model,".txt" (in the same directory as Q3.name.)

after that, go back to 0_matlab_scripts/task/phi_value/Evolution_of_contact_map.m for analysis and movie.

//5 contact.res_evl.f90  is designed to give structure formation percentage of each residue/atom along the increasing of contact formation. It take all the remd_k 12 trajectories arond TF to produce the evlution. (Not sure if I shoud use remd 84 replicas, since they are a a wide range of temperature, and thus could make a mess of it. Need to check the Paul's paper again, from which I am inspired to do so)
compile: ifort /work/02037/lch/dimer/scripts/contact.res_evl.f90 -o /scratch/02037/lch/all/contact.res_evl.x -check all
test:
type="remd_short";name="1arr";D_data="/scratch/02037/lch/all/";n_atom=435;atoms=870;T_num=12;/scratch/02037/lch/all/contact.res_evl.x /work/02037/lch/dimer/$name/$name.pdb /work/02037/lch/dimer/$name/$name.top $n_atom $D_data $atoms $T_num $name $type
routine impliment:
/dimer/scripts/q3_setup.sh name res_evl.12. (job file name.res_evl.12.job)

a goto statement has been added in contact.res_evl.f90, to generate info/flag files with out running through the datas in temppdb files. change it back if needed.

later contact.res_evl.f90 are further modified to give Q3.flag.name.pdb file, used in the matlab scripts Contact.res_evl_all.m to generate a side bar indication residue positions (interface or else). flag files transfered back to matlab/res_evl/

//6 contact_pair_evl.f90 is created based on contact_evl.f90 to process replica trajectories, following minpath in dir /scripts/path/minpath_orig.
ifort /work/02037/lch/dimer/scripts/contact_pair_evl.f90 -o /scratch/02037/lch/all/contact_pair_evl.x -check all
  // need to change the range of replica do loop in contact_pair_evl.f90, 35,70, to 20,59 for 1arr, to 15,47 for 1cta.
/scripts/Contacts_pair_evl.sh and Contact_pair_evl.job are used to execute.
result: scp lch@lonestar.tacc.utexas.edu:/scratch/02037/lch/all/*/remd/pair_evl.* /Dropbox/0_matlab_scripts/task/pair_evl		*/
Contact_pair_evl.m has been developed from Evolution_of_contact_map.m to process result.

  // above contact_pair_evl.x gives evolution of contact map along minpath.
  // We still need representing structures from scrip/path/find_frames_84_scratch.sh to give use gro frames.
  // they together be call in job file scripts/Contact_pair_evl.job

scp .xtc back and vmd

//7 contact_pair_evl_ez.f90 is created based on contact_pair_evl.f90 to process replica trajectories. following minpath derived from 3d_free_energy_profile_Qiab_ez_4d.m.
// this only process one replica. as arguments. Hopefully gives us a simplier/more clear contact evolution map.
modify scrip/path/find_frames_84_scratch_ez.sh Evolution_of_contact_map_ez.m accordingly. 

ifort /work/02037/lch/dimer/scripts/contact_pair_evl_ez.f90 -o /scratch/02037/lch/all/contact_pair_evl_ez.x -check all

john@desktop:~/Dropbox/0_matlab_scripts/tasks/pair_evl$ for name in 1lmb 3ssi 1cop 1arr 1f36; do scp lch@lonestar.tacc.utexas.edu:/work/02037/lch/dimer/analysis/path/$name/*.ez_* $name; done        */
john@desktop:~/Dropbox/0_matlab_scripts/tasks/pair_evl$ scp lch@lonestar.tacc.utexas.edu:/scratch/02037/lch/all/*/remd/Q3.pair_evl.*_ez_??_??.pdb .                             */

//8 contact_phi_ez.f90 is created based on contact_pair_evl_ez.f90 to process replica trajectories to get phi values. Contacts_phi_ez.sh are adapted to do this job.
Input file: lch/dimer/scripts/phi/boundaries/1cop_phi_3d.txt  // unfolded, folded, and TS read from 3D free energy contour, not forget to correct by Qistep and Qastep.
login1$ ifort contact_phi_ez.f90 -o /scratch/02037/lch/all/contact_phi_ez.x -check all

./Contacts_phi_ez.sh 1cop 518 1036 remd 51
./Contacts_phi_ez.sh 1f36 708 1416 remd 54
./Contacts_phi_ez.sh 3ssi 772 1544 remd 49
for i in {34..38}; do ./Contacts_phi_ez.sh 1arr 435 870 remd $i; done
for i in {50..55}; do ./Contacts_phi_ez.sh 1lmb 670 1380 remd $i; done


john@desktop:~/Dropbox/0_matlab_scripts/tasks/pair_evl$ scp lch@lonestar.tacc.utexas.edu:/scratch/02037/lch/all/1cop/remd/Q3.phi.1cop* .
// four columns in the phi files are likely: 1 unfolded, 2 folded, 3 TS, 4 Phi. so is the png map labelled/produced
0_matlab_scripts/pair_evl/Contact_phi_ez.m to process.




//######## give dihedral energy for each of the monomer.
// building at scripts/parts/new_sp.sh, be enveloped by scripts/name.part.sh to give /dimer/analysis/1arr/1arr.A(or)B.dihedral.xvg files, A&B sum up to 1arr.dihedrial.n.xvg, tested
packed into dimer/scripts/name.parts.job; and used through q3_setup.sh as : "./q3_setup.sh name parts " 


// COM distance between two dimers (rerun). produces not just colvar, but also LJ14 interaction of each monomer and between them.
1. before rerun, first generate *.new.ndx files by make_new_ndx.sh at template directory
2. "./q3_setup.sh name com_lj" use colvar.name.job, (calling work/dimer/scripts/rerun.sh to )
3. COM results stored in dimer/analysis/com (both lch and tg813162) "!!! check where colvar is in lch !!!"
   LJ_14 results in analysis/name/name....

//get Emin Emax Qinum Qanum, then use extreme to feed /dimer/analysis/wham_me/setup.sh
pr + awk to extract the extremals of dihedrial + improper energy
locate: /work/02020/tg813162/dimer/analysis/find_extrame.sh
usage: find_extrame.sh 1lmb 83 > 1lmb_extreme.log // may have different name
results: 1lmb 1flb 1cop 1arr  in analysis/extreme_log/1arr.log ...
// cp find_extreme.sh find_extreme_rmsd.sh (auto put results log into extreme_log)
// change find_extreme.sh so that all log file can go go extreme_log dir automatically


//Qinum Qanum, used to feed setup.sh
// remember to divide Qi/a_resolution to make Ni and Na smaller than 200 (actually, you can use NINT() instead of floor() to make the contact number < 150, which is better)
Qanum Qinum is in the first line of any Q3.temp.1lmb.pdb file at analysis/Q3_all/
// change the values in the setup.sh(see below) code accordingly


// #######  wham procedureS.
// setup.sh locate at tg813162@lonestart/dimer/analysis/wham_me can set up the wham procedure you want
1.   usage: ./setup 1lmb 3d  10000
   use directly: 1lmb_3d.x > 1lmb_3d.log (see bug fix below)
   3d first. produce 1xxx_3d.x to give 2D free energy profile for a temperature scan.
        locate Tf and give dos_e and dos_e1, they should be equal to dos_e_1d_all produced by 1d_wham
2. transfer wham_me/1xxx/free/free_i_a_temp back to laptop ~/matlab/2D_free/1xxx
   processed ~/Dropbox/0_matlab_scripts/tasks/2D_free_energy_profile/before_plot_process.sh to shift to 0 and cutoff >10
   plot using 2d_free_energy_profile.m // locate Qa_f, Qi_b here, feed setup.sh
3.  ./setup 1lmb screen
   1xxx_screen.x Qa_f Qi_b > 1xxx_screen.log // this produce RMSDc at Qa_f and Qi=0, of course you can change the filter later
   feed setup.sh with RMSDc
4. ./setup.sh 1lmb 1d 10000
   run as : 1xxx_1d.x  all/folded/unfolded > *.log
   this will give 1xxx/dos_e_1d_state
5. cp dos_e_1d_state back to  ~/matlab/tangent_tf/1xxx
   processed by /Dropbox/0_matlab_scripts/tasks/tangent_tf/shift_to_0.sh
   use :~/Dropbox/0_matlab_scripts/tasks/tangent_tf/analysis_dimer.m  and Tf_compare.m
   to process


// 2D WHAM for E and Qq (all Q)
(tg813162@lonestar? maybe)dimer/analysis/wham_me/wham_2d.f90 // this one turn out to be less usefull for binding/folding


// file anotation in dimer/analysis/wham_me/mol_name/  folded
1. Tf and peaks temperature is locate at the end of T_Cv 
2. fl_rst  is:  tail -n 168 zz_pb_fl > fl_rst
   fl_rst_2d is: tail -n 84 zz_pb_fl_2d > fl_rst_2d // for restart fl
3. Qa_f RMSDc can be found tail of peq_bfacter_2d\



// En for each dimer is 
"sed -n -e 20p 1flb.dihedrial.remd.n.xvg" + "sed -n -e 20p 1flb.LJ_14.remd.n.xvg"
// dihe should be 0 above. so only LJ_14 is needed


// ####################################3
// find rmsd range for wham_rd (rd represent rmsd), E range need not to change.
find rmsd range find_extreme_rmsd.sh 1gvb 83 all
locate: lch@lonestar /dimer/analysis/
usage: ./find_extreme_rmsd.sh mol_name 84 all/mc/BB/Ca

// wham_rd 
setup.sh changed, use Qanum=max(Rmsd of chain A); Qinum=min(RMSD of the whole system) // how to adjust rmsd type is a problem

wham_3d.f90 has been modified to read rmsd instead of Qi Qa// but the notation is keeped for simplicity purpose.
// that is Qi= whole dimer RMSD; Qa is chain A RMSD.
// the rmsd type is hard coded now in file name: (change if you want to change to diff rmsd types)
write (f_rmsd_i(i),"(5A,I0,A)") Analysis,mol_name,"/",mol_name,".rmsd_all.remd.",i-1,".xvg" !
write (f_rmsd_a(i),"(5A,I0,A)") Analysis,mol_name,"/",mol_name,".rmsd_A_all.remd.",i-1,".xvg" !
// So, before you want to used another rmsd value. change the above code apart from changing the argument given to ./setup. Since setup.sh only pass different boundaries for each rmsd type, the code itself, hardcoded, determine what it is going to read in.



// #########################
// a note about different wham_* folders
1. wham_me, wham_3d.f90 use Qi and Qa, do 2D wham
            wham_1d.f90 use Qi (at Tf) and RMSDc (RMSDc is about chainA, averaged over Qi and Qa at Tf) as cut-off (results are incomplete, not calibrated yet)
2. wham_rd, 3d use _all (can be changed to Ca in code) rmsd of system and chainA+B, do 2d
            1d chainA+B and rmsd_all of the system.
(bin width of 0.5 A in rmsd, seemed too big to locate the exact bottom of the folded basin at temperatures< Tf, worse more, the cutoff are very streaky in this situation, see /home/john/Dropbox/tangent_tf/Tf_calibration.log)
            
2.2 subdirectory: "1d_rmsd_i_only": 1d use all(that is noh) rmsd only (1d cutoff) as cut-off, (result in very clustered lambda values, see john@desktop:/matlab/tangent_tf_rmsd_i_only). and the results are analyzed in folder John@desktop:/Dropbox/tangent_tf_rmsd_i_only

3. wham_qq, no 3d wham
            1d wham use the Qi and Qa (at a temperature lower than Tf, from the 2d landscape contuor in directory /free in wham_me).  and the results are analyzed in folder John@desktop:/Dropbox/tangent_tf_qq

4. wham_cr 3d _all rmsd chainA+B, and COM

5. wham_aq 3d Qa+Qb vs Qi

6. wham_AB 3d Qa vs Qb

7. wham_4d 4d Qi Qa Qb  Setup by the setup.sh in the same folder. analysis with matlab_scripts/2D....

7.1 wham_ez_4d Qi Qa Qb, easy way to get free energy, without WHAM, directly from -ln(prob), based on the replicas around Tf in REMD. Results in wham_4d/name/f_i_a_b_xx_xx.txt.
setup.sh name 4d_ez/ez_4d (1000,iter_max,useless here);
 for i in {51..58}; do ./1cop_ez_4d.x $i $i; done
scp back to tasks/2D_free_energy_profile/name/; then precessed by ../before_plot_process_4d.sh; 
then matlab code 3d_free_energy_contours_Qiab_ez_4d.m (change the loop, only one temperature per time., for i=2:2, since 2 is usually the all close Tf replicas.)




// then send back to desktop/laptop use 0_matlab_script/task/tangent_tf/
1. shift_to_0.sh mol_name
2. analysis_dimer_xx.m // remember to change S_orig_min from the output of
                       // shift_to_0.sh, the unfolded ln(g).

hand input to Tf_compare
convert temeperature:
john@john-desktop:~/Dropbox/tangent_tf_aq$ awk 'NR>1 {print $1" "$2" "$3*120.2717" "$4" "$5" "$6" "$7" "$8" "$9" "$12" "$13}' Tf_compare_3 > Tf_compare_3_k

// ###################################################
// 3D_free energy contour
locate '/home/john/Dropbox/0_matlab_scripts/tasks/2D_free_energy_profile/'
matlab file: 3D_free_energy_contours_Qiab.m



// ###################################################
// wham_3d_EvsQ.f90    # suppliment of wham_3d which only give an averaged E along Qa/Qi; use fl_rst for input. backup zz_pb_fl zz_pb_fl_bp
1. ./setup mol_name 3d_EvsQ 100
2. ./name_3d_EvsQ.x  which gives mol_name/E_vs_Qa E_vs_Qi

@dimer/analysis/wham_aq
 for name in 1arr 1cop 1flb 1lmb; do cp $name/E_vs_Qa $name/$name.E_vs_Qa;cp $name/E_vs_Qi $name/$name.E_vs_Qi ; done // lch
 for name in 1bet 1cta 1f36 1gvb 2oz9 3ssi; do cp $name/E_vs_Qa $name/$name.E_vs_Qa;cp $name/E_vs_Qi $name/$name.E_vs_Qi ;done // tg813162

results be ploted by matlab files in Dropbox/0_matlab_scripts/tasks/E_vs_Q/(folder)
figures located at Dropbox/dos_dimer

// XXXXX try to build E_vs_Qa (real Qa, not Qa+Qb) and E_vs_Qb from 4D wham. use the code of task/E_vs_Q/E_vs_Q_dos.m
2. redo kinetics
3. over   after summary lambda values


// ###################################################
// wham_3d_doscut.f90    # suppliment of wham_3d; use peia_bfactor and fl_rst for input

cut dos 
do aa=Qa_f-10,min(Qa_f+10,Na)
do ii=Qi_f-10,min(Qi_f+10,Ni)
//usage:
for name in 1arr 1flb 1bet 1cta 1f36 1gvb 2oz9 3ssi 1lmb 1cop; do echo $name " "; ./setup.sh $name 3d_doscut 100  ; done

//transfer'
john@desktop:~/work/trans_dimer/transfer$ rsync -aur --progress lch@lonestar.tacc.utexas.edu:/work/02037/lch/dimer/transfer .

// matlab script
1. /home/john/Dropbox/0_matlab_scripts/tasks/tangent_tf/doscut_dimer_aq.m
   this only get the Tf from doscut according to Qa_f Qi_f determined by trial and error in 2 wham before, that is the same cutoff criteria to get Tf from second wham
2. /home/john/Dropbox/0_matlab_scripts/tasks/QQ_scan/QQ_scan.m
    this is pretty powerful script, it will call 
'/home/john/Dropbox/0_matlab_scripts/tasks/QQ_scan/f_analysis_dimer_aq();
'/home/john/Dropbox/0_matlab_scripts/tasks/tangent_tf/f_analysis_dimer_aq_doscut()
   to get Tf Tf lambda Snon gap roughness etc for all the 2D scan Qa_f or Qi_f +/-10
and make 3D plot to compare the results, 
and write summary of doscut for each dimer at file doscut_dimers.log // later edited into fooo(mv fooo Tf_compare_k_doscut)
3. plot all the correlations with old scripts /home/john/Dropbox/0_matlab_scripts/tasks/tangent_tf/Tf_compare.m // remember to change the input file Tf_compare_3_k to Tf_compare_k_doscut

// ###################################################
// wham_1d_scan.f90    # generate name_1d_scan.x which take Qa_f, Qi_b as argument
// then use as ./name_1d_scan.x all/unfolded/folded  Qa_f Qi_b
1. "./setup mol_name 1d_scan 8000"
2. ./name_1d_scan.x  which gives mol_name/dos_e_1d_Qaf_Qib and T_Cv_1d_116_141 and mol_name/2D_scan/name_Qaf_Qib.log

// QQ_scan.sh    # template for QQ_scan_name.sh which does 2D scan of QaQi by calling name_1d_scan.x recursively
1. "./setup mol_name scan" // use setup.sh to replace the QA_u etc boundary in the file.
2. then place 10 dimers' QQ_scan_name.sh in QQ_scan.job

3. "./setup mol_name read_scan" // use setup.sh to read the results in mol_name/2D_scan/name_Qaf_Qib.log file (cheking if converged)
and put results in file mol_name/2D_scan/name_QQ_scan.log
with formate in each line: Qa Qi 1/0/-1 (1 converged, 2 not, 3 wired, need longer wham)


// ###################################################
// get 80% folded temperature

lch&tg813162@lonestar. /dimer/analysis/wham_aq   80.f90 80_w.f90(only in lch)
_w is count from each replica. While 80.f90 is from DOS of dos_e_i_a
usage: ./setup.sh  1bet 80/80_w 
       ./1bet_80.x 

// ##############################################################
// kinetic runs for folding speed

in /work/02020/tg813162/dimer/1arr/remd/kit
for i in {1..12};do  j=$(($i*3000+10000));trjconv_s -f ../1arr.remd.59.trr -s ../1arr.remd.59.tpr -o 1arr.$i.trr -b $j -e $j; done

// get Tf
Tf=`grep Tf $Dimer/analysis/wham_me/1arr/T_Cv | awk '{print $4}'`
Tf=105.5  #1arr

// sed temperatures
for i in {1..12}; do sed "s/TTTTT/`echo "$Tf-11+$i" | bc`/g" $Dimer/template/kinetic/kinetic.mdp > 1arr.$i.mdp; done

// generate tpr file
for i in {1..12}; do grompp_s -f 1arr.$i.mdp -c 1arr.gro -p 1arr.top -t 1arr.$i.trr -o 1arr.$i.tpr  ; done

mdrun_s -s 83.tpr 
// job file input
for i in {1..12}; do echo "ibrun -o $((i-1)) -n 1  mdrun_s -s 1arr.$i -noddcheck -x 1arr.$i -g 1arr.$i -e 1arr.$i -c 1arr.$i -o 1arr.$i -cpo 1arr.$i -cpi 1arr.$i -cpt 14  &"; done

#check
head -n 260 *.log | grep Potential -A 1  # check if they start at different configurations?

tail -n 20 *.log | grep Time -A 1    # how long it has been? and if at the same speed?

// kinetic ##########################################################
// with code
 
1. //  cp top gro ndx file to right directory
   //# cp plumed.dat to right directory.

2. // get initial trr from unfolded traj. # in /work/02020/tg813162/dimer/kit/1arr/initial
1bet 85; 1f36 86; 1lmb 88; 1arr 88 maybe; 1cta 100; 1cop 96; 1flb 93; XTC 1gvb 89; 3ssi 91; 2oz9 91
name=1cta; T_num=46;for i in {1..59};do  j=$(($i*500+10000));echo 0 | trjconv_s -f $Dimer/$name/remd/$name.remd.$T_num.trr -s $Dimer/$name/remd/$name.remd.$T_num.tpr -o $Dimer/kit/$name/initial/$name.${T_num}_$i.trr -b $j -e $j; done
name=1f36; T_num=83;Dimer_s=/scratch/02037/lch/; for i in {1..100};do  j=$(($i*500+10000));echo 0 | trjconv_s -f $Dimer_s/$name/remd/$name.remd.$T_num.trr -s $Dimer_s/$name/remd/$name.remd.$T_num.tpr -o $Dimer/kit/$name/initial/$name.${T_num}_$i.trr -b $j -e $j; done

// for 3 replica trr: @/work/02037/lch/dimer/kit/1f36/61.78
for i in  83 82 81; do awk -v i=$i '{print i "_" $1 }' trr_order.dat >> trr_order_3r_84.dat; done // find one trr_order_3r_nn.dat backuped in dimer/kit dir 
for i in {0..11}; do sed -n $(($i*21+1)),$(($i*21+21))p trr_order_3r_84.dat > trr_order_3r_84.dat_$i ;done

@ dimer/scripts "./q3_setup.sh name fold temperature(xx.xx or xxx.xx)"  // fold $name at specified temperature, starting from 252 initial structures listed in trr_order_3r_nn.dat file, (which has been divided into 12 files with 21 structures in each.)

// later move almost everything to scratch. scratch/lch/dimer/kit/name/initial/ + trr_order_3r_84.dat
for i in 10.00 20.00 30.00 40.00 50.00 60.00 70.00 80.00 90.00 100.00 110.00 120.00; do ./q3_setup.sh 1cop fold $i; done


// collect folding speed after simulation at scratch/lch/dimer/kit dir
 for name in 1cop 1cta 1lmb 1f36 ; do for i in 10.00 20.00 30.00 40.00 50.00 60.00 70.00 80.00 90.00 100.00 110.00 120.00; do head -q $name/$i/*/*fold.log > $name/$name.$i.fold.log; done; done

*/ for name in 1arr 1cop 1lmb 1f36 1cta; do scp lch@lonestar.tacc.utexas.edu:/scratch/02037/lch/dimer/kit/$name/$name.*fold.log $name; done // at home/john/Dropbox/0_matlab_scripts/tasks/kinetic dir

get Q3.name Q3.map from kit folding runs: "./q3_setup.sh name fold_q3 temperature", which adjusting name.fold_q3.job, that is calling Contacts_kit.map.sh. 
results located at /scratch/all/name/kit/$temp/$start/ * 	// result not found any where, may need redo, possibly never done for most of the dimers previously.


// folding speed analysis at 80% temperature
1. at dimer/kit directory:
name=2oz9; cat $name/*/*/*fold.log > analysis_k/$name.80.fold
then Dropbox/0_matlab_scripts/tasks/kinetic/fold_speed.m

// to ############ out_date_end
// at dimer/kit once with while
name=1bet; sed -e "s/mol_name/$name/g" kinetic_80.job | sed -e "s/TTTT/63.28/g" > $name.job
name=2oz9; sed -e "s/mol_name/$name/g" kinetic_80.job | sed -e "s/TTTT/61.44/g" | sed -e "s/80_once.sh/80_gen_once.sh/g" > $name.job
name=3ssi; sed -e "s/mol_name/$name/g" kinetic_80.job | sed -e "s/TTTT/77.73/g" | sed -e "s/80_once.sh/80_gen_once.sh/g" > $name.job
name=1cta; sed -e "s/mol_name/$name/g" kinetic_80.job | sed -e "s/TTTT/72.07/g" | sed -e "s/_84/_48/g" > $name.job

login2$ name=1arr; sed -e "s/mol_name/$name/g" kinetic_80.job | sed -e "s/TTTT/62.58/g" | sed -e "s/_84/_60/g" > $name.job
login2$ name=1cop; sed -e "s/mol_name/$name/g" kinetic_80.job | sed -e "s/TTTT/72.29/g" > $name.job
login2$ name=1flb; sed -e "s/mol_name/$name/g" kinetic_80.job | sed -e "s/TTTT/70.55/g" > $name.job
login2$ name=1lmb; sed -e "s/mol_name/$name/g" kinetic_80.job | sed -e "s/TTTT/69.84/g" > $name.job

// over date, remove in the future after fixed routine is formed: 
# set up temperatures in the 1arr.temp.dat file
# in /work/02037/lch/dimer/template/kinetic
# may be mannually edit
for i in {1..12};do  echo `echo "105.5-11+$i" | bc` >> 1arr.temp.dat ;do

# set trr order in the wait.temp.log file:
# in /work/02037/lch/dimer/kit/1arr // do this mannually to build disorders
while read temp ;do mkdir $temp; for i in {86..2};do  echo $i >> $temp/wait.$temp.log ;done;done < ../../template/kinetic/1arr.temp.dat

# generate iburn lines in job file:
# in /work/02037/lch/dimer/kit/1arr
i=0;while read temp ;do echo "ibrun -o $(($i-0)) -n 1 ./kinetic_once.sh \$name $temp  0.5 >> \$name.$temp.log &"; i=$i+1; done < ../../template/kinetic/1arr.temp.dat

# for ploting folding time as a function of temperature.(this has been replaced by more complicated script in matlab on desktop)
while read temp; do line=`grep "85 " $temp/1arr.$temp.fold.log`; echo "$temp ${line:${#line}-26:${#line}-20}" >> 85 ;done < temp_list

# generate trr_order.dat mannually, and then attache #58 replica trr 
awk '{print "58_" $1 }' trr_order.dat >> trr_order_58.dat
while read temp;do echo $temp ; cat trr_order_58.dat >> $temp/wait.$temp.log ; done < ../../template/kinetic/1arr.temp.dat
// ############ out_date_end




//##########################################################
// energy_parts has been done on lch@lonestar  dimer/scripts/parts 





//##########################################################
//# peripheral analysis
//##########################################################

//#############  plot in series
plot.sh 1flb potential/rmsd_Ca i j //locate: tg823162@lonestar/dimer/ananlysis
plot_q3.sh 1flb xxx i j // locate: tg823162@lonestar/dimer/ananlysis/Q3_all


// tar to ranch
tar cvf - 1arr | ssh $ARCHIVER "cat > $ARCHIVE/dimer_lch_all.tar"

// transfer back from ranch
ssh $ARCHIVER
stage -w -r filename // in ranch
scp dimer_1cop_84_116979_12_test.tar tg813162@lonestar.tacc.utexas.edu:/scratch/02020/tg813162/ // in ranch
// it works better to scp on lonestar than on ranch:
scp tg813162@ranch.tacc.utexas.edu:/home3/02020/tg813162/dimer_1flb_84_123373_12test.tar .
tar -xvf dimer_1cop_84_116979_12_test.tar // back to scratch


// average every energy terms in each temperature replica, with first 10000 frame removed.
// replace the 10000 discard if needed:
for i in {0..83};do if  [ "$i" -eq  "0" ];then echo "# bond  angle  dihedral  improper  lj14  lj_sr  potential  kinetic  total  temp";fi; awk 'BEGIN{l1=0;l2=0;l3=0}; $1=="Bond"&&$2=="Angle"&&$3=="Proper" {l1=1;n1=n1+1;next}; l1==1&&n1>10000{bond=bond+$1;angle=angle+$2;dihedral=dihedral+$3;improper=improper+$4;lj14=lj14+$5;l1=0;next}; $1=="Coulomb-14"&&$2=="LJ"&&$6=="Potential"{l2=1;n2=n2+1;next};l2==1&&n2>10000{lj_sr=lj_sr+$2;potential=potential+$4;kinetic=kinetic+$5;l2=0;next};$2=="Energy"&&$3=="Temperature"&&$4=="Pressure"{l3=1;n3=n3+1;next}; l3==1&&n3>10000{total=total+$1;temp=temp+$2;l3=0;next}; END{if(n1==n2&&n1==n3){n=n1-10000; print bond/n" "angle/n" "dihedral/n" "improper/n" "lj14/n" "lj_sr/n" "potential/n" "kinetic/n" "total/n" "temp/n}}'  3ssi.remd.$i.log;done > energy_average.log2

# bond  angle  dihedral  improper  lj14  lj_sr  potential  kinetic  total  temp
  1     2      3          4        5      6     7          8        9      10
// example case 3ssi @ lch@lonestar /dimer/3ssi/remd/ 
// energy_average.log without first 10000 frame removed; energy_average.log2 removed first 10000
// plot result is locate at: laptop/ Pictures/averaged_energy_terms_dimer_3ssi


// correlation Pearson/ covariance variance....
tg813162@lonestar/work/dimer/analysis/correlaton
modify covariance.f90 before use, no argument needed.
results in in 1xxx.cov and 1xxx.cov_t has reduced temperature coverted into K
with command: pr -m -t -s/  temperatures_84_1flb.dat 1flb.cov > 1flb.cov_t



//######## characteristic frames along the trajectory ######
/work/02037/lch/dimer/scripts/path/find_frames.sh 
// has been build to extract the minimal free energy path, based on the (name_minpath.txt, located in matlab/wham_4d) file 
// generated by matlab script from 4D wham (3d_free_energy_contours_Qiab.m)
login1$ lch/dimer/scripts/path/find_frames.sh 3ssi analysis_k 5
                         name type(only tried remd_k) index of trajectory (0-11)
find_frames.sh above produces the lch/dimer/analysis_k/path/name/name.minpath.idx.dn.xtc, which is copied back to desktop/home/john/work/name (it is easier to find corresponding gro files for each dimer) 
All have been loaded into work/Minpath.alldimers.vmd state file.


// find_frames_evl_ez_scratch.sh name start end 
take remd untared in scratch. all replicas between start and end will be included.


//##########################################################
//# bug fix
//##########################################################

1. fro analysis/wham_me/wham_3d, there is a small bug about 
//fix log: tg813162 has been fixed, lch/wham_rd fixed

    write(*,*) "P_P:    P_P/(Ne*(Na+1)*(Ni+1)): ################################"
    write(*,*) P_P, real(P_P)/(Ne*(Na+1)*(Ni+1))
//  write(25,*) "P_P:    P_P/(Ne*(Na+1)*(Ni+1)): ################################"
//  write(25,*) P_P, real(P_P)/(Ne*(Na+1)*(Ni+1))
//  close(25)

  endif read_p


  ! save b_facter to save computational time
  allocate(b_facter(T_num,0:Ne-1))
  b_facter=0.0
  do l=1,T_num
    do e=0,Ne-1
      b_facter(l,e)=exp(-(e*Estep-offset)/(kB*Temp(l)))
//!      write(25,*) "Tl,e,b_facter", temp(l),e,b_facter(l,e)
    enddo
  enddo



// about 1flb separated binding/folding.
folding remd_k was moved to scratch/1flb/remd_k,
the one in folding work/1flb is around 103, binding.


F Quire Lang database 



  




















/john/Dropbox/
