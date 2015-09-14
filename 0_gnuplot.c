// color the legend!!! 
set key textcolor rgb variable
// data range
plot [0:5000] './1bdd.rmsd.equil.0.xvg' u 1:2 w line
//plot two curves.
plot './1bdd.combine.equil.1.xvg' using 2:3 with dot, './1bdd.combine.equil.4.xvg' using 2:3 with dot


// change the position of legend:
gnuplot> set key left bottom // center
the legend goes to left/bottom. Available options are, left, right, top, bottom, outside, and below. You can combine some of them. For example, outside bottom. 


//functions  + anotated legend
// sprintf   consecutive file names
// here the title "xxx" will go to legend of that line, not the title of the figure.
filename(n)=sprintf("./1bdd.combine.equil.%d.xvg",n)
plot for [i=0:11] filename(i) u 2:3 with dot title sprintf("T_%d",i)

splot for [i=7:7] filename(i) u 1:2:3 with dot title sprintf("T_%d",i)


set terminal postscript  #//do not preserve colors! bad
set output "sinx.ps"	 #// append each time call plot, good

set term png giant size 1280,960  #//good preserve colors
set output "sinx.png"		#// each time overwrite, bad, need to rename everytime
//example of png output:
#!/bin/sh
name="Glycerin T1 measurement"
gnuplot -persist << EOF
set term png giant size 800,600 font "arial" 14
set output "/home/john/Dropbox/nmr/figures/$name.png"
plot ...
EOF


set title  "1BBD_constant_temperatures"
set xlabel "RMSD in nanometer"
set ylabel "Potential energy"

show term
show output


plot sin(x),cos(x)
exit


load 'try.gnuplot'


"matrix in 2D and 3D" "Plotting rows in a matrix"
//2D
gnuplot> plot 'pte1' matrix u 1:3 w line 
gnuplot> plot 'pte1' matrix u 1:2  w line  
gnuplot> plot 'pte1' matrix u 2:3 w line   
gnuplot> plot 'pte1' matrix u 1:3 every 3 w line 

gnuplot> plot 'pte1' matrix u 1:3 every 1:999:1:2 w line 
gnuplot> plot 'pte1' matrix u 1:3 every 1::1:2 w line        
gnuplot> plot 'pte1' matrix u 1:3 every 1::20:2 w line  
gnuplot> plot 'pte1' matrix u 1:3 every 1:5:20:2 w line 

// e.g.
plot 'P[e][q]_distribution_of_Q_at_diff_e' matrix u 1:3 every 1:15:1  w l

plot '1cta.prob.log' u 1:3 matrix every 1:2 w l 
// u 1:3 is fixed for no reason, 
// each row is a line in the plot, at the same time a block.
// points here is not lines, but numbers in a row
// then follow the following rule about every :::::

every point_incr:block_incr:start_p:start_b:end_p:end_b

//3D
splot 'pte1' matrix w dot  



"pass variables to gnuplot is impossible at just one command line"
> for a in `ls`;do ./script.gp $a; done

> How do I reference the argument in script.gp?

By not doing it like that, but more like this:

for a in `ls`; do
gnuplot <<EOC
plot "$a"
EOC
done


gnuplot> system("ls")          

set datafile separator "="
plot 'gi_density_of_state' u (log($2))
//splot 'dos' u 1:2:(log($3)) w d 
set log y 10 
plot 'gi_density_of_state' u 2
show log


// how fine detail you want in the figure
set samples 400, 400  
set sample 50  

// color the surface and bottom
set pm3d implicit at sbt    

gnuplot> set isosamples 40,40                      
gnuplot> set pm3d  at sb                           
gnuplot> splot sin(sqrt(x**2+y**2))/sqrt(x**2+y**2)
gnuplot> 


gnuplot> set pm3d
gnuplot> splot 'gi_density_of_state_log' matrix w d
gnuplot> set pm3d map                              
gnuplot> splot 'gi_density_of_state_log' matrix w d
gnuplot> 

//good yellow and blue
gnuplot> set palette rgb 31 ,-10,32
// green and pink
gnuplot> set palette rgb 32 ,-10,32 

set view 130 ,30                          
gnuplot> splot 'gi_density_of_state_log' matrix w d
gnuplot> 


// plot heat map
gnuplot> set pm3d map
gnuplot> splot '../1cop/free.Q3.temp.1cop.51.pdb' matrix


// plot heatmap with standard 3 columns data, not natrix

plot 'free_i_a_0' u 2:3:4 with image


// use double axes y2  
gnuplot> set y2tics
gnuplot> replot
gnuplot> plot 'remd1.tm.tp.pt.rm.337.2240.xvg' u 1:3 w d axes x1y1, 'remd1.tm.tp.pt.rm.337.2240.xvg' u 1:4 w d axes x1y2
gnuplot> set ytics nomirror
gnuplot> replot

// integrated in bash environment

login2$ cat plot.sh 
#!/bin/sh
# usage: ./plot.sh 1xso potential i j
# potential is the type of data you want to plot, it also can be imperoper/dehidral/LJ_14....
# i is the start replica number, j is the end
n=$3
echo $3 $4 $n

// case in title
case "$1" in
1) ylable="time in ps"
;;
2) ylable="target temperature"
;;
3) ylable="real temperature"
;;
*) ylable="un-meaningful"
;;
esac

while [ $n -lt $(($4+1)) ]
do
name=$1/$1.$2.remd.$n.xvg
echo $name
gnuplot -persist << EOF
#set terminal postscript eps color enhanced
#set output "$1.eps"
#set xrange [ 0 : 20 ]
#set yrange [ 0 : 2 ]
#set mxtics 5
#set mytics 5
#set xtics 5
#set ytics 0.5

set ylabel "Energy [KJ/mol]"
set xlabel "time [ps]"
set title "$name"
set key textcolor rgb variable
plot "$name" using 2 w d
EOF

n=$[$n+1]
done
login2$ 


// set datafile separator "," // use comma as separator



// use directly from terminal -e
gnuplot -persist -e "plot 'temperatures_60_1arr.dat'"


