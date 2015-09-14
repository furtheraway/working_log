// Most important, one thing I am pretty sure is that crd file begain from the 1;
while the log file begin from 0 WHEN you first start a simulation;(see command below 5.)

So, when you produce rmsd files with rmsd.ptraj.noRE.sh or rmsd.ptraj.sh, the first line is about the 1000th dt (time steps), not the initial structure. This is why they give different values.
However, when you look into the analysis/remd1.out.nnn.energy files, the first line is about the input structure at time 0. So all of them give the same value for all the terms.

However, all the statement above happened only to the first start simulaiton. (remd1.out.xxx)
"for restarted simulations, log start with the next step of that in rst file"

// Here is the instruction and memo for analyze remd simulaiton for Implicit solvent With
// AMBER Program

//***************************************************************
// 111 extract energy terms and rmsd terms

1. // prepare to get energy terms
mkdir analysis
ls -t remd1.out.0* > list_out1  // out of analysis dir

// awk for energy
for out_name in `cat list_out1`; do awk 'BEGIN{k=1}; {if ($1=="NSTEP"&&$4=="TIME\(PS\)"&&$7=="TEMP\(K\)"){step=$3;time=$6;temp=$9}};{if($1=="Etot"&&$4=="EKtot"&&$7=="EPtot"){etot=$3;ktot=$6;ptot=$9}};{if($1=="BOND"&&$4=="ANGLE"&&$7=="DIHED"){dihe=$9}}; {if($2=="NB"&&$9=="VDWAALS"){snb=$4;sel=$8;vdw=$11}}; {if($1=="EELEC"&&$4=="EGB"){lel=$3;egb=$6;rest=$9}}; {if($1=="TEMP0"&&$4=="REPNUM"){temp0=$3;repn=$6;exch=$9; print time" " temp0" "temp" " dihe" "ktot" "ptot" "sel" "lel" "snb" " vdw" "egb" "rest" "repn" "}}'  $out_name > analysis/$out_name.energy; done 
"************* comment about each term*******************"
1. time" " 2. temp0_target" "3. temp_real" " 4. etot/dihe" "5. ktot" "6. ptot" "7. sel" "8. lel" "9. snb" " 10. vdw" "11. egb" "12. rest" "13. repn  14. frame 15 ca-rmsd 16. frame 17. BB rmsd 18 frame. 19 noH rmsd 20 replica # 21. frame 22. wrong.temperature 23 atomic contact 24 residue contact // in energy and .all. files only the first 13 columns.
// it is a shame that I didn't out put dihedral energy term in the begining. I replace the etot with dihe, since the Etot is simply ktot+ptot;
// DONE:this has been done on 1l2y_24_f(1l2y_folded_plus_unfolded... a long folder name under remd of yzq@lonestar) on yzq@lonestar and remd1.temp_2_19.xxx.xxx has been copied to yao@gordon/remd/1l2y_24_f
// DONE: yao@gordon 1yrf_48/remd7.temp.xxx.xxxx
// DONE: yao@gordon 1l2y_32/remd2.temp_2_19.xxx.xxxx


2.1// use rmsd.ptraj.RE.sh for rmsd, at certain temperature
you can find a backup copy in Document/Amber/script

2.2// use rmsd.ptraj.noRE.sh for rmsd, at certain replica, without pick out one temperature.
ls remd3.crd.0* > list_out4  ; above analysis
./rmsd.ptraj.noRE.sh  1l2y  // please read rmsd.ptraj.noRE.sh file for exact usage!!! since this may not apply.
you need to change list_out"n" in rmsd.ptraj.noRE.sh
you can find a backup copy in Document/Amber/script


2.3// find minimum in rmsd or energy ; in analysis dir
cd analysis
ls remd.crd.* > list_rmsd
for file_name in `cat list_rmsd`;do echo $file_name; 
awk 'NR==1{min=$2}; $2<min {min=$2; l=NR}; END{print min " " l}' $file_name;
done

// find energy range to set boundaries for wham code: ! remember to change $6 accordingly
[yao@gordon-ln4 analysis]$ for file_name in `cat list_remd12.temp`;do awk 'BEGIN{k=1}; $1>20000&&k==1{min=$6;k=2}; $1>20000&&$6<min {min=$6; l=NR}; END{print min " " l}' $file_name;done > mins.xvg
[yao@gordon-ln4 analysis]$ for file_name in `cat list_remd12.temp`;do awk 'BEGIN{k=1}; $1>20000&&k==1{max=$6;k=2}; $1>20000&&$6>max {max=$6; l=NR}; END{print max " " l}' $file_name;done > maxs.xv

// other terms I used instead of total potential
[yao@gordon-ln4 analysis]$ for file_name in `cat list_remd1.temp_2_19`;do awk 'BEGIN{k=1}; $1>20000&&k==1{min=$7+$9+$4+$8+$10;k=2}; $1>20000&& ($7+$9+$4+$8+$10)<min {min=$7+$9+$4+$8+$10; l=NR}; END{print min " " l}' $file_name;done > mins.xvg
[yao@gordon-ln4 analysis]$ for file_name in `cat list_remd1.temp_2_19`;do awk 'BEGIN{k=1}; $1>20000&&k==1{max=$7+$9+$4+$8+$10;k=2}; $1>20000&& ($7+$9+$4+$8+$10)>max {max=$7+$9+$4+$8+$10; l=NR}; END{print max " " l}' $file_name;done > maxs.xvg


2.4//pick up the min rmsd frame from the crd file with strip.ptraj.x
// in name directory
you can find a backup copy in Document/Amber/script

3. //contacts number at atomic and residule level. 
location yao@gordon.sdsc.edu:/home/yao/remd/1l2y/smog/
ifort -O2 COMMON_USED.f90 contact.f90 -o cc2.x -check bounds
// change T_num in the source code contact.f90
./cc2.x

//important, the temperature from crd (that is the one produced here), is incorrect, it is one exchange late than the real temperature, which can be found from remdn.out.energy files

//***************************************************************
// 222 correlation between energy and rmsd
5.
"Important! before you do next step, make sure you remove the first line in"
"temp.pot.remdn.nnn file if this part start from 0 time-step"

// put all data together: energy + 3 rmsd + contacts
// if remd "1", rm the first line of energy file, before remove, backup
head -n 2 remd1.out.*.energy > head_energy_remd1
for i in {1..24}; do j=`printf "%03d" $i`; sed -i '1d' remd1.out.$j.energy; done


// with contacts number involved, delete the first 3 header lines in contact files first:
// you need to check if there are exactly 3 lines, may be more or less
for i in {1..32};do j=`printf "%03d" $i`;echo $j; sed -i '1,3d'  remd1.crd.$j.contact ; done


// concatinate all info together in remdn.all.# files
for i in {1..32};do j=`printf "%03d" $i`;echo $j;pr -t -m -s\  remd1.out.$j.energy remd1.crd.$j.rmsd_CA_2_19 remd1.crd.$j.rmsd_BB_2_19 remd1.crd.$j.rmsd_noH_2_19 remd1.crd.$j.contact > remd1.all.$j;wc -l remd1.all.$j; tail -n 2 remd1.all.$j; done
	// remember to change remd1, remd2, add _2_19 if needed!
// remd2
for i in {1..32};do j=`printf "%03d" $i`;echo $j;pr -t -m -s\  remd2.out.$j.energy remd2.crd.$j.rmsd_CA_2_19 remd2.crd.$j.rmsd_BB_2_19 remd2.crd.$j.rmsd_noH_2_19 remd2.crd.$j.contact > remd2.all.$j;wc -l remd2.all.$j; tail -n 2 remd2.all.$j; done

"************* comment about each term*******************"
1. time" " 2. temp0_target" "3. temp_real" " 4. etot/dihe(changed later)" "5. ktot" "6. ptot" "7. sel" "8. lel" "9. snb" " 10. vdw" "11. egb" "12. rest" "13. repn  14. frame 15 ca-rmsd 16. frame 17. BB rmsd 18 frame. 19 noH rmsd 20 replica # 21. frame 22. wrong.temperature 23 atomic contact 24 residue contact  // in "energy" file and "all" file


// remove duplex info and incorrect info from ".all." to ".s_all." files:
for i in {1..24};do j=`printf "%03d" $i`;echo  $j; awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$15" "$17" "$19" "$20" "$23" "$24}' remd1.all.$j > remd1.s_all.$j ; done
//remd2
for i in {1..24};do j=`printf "%03d" $i`;echo  $j; awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$15" "$17" "$19" "$20" "$23" "$24}' remd2.all.$j > remd2.s_all.$j ; done
"************* UP-DATE: comment about each term*******************"
1. time 2. temp0_target   3. temp_real    4. etot/dihe   5. ktot   6. ptot   7. sel   8. lel   9. snb    10. vdw   11. egb   12. rest   13. repn 14. ca-rmsd 15. BB rmsd 16. noH rmsd 17. replica # 18. atomic contact 19. residue contact  // in "energy" file and "s_all" file


// merge remd1, remd2, remd3,...
// check  line
head remd2.s_all.xxx 			// get 38300
sed -n -e 38300p remd1.all.001 	// display and check
//remove over-lap part in remd1
for i in {1..24};do j=`printf "%03d" $i`;echo  $j;sed -i '38301,$d' remd1.s_all.$j; done

//concatonate them together:
for i in {1..24};do j=`printf "%03d" $i`;echo  $j;cat remd1.s_all.$j remd2.s_all.$j > remd12.s_all.$j ; done

"not use!"// not necessary, it's a waste to remove begining unequilibrium part, since this can be easily done in later WHAM code
[yao@gordon-ln1 analysis]$ for i in {1..32};do j=`printf "%03d" $i`;echo $j; sed -i '1,20000d' remd1.replica.$j ; done


// seperate by temperature:  $temp7 is right number of decimal digits; while $temp07 is further padded with 0 (50.0000 to 050.0000)  
// this is very good for ls ordering: 
for temp in `cat ../temperatures.dat`; do temp7=`printf "%.4f" $temp`;temp07=`printf "%08.4f" $temp`;echo $temp7" "$temp07 ;grep -h "000 $temp7" remd12.s_all.* > remd12.temp.$temp07;done  // temp_2_19 ... add more info into names

"************* UP-DATE: comment about each term*******************"
1. time 2. temp0_target   3. temp_real    4. etot/dihe  5. ktot   6. ptot   7. sel   8. lel   9. snb    10. vdw   11. egb   12. rest   13. repn 14. ca-rmsd 15. BB rmsd 16. noH rmsd 17. replica # 18. atomic contact 19. residue contact  // in "energy" file and "temp.xxx.xxxx" file, xxx.xxxx is formated number for temperature.


// check number of lines
 wc -l remd12.temp*

// prepare for WHAM ; here $6 is the # of ptot, potential energy
// min
get max min energy
[yao@gordon-ln2 analysis]$ awk 'BEGIN{min=100; l=0};$6<min {min=$6; l=NR};END{print min "  " l}' remd12.temp.050.0000 
-676.3281  60626
// max
[yao@gordon-ln2 analysis]$ awk 'BEGIN{max=-1000; l=0};$6>max {max=$6; l=NR};END{print max "  " l}' remd12.temp.600.0000 
-70.2315  79742
// better solution for max min finally this should be inte:
//awk 'NR==1{min=$4}; $4<min {min=$4; l=NR}; END{print min " " l}' $file_name;


// WHAM 
Wham code has been adapted from Xiakun's code, DOS.sh has been changed.
I guess pdfQE.f90 also has been changed to read data from remd12.temp.$Temp files 
// or you can go to wham_me
// yao@gordon.sdsc.edu:/home/yao/remd/wham_me/wham_2d.f90 has been built
./setup 1l2y_24_f/1l2y_32   2d    10000
// you may need to change the start and end time in wham_2d.f90 file
1l2y_24_f_2d......x  all/folded/unfolded

analysis process is similiar to dimer part with matlabs


// WHAM with nonbonded (vdw ele dihe) energy
yao@gordon/remd/wham_me only temperary file wham_1l2y_24_f_2d.f90 has been modified to use nonbonded energys
wham_2d.f90 has not been changed. So, backup: cp wham_1l2y_24_f_2d.f90 wham_2d_nonb.f90


// *************************************************************
// Note

1. I put all the datas together in order to recover the canomical 
	ensemble from replicas. If in gromacs, this is no necessary.
	.all. and .s_all. files contain data for each replica
	.temp. for  each temperature


// **************** plot in series
login2$ vi 1l2y_24_50_500.folded.p.unfolded/analysis/plot.sh // with case title
login2$ pwd /work/01919/yzq/remd

//##########################################################
//# peripheral analysis
//##########################################################

calculate correlation (pearson value) between potential and rmsd_Ca for each force field and every temperature
covariance.sh located at lch@lonestar:/remd  also, another modified copy at yao@gordon:/remd


// average all energy terms in reach replica:
average_energys.sh located at yao@gordon.sdsc.edu:/remd // it is hard to match which energy is which, 
// but fortunately, we are not going to use this often.
average_energys.sh will give name/name.energy_ave

[yao@gordon-ln1 1l2y_24_f]$ awk '{sum=$6+$10+$8+$12+$14;print sum}' 1l2y_24_f.energy_ave > foo_w_e_g_se_snb // sum over energy terms we needed. // gnuplot> plot 'foo' u 1 // if you want: pr -m -t -s\  tempterature.dat foo > foo2, plot 'foo2' u 1:2
