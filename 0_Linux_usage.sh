# system level
# bash programming
# grep
# sed
# awk syntax and usage
# install / remove programs
# 
##########################################################
# Emergency recovery
##########################################################
turn the Unity plugin back on. The problem is this is a pain in the bottom because you''ve now got no graphical method to do this. So:

    Change to tty1 by pressing Ctrl+Alt+F1 and log in.

    Install compizconfig-settings-manager by running
    sudo apt-get install compizconfig-settings-manager

    Then run it by doing this:
    export DISPLAY=:0
    ccsm

    The first part tells the terminal which display you want it to load on (otherwise it won''t have a clue).

    Press Ctrl+Alt+F7 (or Ctrl+Alt+F8 sometimes) to get back to the graphical display where there should be a CompizConfig Settings Manager screen sitting there.

    Find the Unity plugin. Enable it.

    Everything should spring into life but if it doesn''t, you might have to restart. You can do that by going back to tty1 and running sudo reboot.

sudo dconf reset -f /org/compiz/
setsid unity

rm -rf ~/.compiz-1 ~/.config/compiz-1
http://askubuntu.com/questions/17381/unity-doesnt-load-no-launcher-no-dash-appears/76951#76951



# interesting
sshfs # to mount the remote disks to your desktop.

##########################################################
# system level 
##########################################################
# check OS info
uname -a

# change PATH
abc@abc-desktop:~$ PATH=$PATH:/home/abc/amber11/
#permanently change path
vi /home/abc/.bashrc
write:
export AMBERHOME=/home/abc/amber11
export PATH=$PATH:/home/abc/amber11

# To get a list of packages installed locally do this in your terminal:
dpkg --get-selections | grep -v deinstall

# There’s an easy way to see the locations of all the files installed as part of the package, using the dpkg utility.
dpkg -L <packagename>



# to open a folder from terminal in ubuntu:
nautilus .
nautilus path

# tar a file
tar -zxvf {file.tgz or .tar.gz}		# untar
tar -jxvf {file.tbz or.tar.bz2}
tar xvf file-1.0.tar
tar -xf /home/test/test.tar -C /tmp     # untar to certain directory with -C
gunzip mdcrd.gz
unrar x [filename.rar]

tar -zcvf {.tgz-file} {files}	# tar files into a package
#e.g. tar -zcvf  script.tgz  scripts/
#e.g. tar -zcvf scripts_template_2014_Mar_15.tgz scripts/ template/
tar -jcvf {.tbz2-file} {files}

    x = eXtract, this indicated an extraction ( c = create to create )
    v = verbose (optional) the files with relative locations will be displayed.
    z = gzip-ped; j = bzip2-zipped
    f = from/to file ... (what is next after the f is the archive file) 

#decompress into a certain directory, e.g., try
abc@abc-desktop:~/Downloads$ tar -zxvf gamess.tar.gz -C ./try
 tar -C /myfolder -zxvf yourfile.tar.gz

# view tar package contents
tar tvf project.tar

# show the types of files
file *

# find turn out to be useful / fine files of all kinds.
       find /tmp -name core -type f -print | xargs /bin/rm -f

       Find  files  named core in or below the directory /tmp and delete them.
       Note that this will work incorrectly if there are  any  filenames  con‐
       taining newlines, single or double quotes, or spaces.

# Single command but multiple lines
\   # thats it!

#count words
wc filename
wc -l filename		# -l count lines

# display only directories
ls */remd -d
1bdd/remd  1l2y/remd  1prb/remd  1wit/remd
ls -d */
analysis/  scripts/  template/

#cut -c is for columns, -3 is first 3 columns; 4- is from 4th to the end of line
cut  data.xvg -c 4- > try2
cut  foo -c 17-12 > foo2

# merge columes  so great!!! # BUT, HOWEVER, pr gives weird space, mess up pdb file.
pr -t -m -s\ \ \  good bad bad bad >bad2
            x x xx 	# here  "\ \ \ " is to use 3 spaces to seperate columns
				# and after "\ \ \ " there have to be a space before filenames, this is why it there are, and have to be two spaces before good.
# good, bad, bad, are names of files
note 1. -t, --omit-header
              omit page headers and trailers
	2. -m, --merge
              print all files in parallel, one in each  column
     3.  -s[CHAR],--separator[=CHAR]
              separate columns by a single character, default for CHAR  is  the  <TAB> 

# use paste instead.
paste -d" "  2ivfc.66_91.pdb1 2ivfc.66_91.pdb2 2ivfc.66_91.pdb3 > 2ivfc.66_91.gld.pdb; head 2ivfc.66_91.gld.pdb

# change pdb residue names
for aa in ASP GLY ARG ASP ILE TYR PHE LEU LEU GLU ILE ASP GLY ASN TYR ALA TYR ASP LYS GLY GLU ASN ASN LYS CYS PRO; do echo "$aa";echo "$aa"; echo "$aa";echo "$aa";echo "$aa";done > 1i8a.66_91.pdb2

sed -i '1d' 1i8a.66_91.pdb 
cut -c 22- 1i8a.66_91.pdb > 1i8a.66_91.pdb3
cut -c 1-16 1i8a.66_91.pdb > 1i8a.66_91.pdb1
wc -l 1i8a.66_91.*
pr -t -m -s\  1i8a.66_91.pdb1 1i8a.66_91.pdb2  1i8a.66_91.pdb3 > 1i8a.66_91.gld.pdb



# printf
printf abcde\' 	# abcde'
printf abcde\nabc	# abcdenabc
printf "abcde\n\tabc"	# \n \t are interpreted only in "..." or '...'
printf 'abcde\n\tabc' 
printf '$i\n'		# variable is not recognized in ''
printf "$i\n"		# variable is passed

# printf format:
# padding leading 0 for integer
printf "%03d" $i
printf "%d" $i  # simply gives 1 2 3 ... not padding, no space

# even can padding 0 before real number!
i=0.2
printf "%020f\n" $i
0000000000000.200000
printf "%20f\n" $i
            0.200000
printf "%f\n" $i
0.200000
printf "%.4f\n" $i
0.2000
printf "%.1f\n" $i
0.2

##########################################################
# bash programming
##########################################################
set -x # echo commands execuated

# variable in double quotes are replaced, but not in single
sed "s/a/$a/g" # use " if you want replace $a

# string manipulation
#  the first 4 character of a string
type=remd_12.2
abc@abc-desktop:~$ echo ${type:1:4}  -> emd_ # begin at the 2nd and 4 characters long
echo ${name:1:${#name}-4}
echo ${#name}   # length of a variable
emd_

# evaluate as number $i has to be integer
$(($i+1))
# even better, Tf can be 105.5 and * or / operation
sed "s/TTTTT/`echo "$Tf-11+$i" | bc`/g" file_name

# for loop
for i in {1..4}; do echo $i.good.$(($i+1)); done
1.good.2
2.good.3
3.good.4
4.good.5

for i in {1,2,4};do echo $i.good.$(($i+1));done
1.good.2
2.good.3
4.good.5

for i in {"good",2,'bad'};do echo $i.good.$(($i+1));done
good.good.1
2.good.3
bad.good.1
# it seems that {} and , is not necessary.
for i in '1arr' '1bet' '1cop' '1f36' '1flb' '1gvb' '1lmb' '2oz9' '3ssi'; do echo $i; mv $i ${i}_0.3;mkdir $i; done 

for name in  3ssi 1cop 1arr 1f36 1cta ; do ... # the ' is optional for strings.

for file_name in `cat list_rmsd.3.4`; do echo $file_name;...;done

for i in `seq 0  $T_num`  # use variable as limit of loop
for i in `seq $(($a-4))  $(($a+3))`; do echo $g;done
do ...; done

# use while loop to loop around each line of a list_file
while read name  #  while IFS= read -r line
do 
....
done < list_file

#example, rename a list of files
while read name ; do mv $name ${name:1:${#name}-4}; done < foo.list

# directly feed while read by pipe |
 ls *.pdf | while read name; do echo $name.xxx; done

# while a file still have content:
while [ `head -n 1 1arr.temp.dat` ]; do echo good; sed -i 1,3d 1arr.temp.dat; done

while read line
do
    number=$(echo "$line" | cut -d '"' -f2) # read out numbers from the line just read in.
    echo $number                            # -d is delimitor  -f2 gives the second field.
done

line="12    34.4    56"
echo "$line" | cut -d ' ' -f2,3 
34.4 
echo "$line" | tr -s ' ' | cut -d ' ' -f2,3 
34.4 56
tr -s, --squeeze-repeats   replace each input sequence of a repeated character
                        that is listed in SET1 with a single occurrence
                        of that character

# use if in shell

if [ "$n" != "" ]; then echo "n has value"; else echo "n is null"; fi # check if exist
if [ "$n" == "" ]; then n=0; fi

 if [ $n -lt $j ]; then echo good ; fi
# there have to be space between [ or ] or if or fi...
# to compare a number variable
if [ "$i" -eq  "1" ];then echo $i;fi

login1$ if [ "2" -eq `wc -l 1cop.40.90.96.frames.ndx | cut -d ' ' -f1` ] ; then echo "good"; fi

if [ $count -eq 100 ]
then
  ....
elif [ $count -gt 100 ]
then
  ....
elif [ "$type" == "all" ] #### IMP use == to compare strings instead of -eq
then
  ....
fi

# chech if a file exist or not, if is, back up with time suffiex

if [ -e $wdir/$name ] ;then thetime=`date +%Y.%m.%d_%H.%M.%S`; mv $wdir/$name $wdir/$name.$thetime; fi
if [ ! -e 1arr.temp.dat ] ;then echo good; fi  # not exist

# case in title
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


# read in from a list_file
listfile_name=list_free

while read name
do
echo $name
min=`awk 'NR==1{min=$4}; $4<min {min=$4; l=NR}; END{print min}' $name`
echo $min
grep -v "Infinity" $name | awk -v min=$min '{print $2,$3,$4-min}' | awk '$3<10' > $name.dat
done < $listfile_name

# read in real numbers in scientific notation: 1.2000000e+01
while read point 
do
qi=`echo "$point" | tr -s ' ' | cut -d ' ' -f1` # trim spaces, and then cut fields.
qi=`printf '%.0f' $qi`
done < $listfile_name

# trim example: 
login1$ point="    e ee   e"
login1$ echo $point | tr -s ' '
e ee e

##########################################################
# grep
##########################################################
grep Allgo -i *dimer* --color
# i ignore case
# --color=auto
# -a or --text take binary as text
# -l return the file titles only.

##########################################################
# vi vim editing skills
##########################################################
yy copy current line, V select current line, p past.
v select regions with arrows
y^ select from current position to the beginning of the line;
y$ to the end of the line
^ move the cursor to the beginning, $ move to the end.
# multiple instances copy and past
"*y$  "*y^  "*p	  "# * is a marker, it can be any number or char.
use v to select; then "*y to copy, and "*p to  .

e.g. select current line, and marker it 3:    "3yy      "
     past some where eles:                    "3p       "

##########################################################
# sed
##########################################################

# replace 140 with 120 in * files
sed -i -e 's/140/120/g' *	# -i edit files in place;

# remove the first line from the a file
login1$ for name in `cat ../list_out1`; do sed -i '1d' $name.time.temp;done

# remove the last line from the a file
 sed -i '$ d' foo

#Remove the 3rd line:
sed '3d' fileName.txt

#Remove the line containing the string "awk":
sed '/awk/d' filename.txt

#Remove the interval between lines 7 and 9:
sed '7,9d' filename.txt 

# remove the all the lines since the 7 th, 7th line is also removed
sed -i '7,$d' foo

# convert to capital and sed applied on the result string.
seq="Asp-Gly-Arg-Asp-Ile"; echo "${seq^^}"
# it seems -i requires the input be a file.  use pipe to feed string into sede.
echo "${seq^^}" | sed  s/-/\ /g >> sequence.txt ; tail sequence.txt 
ASP GLY ARG ASP ILE

# It is easier to read if you use an underline instead of a slash as a delimiter:
sed 's_/usr/local/bin_/common/bin_' <old >new
Others use the "|" character. 
sed 's|/usr/local/bin|/common/bin|' <old >new
sed 's:/usr/local/bin:/common/bin:' <old >new

# "&." It corresponds to the pattern found. 
echo "123 abc" | sed 's/[0-9]*/& &/' # this matches zero of more numbers
123 123 abc	# duplicate the pattern found.
# A better way to duplicate the number is to make sure it matches a number:
echo "123 abc" | sed 's/[0-9][0-9]*/& &/'
123 123 abc

A quick comment. The original sed did not support the "+" metacharacter. GNU sed does if you use the "-r" command line option, which enables extended regular expressions. The "+" means "one or more matches". So the above could also be written using

% echo "123 abc" | sed -r 's/[0-9]+/& &/'
123 123 abc

#remove numbers from characters
echo abcd123 | sed 's/\([a-z]*\).*/\1/'

# reverse two field
echo "abc def" | sed -r 's/([a-z]+) ([a-z]+)/\2 \1/'

# only change certain column in fixed width files
sed "s/^\(.\{17\}\).../\1ALA/" gld_2ivf.pdb  
# change pdb residue names into ALA
first 17 columns \(.\{17\}\) is remembered as the 1st pattern, used as \1 to paste it back.

# it is there, but not include in our matches.
(?<=xxx)yyyzzz

Regular Expression: 
  https://msdn.microsoft.com/en-us/library/az24scfc%28v=vs.110%29.aspx
. any single character, not include white space
* 0 or more preceding element
+ 1 or more preceding element
? 0 or 1 preceding element

# replace all dots in the name of a file with underscore.
ls *.pdf |while read name; do name1=`echo ${name:0:${#name}-4} | sed s/\[.]/_/g`; echo $name1; mv $name $name1.pdf; done

##########################################################
# awk syntax and usage
##########################################################
# basic syntax
awk -v var1=value1 -v var2=value2  'BEGIN{actions...};  conditions1... {actions1....};  conditions2... {actions2....}; END{actions...}' input_file
# -v is used to pass a parameter to awk

# two ways to use awk in shell
# 1. 
login2$ cat try2 
  BEGIN {max=1}  $1 ~ "^[0-9][0-9]*$" && $1 > max {max =$1; print max}
login2$ awk -f try2 ATG_2S_1CTA.ndx
# BTW tail -n 1 1cta.dihedrial.remd.[0-9][0-9].xvg # [0-9] can be used in bash

login2$ cat try.awk 
awk ' BEGIN {max=1}  $1 ~ "^[0-9][0-9]*$" && $1 > max {max =$1; print max}' "ATG_2S_1CTA.ndx"
login2$ ./try.awk 

# every other line
'NR%2==0'
{print n ;print "xxx"}
# include a print action, you can get a return value from awk
if you want to print strings, use "" 

mixx=`awk -f try2 $name`    
D_com=`awk -v N_com=$N_com 'NR==2 {print $2*N_com}' $Dimer/$name/remd/COLVAR`
# -v pass argument / real parameter to awk
# you can even pass the number of column as a bash variable:
cr=5   # below $cr is used as colunm $5
awk -v cr=$cr -v p_aver=$p_aver -v r_aver=$r_aver 'BEGIN{n=0;cov=0;dev_p=0;dev_r=0}; $1>=20000 {dev_p=dev_p+($3-p_aver)^2; dev_r=dev_r+($cr-r_aver)^2; cov=cov+($3-p_aver)*($cr-r_aver);n=n+1}; END{print "cov= " cov/n " var_p= " dev_p/n " var_r= " dev_r/n " P= " cov/sqrt(dev_p*dev_r)}' $wdir/$name/analysis/remd7.tm.tp.pt.rm.$temp07.xvg > foo2


#use if and for in awk
awk '{ if ($1=="Step") {line=NR ; print $0 ;for(j=1;j<=10;j++){print $0}}}' foo
# if else:
END {if (n==10000 || n==8000) {print "Not_conv"} else {print "Converged"}}
# if and for are regard as actions, so, they need to stay in {}
# however, actually the beginning if is by default, so, it can be
awk '$1=="Step" {line=NR ; print $0 ;for(j=1;j<=10;j++){print $0}}' foo
# result not good since it do not process to the next line:
	Step           Time         Lambda
	Step           Time         Lambda
	Step           Time         Lambda
     ....

# search and print context around the find: grep -A -B
grep -i xxxx -A 5 -B 3 filename

awk 'BEGIN{k=1};{ if (k==1 && $1=="Step") {k=2;l=NR; print $0}};{if(NR<=(l+10) && NR>=(l+1)&&k==2){print $0}}' foo
# above line is equavelent to:
awk 'BEGIN{k=1}; k==1 && $1=="Step" {k=2;l=NR; print $0};{if(NR<=(l+10) && NR>=(l+1)&&k==2){print $0}}'
awk 'BEGIN{k=1}; k==1 && $1=="Step" {k=2;l=NR; print $0; next};{if(NR<=(l+10) && NR>=l&&k==2){print $0}}' foo

break	# break a for loop
next		# stop processing current line and go to the next input line

# print in awk
print $3"\t " $4"\t " $5		# print table
print "-cpi $8  -noappend"	# print variable
"it seems not printf in awk, but in bash. but it can also print space and each call to print will just print for one line, the nest call will be in a new line"

# find minimum in certain column of a file, and the # of line it is:
for file_name in `cat list_rmsd.3.4`; 
do echo $file_name; 
awk 'NR==1{min=$4}; $4<min {min=$4; l=NR}; END{print min " " l}' $file_name;
done 
e.g.
1arr_free_i_a # you need to change the column # 4, accordingly
3.236742483300941903342868486010245E+002   10 

# sucessively call awk by pipe |, looks good , concise
grep -v "Infinity" $name | awk -v min=$min '{print $2,$3,$4-min}' | awk '$3<10' > $name.dat


# awk string manipulation build-in functions:
awk 'BEGIN { print index("peanut", "an") }'

split(string, array, fieldsep)
split("auto-da-fe", a, "-")
a[1] = "auto"
a[2] = "da"

substr(string, start, length)
awk '$1=="ATOM" && substr($5,1,1)=="C" {print $0}' 3AOH.pdb >> 3aoh.pdb
# to filter C chain from PDB, but C chain has 999+ residues, so C1000 in #5 field of pdb.


# Transpose a column in a file
awk -f transpose.awk foo1
# in file transpose.awk
{
    for (i=1; i<=NF; i++)  {
        a[NR,i] = $i
    }
}
NF>p { p = NF }
END {
    for(j=1; j<=p; j++) {
        str=a[1,j]
        for(i=2; i<=NR; i++){
            str=str","a[i,j];
        }
        print str
    }
}




# input two files with awk
Code:
#!/bin/bash
awk  '
  BEGIN {
          # load array with contens f1.txt
          while ( getline < "f1.txt" > 0 )
            {
              f1_counter++
              f1[f1_counter] = $1
            }
  }
  { 
    print $1, $2, f1[NR], $3
   } ' f2.txt

In the BEGIN part all content of f1.txt is loaded into an array. The correct array entry can be printed by using the NR variable that holds the current record value. So print $1, $2, f1[NR], $3 first prints fields 1 and 2 from f2.txt, then f1[NR], which is the corresponding entry from f1.txt. Last the third field from f2.txt is printed.



##########################################################
# install / remove programs
##########################################################

##install a program by name:
sudo apt-get install gnu
sudo apt-get install gfortran
sudo apt-get install flex

#install gcc compiler:
$ sudo apt-get update       	# Before install any program!
$ sudo apt-get install build-essential
$ gcc -v
$ make -v

# install java 
sudo apt-get install sun-java6-jdk sun-java6-jre
# install g++
sudo aptitude update && sudo aptitude install g++

#-$ sudo apt-get upgrade	# for update programs

make clean 
make install

##list of installed programs:
abc@abc-desktop:~$ dpkg --list | less
##delete by name:
abc@abc-desktop:~$ sudo apt-get remove nautilus-dropbox

# change file permission
chmod 700 -R /directary     ## for directory and all descendent files

# change owner and group
john@desktop:~$ sudo chown -R john:john exchange_others/





##########################################################
# 10 awesome examples for viewing huge log files in Unix
##########################################################

1. # display certain lines with sed
Syntax: $ sed -n -e Xp -e Yp FILENAME
    sed : sed command, which will print all the lines by default.
    -n : Suppresses output.
    -e CMD : Command to be executed
    Xp: Print line number X
    Yp: Print line number Y
    FILENAME : name of the file to be processed.
$ sed -n -e 120p -e 145p -e 1050p /var/log/syslog

In the following example,  you can view the content of var/log/cron from line number 101 to 110.
    M – Starting line number
    N – Ending line number
Syntax: sed -n M,Np FILENAME
$ sed -n 101,110p /var/log/cron  # display certain lines



2.#View growing log file in real time using tail command and -f option
$ tail -f /var/log/syslog


3.#Example 8: Display lines matching a pattern, and few lines following the match.
# grep -A 5 "Initializing CPU#1" dmesg

Viewing N lines after the match with -A option.
Viewing N lines before the match with -B option.
Viewing N lines around the match with -C option

4.#Example 10: Viewing compressed log files
Display the first N lines of a compressed file.
$ zcat file.gz | head -250
Viewing the lines matching the pattern
$ zcat file.gz | grep -A2 'error'
Viewing particular range of lines identified by line number.
$ zcat file.gz | sed -n -e 45p -e 52p

5.#Searching in all files recursively using grep -r
10. display the lines which does not matches all the given pattern grep -v.
11. Counting the number of matches using grep -c
15. Show line number while displaying the output using grep -n






# preferial command
# copy a CD into an iso file:
cat /dev/sr0 > /home/john/Music/videos/samba.iso



head -q # quite mode, do not print file names  e.g. head *.dos_e -n 1 -q >foo


# create symbolic links
ln -s target_path link_path
# example: abc@abc-Notebook:~$ sudo ln -s /home/abc /home/john
# sudo ln -s /media/My\ Book/Desktop/matlab/contact_map /home/john/matlab

# to see the symbolic links:  
ls -tl
 0 lrwxrwxrwx  1 root root    41 Jul 30 09:15 contact_map -> /media/My Book/Desktop/matlab/contact_map




rsync --progress /copy/from /copy/to
rsync -aur tg813162@lonestar.tacc.utexas.edu:/work/02020/tg813162/dimer/1lmb/ ./1lmb

john@desktop:~/matlab/2D_free_Qab_Qi/1lmb$ rsync --progress  lch@lonestar.tacc.utexas.edu:/work/02037/lch/dimer/analysis/wham_aq/1lmb/free/free_i_a_103.* .

# back up folders of your desktop, like dropbox and Document
rsync -aur --progress Dropbox/ westd/Dropbox/


# back up system (home folder)
abc@abc-Notebook:~$ rsync -aur --progress --exclude=.*  /home/abc/ /media/My\ Book/Laptop/

john@desktop:/home$ rsync -aur --progress --exclude=.*  /home/john/ /media/john/My\ Book/Desktop/

# copy lch@lonestar to lch@stampede 
login2.stampede(5)$ rsync -aur --progress lch@lonestar.tacc.utexas.edu:/work/02037/lch/ lonestar/



 2000  sudo dropbox start
 2001  sudo dropbox stop











