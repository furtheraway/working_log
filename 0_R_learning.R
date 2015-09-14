#####   Basic data types in R  ==============================================

#Getting helps 
help.search("pattern")     # same as ??pattern
help(adf.test, package="tseries")
help(package="Shortreads")
vignette(package="ShortRead")
RSiteSearch("ShortRead")

args(function_name); examples(function_name); help(function_name)


# find relevant funcitons and packages
http://www.rseek.org/

# Rstudio shortcuts
Move Lines Up/Down              Alt+Up/Down
Redo                            Ctrl+Shift+Z
matching brace/paren            Ctrl+P

Fold                            Alt+L
unfold                          Alt+Shift+L
Fold all                        Alt+O
unfold all                      Alt+Shift+O
Delete line                     Ctrl+D

Move cursor to Source Editor    Ctrl+1
Move cursor to Console          Ctrl+2
Show plot                       Ctrl+6
change tabs                     Ctrl+Page up / down

getwd(); setwd("/home/john/Dropbox/");
# save binary data, including variable name.
save(myData, file="myData.RData")
load("myData.RData"); # names goes and comes with data

save(x, y, file = "xy.RData", ascii=TRUE) # assii is an option here.
save.image(file="whole_environment.RData")
# load certain/specific variables from a RData file. Following not tried yet.
e1 <- new.env()  # creat a new environment.
load("gold.RData", e1)
ls(); ls(e1)
nfree <- get('nfree', e1) # get nfree from e1 to nfree in global workspace.
ls(); rm(e1)  # now it is in the global workspace.

# save a single variable and directly load it into working environment.
saveSDR ??
# write ascii data.
dput(myData, file="myData.txt")
dump("myData", file="myData.txt")


history(100); history(inf);
search()  # the search PATH.
.Last.value # saves the value of the most recently evaluated
   #expression. Save it to a variable before you type anything else.

installed.packages()[,c("Package","Version")]
install.packages("packagename") # install new package. 
library(MASS); detach(package:MASS);
source("myScript.R"); source("hello.R", echo=TRUE) 

# some sets of readily available datas
library(MASS)  
split(Cars93$MPG.city, Cars93$Origin)
us=split(Cars93, Cars93$Origin) # split df Cars according to their origins.
data()  # display all build in R dataset.
data(package="pkgname") # bring a list of the dataset in package.
data(package="MASS")
data(dsname,package="pkgname"); head(pressure)
data(Aids2,package="MASS"); head(pressure)


# run R scripts in shell:
Rscript --slave --no-restore --no-save --no-init-file +
  myScript.R arg1 arg2 arg3 >results.out
# or make it self-contained (like scripts.sh) by placing the following line:
#!/usr/bin/Rscript --slave
argv <- commandArgs(TRUE)
x <- as.numeric(argv[1]);  y <- as.numeric(argv[2]);

# At the shell prompt, we mark the script as executable:
  $ chmod +x arith.R # I guess I need to add a first line.
# Now we can invoke the script directly without the Rscript prefix:
  $ arith.R 2 3.1415


sink("filename"); # sink all output into a file.
sink() # back to console

# print out into console or files
print(anything you want)
print(pi,digits=4); print(pnorm(-3:3),digits=3)
cat("String: and number together", 2*pi, "radians", "\n")
cat(format(pi,digits=4),"\n")  # format cat
cat("The answer is", answer, "\n", file="filename")  # cat into file.
cat(results, file="analysisRepart.out", append=TRUE) # hard coding file name.


ls(); 
ls.str();
ls(all.names=TRUE)

##### File I/O #####
# write to file connection, default append.
con <- file("analysisReport.out", "w"); cat(data, file=con); close(con);
list.files() # show all files.

# read fixed-width record:
records <- read.fwf("fixed-width.txt", widths=c(10,10,4,-1,4),
                    col.names=c("Last","First","Born","Died"));
# -1 is blank space. 
# interprets nonmumeric data as a factor. use stringsAsFactors=FALSE if strings are wanted.

# read tabular data files:
dfrm <- read.table("filename", sep=":", 
                   stringsAsFactor=FALSE,
                   na.strings=".",   # SAS convention, use . as missing values
                   header=TRUE,
                   comment.char = "#"
)
# Each line contains one record.
# Within each record, fields (items) are separated by a one-character delimiter, such
#   as a space, tab, colon, or comma.
# Each record contains the same number of fields.
#   any line begins with a pound sign # is ignored as comments.

tbl <- read.csv("table-data.csv", as.is=TRUE)  # as.is stop factering.
write.csv(tbl, file="table-data.csv", row.names=T)

#  read complex structure.
lines <- readLines("input.txt", n=10)  # Read 10 lines and stop
world.series <- scan("http://lib.stat.cmu.edu/datasets/wseries",
                     skip = 35,
                     nlines = 23,
                     what = list(year = integer(0),
                                 pattern = character(0)),
)



#####  Build vectors with the concatenate function c() #####
a=c(1,2,3); b=c(4,5,6); b2=b[length(b):1]; b2     
c=c(a,b2);
any(a==2); all(b==5)

c %% 2 == 1  # modulus 
c[c %% 2 == 1]

%%    # Modulo operator
%/%   # Integer division
%*%   # Matrix multiplication
%in%  # Returns TRUE if the left operand occurs in its right operand; FALSE otherwise

v[ v > median(v) ]
v[ (v < quantile(v,0.05)) | (v > quantile(v,0.95)) ]
v[ abs(v-mean(v)) > 2*sd(v) ]
v[ !is.na(v) & !is.null(v) ]


# vectors can be sets of objects of the same mode
v1=c(1,2,3)
v2=c("A", "B", "C")
v3=c(TRUE, FALSE, TRUE)

# building vectors from nothing
a=NULL; a=c(a, c(1,2,3)); a # i guess a=as.numeric() may be better

# lots of built-in functions; R tries to operate on them in vector fashion if possible
log(a)    # element by element.
sum(a)

# R will try to coerce objects into meaningful modes depending on what you are trying to do
# this converts TRUE and FALSE into 1 and 0:
sum(v3)  # TRUE is 1; FALSE is 0
v1+v3

# R tries to recycle vectors when needed,so
a=c(1,2,3) + 1
a=c(1,2,3,4) + c(1,2)
# generally useful but can fail (or give silent errors) if you aren't careful
a=c(1,2,3,4) + c(1,2,3)

# making vectors
1:100
seq(1,100, by=2)
seq(from=1, to=9, len=20)
seq(1, 9, length.out=20) # same as len.

rep(c(1,2), len=4)
rep(c(1,2), each=2)
x=1:10; seq(from=1, to=2, along=x)

z=1:6; seq(from=2, to=12, along=z) # seems stupid and meaningless, since it is equal to the next line.
z=1:6; seq(from=2, to=12, len=length(z))

# insert something into an array
append(1:10, 99, after=5) 

# missing values
z=c(1:3,na); ind = is.na(z)

#parallel max and min
a=c(1,2,3); b=c(4,5,6);c=c(a,b);
pmax(a,b,c) # x y z are vectors and shorter ones are reused.

sqrt(-17) # gives NaN
sqrt(-17+0i) # deals with complex number

2*1:5 # : has higher priority.

# show properties of objects.
attributes(z)
attr(x,"dir")
class(z)
summary(z); str(z); dput(z); # more and more verbose.
# use str(z) to show dimension of a matrix. dim(quals)

# matrix and array.
matrix(data = NA, nrow = 1, ncol = 1, byrow = FALSE,dimnames = NULL)
matrix(0,4,5);
B=matrix(1:20,4,5); array(1:20,dim=c(4,5)); # the same.
# select, default is to drop to basic vector.
mat <- B
row <- mat[1,,drop=FALSE]; row ; # drop extend info, like dim() 
col <- mat[,3,drop=FALSE]; col

t(B)   # transpose a matrix.
cor(B) # correlation

# basic statistics
a=c(1, 3, 5);b=c(2,6,7); cor(a,b); cov(a,b);
sum((a-mean(a))*(b-mean(b))) / (length(a)-1) / (sd(a)* sd(b)) == cor(a,b)

A=matrix(rep(1:10,5),5,10,byrow=TRUE)
var(A) # input n*p matrix, will give you 
cor(A) # covariance matrix pxp. since p is the variables (column vector in df)
cov(A) # and n is number of samples/objects.


z=array(c(1:3,3:1),dim=c(3,2));    z<-c(1:3,3:1); dim(z)<-c(3,2); # the same.
z=1:5; var(z)       # SAMPLE variance actually, /(n-1) is used. 
sd(z)==sqrt(var(z)) # standard deviation.

z=array(0,c(3,4,2)); z[1:24] # linearize.

# outer product
a=1:3; b=4:5
a%o%b; outer(a,b,"*"); # gives a matrix of axb
f <- function (x,y) cos(y)/(1+x^2); z <- outer(a,b,f) # apply function f to each of 2D mesh (a,b)


#build factor:
f <- factor(v, levels)
factor(wday, c("Mon","Tue","Wed","Thu","Fri"))

comb <- stack(list(v1=v1, v2=v2, v3=v3))  # Combine 3 vectors v1 v2 v3
comb <- stack(list(fresh=freshmen, soph=sophomores, jrs=juniors))

##### From naming to Dataframes   =========================================
# build a NA data frame with n variables, which is to be filled later.
seq_r=data.frame(matrix(NA,1,n)) 

# You can also give names to elements of vectors.
# R interprets (or forces) the names to be character objects.
# asking for a vector's names returns a vector
a=c(x=1,y=1,z=1)
names(a); names(a)[3]

# changing names
names(a) = c("first", "second", "third")

# Vectors can be combined into higher level objects
# The most common ones are matrices, dataframes, lists.

# convert between modes:
# from matrix to df
a=matrix(c(1,2,3,4), nrow=2, byrow=TRUE); a
rownames(a)= c("X", "Y");a
colnames(a)= c("W", "Z");a
a_df=as.data.frame(a)

# from list to df
a_l=list();
a_l[1]<-list(c(W=1,Z=2)); a_l["Y"]<-list(c(W=1,2))
names(a_l[1])<-"X"
names(a_l[["Y"]])[2] <- "Z"
a_l; a_l[2]
a_ldf=as.data.frame(a_l); a_ldf 
# when list as.dataframe, chaos column names, overwrite them
colnames(a_ldf) <- c("X","Y"); a_ldf

# from vector to matrix
cbind(vec); rbind(vec); as.matrix(vec);
matrix(vec,n,m)
# from matrix to vector:
as.vector(mat)

# vector to df
as.data.frame(vec); as.data.frame(rbind(vec))


clean <- na.omit(dfrm) # One solution is simply to remove all rows that contain NAs.

# To combine the columns of two data frames side by side, use cbind:
 all.cols <- cbind(dfrm1,dfrm2)
# To “stack” the rows of two data frames, use rbind:
 all.rows <- rbind(dfrm1,dfrm2)
# Use the merge function to join the data frames into one new data frame 
# based on the common column; It also discards rows that appear in only one data frame 
m <- merge(df1, df2, by="name")

attach(dataframe)  # add to search list
detach(df)

z <- with(suburbs, (pop - mean(pop)) / sd(pop))


# R has default behaviours - e.g. matrix(c(1,2,3,4)) makes a matrix with 1 column.
# dataframe - Generalization of a matrix - collection of vectors of the same length.
# very common & useful object to use when handling data.

lab=data.frame(name=c("Tom","Andrew","Helen"),age=c(41,25,28)); lab
# If your data is captured in several vectors and/or factors
dfrm <- data.frame(v1, v2, v3, f1, f2)
# If your data is captured in a list that contains vectors and/or factors
dfrm <- as.data.frame(list.of.vectors)

# if the rows of your data are stored in lists rather than one-row data frames.
# In that case, obs will be a list of lists, not a list of data frames.
dfrm <- do.call(rbind,Map(as.data.frame,obs))

# The functions rbind() and cbind() to combine objects by row or by column
# Can use to add rows or columns to a matrix
# To add bits to a data frame; new columns must be vectors of the same length as the existing entries
# (R will complain otherwise)

lab$OS=c("Linux", "Mac", "Mac")  ; lab  # creat column OS if not exist.
lab=cbind(lab, gender=c("M", "M", "F")); lab
names(lab); head(lab);
lab[,2]; lab$age; lab[,"age"];  # selecting; all the same thing. display as row vector
dim(lab[,"age"])
dim(lab)

# Let's add a new row to the data frame; a row is like an entry(objects), while column is category(variable).
# New rows need to be a data frame with the same number of elements
# Look what happens to the "age" column when we add a character string to it,
# rather than a number as expected
lab=rbind(lab, data.frame(name=c("Fred"), age="Dead", OS="Windows", gender="M"));lab
lab=rbind(lab, c(name="Fred", age="Dead", OS="Windows", gender="M"));lab  # same effect as the last line

lab$age # R has coerced this to be a character vector rather than numeric, since a "string" was added.

##### A list is the most general object in R   =============================
# - a collection of objects of any class and size - even a list of lists
list.example=list(tomlab=lab, random.numbers=runif(100), logicals=c(T,F,F,F)) 
list.example$logicals
list.example$random.numbers

str(list.example) # summary of the structure of an object
names(list.example) 
list.example$logicals
list.example$tomlab$name # multiple subsetting

list[[]] # the content of a list
list[]   # still a one element list
years[["Johnson"]] <- NULL  # Remove the element labeled "Johnson"
lst[sapply(lst, is.null)] <- NULL # Remove NULL elements from a list.
lst[is.na(lst)] <- NULL ; lst[lst == 0] <- NULL
lst[abs(unlist(lst)) < 1] <- NULL;  lst[lapply(lst,abs) < 1] <- NULL
mods[sapply(mods, function(m) summary(m)$r.squared < 0.3)] <- NULL

#flatten the list into a vector before printing:
cat("IQ Scores:", unlist(iq.scores), "\n")


for (nm in names(lst)) cat("The", nm, "limit is", lst[[nm]], "\n")


# dangerous to use: rm(list=ls())  # dump, clear the whole environment.

#####   Referencing components of objects  ===============================

v=c(1,4,9,16,25)

# indices start at 1; use square brackets to reference parts of vectors
v[1]

v[c(1,2,3)] # a vector; square brackets enclose the elements of v that we want
v[1:3] # remember 1:3 is shorthand for c(1,2,3)

# logical tests - all return vector objects
v>3
v==4
v!=4

# An example of logical indexing
v[c(TRUE, TRUE, FALSE, TRUE, FALSE)]

# although careful about recycling...
v[c(TRUE, FALSE)]

# This is the basis of extracting parts of objects with conditional statements
# here, sqrt(v)>3 is a vector of logicals, with length v
v[sqrt(v)>3]

v[v<1 | v>10]
v[v<1 & v>10] # numeric vector of length zero

# resampling from elements of a vector - very useful for bootstrapping and reshuffling
v[c(1,2,3,4,5)] 
sample(v) # size is default to length(z);  replace=FALSE by default.
sample(v, size=20, replace = TRUE)
sample(v, size=20, replace = FALSE) # not sensible

# sample uses the random number generator - we make the outcome repeatable by setting the seed.
set.seed(1); sample(v) # you need to reset seed to the fixed number every time before sample.

# changing elements
v=runif(10);v
v[v<0.1]=0;v

# can removing elements by specifying negative indices
v[-c(1,3)]

# indexing by name
a=c(J=100, K=200, L=300)
a[["J"]]; class(a[["J"]]) # useful if you want to reference elements by a character string
a["J"]; class(a["J"])   # this will also provide a header J, keeps the name of the elements. 
                        # still a list of the same kind of a.
entry="K"
a[[entry]]= 0; a # same effect as a[entry]=0

getwd()
setwd("/home/john/Dropbox/AMS_534/") 
# different directories actually represent different Projects/Sections.

# Elements of matrices;
a=matrix(runif(25), nrow=5, byrow=TRUE)

a[1,] #= first row = vector    
a[,2] #= second col, also a vector
# it seens R is not sensitive to a vector being row or column, every vector is displayed as row vector.

#extract dimensions  - returns a vector = (rows, cols)
dim(a);  1:dim(a)[2]

# add some column names. Join strings with "paste"
colnames(a) = paste("Column.", 1:dim(a)[2], sep="");a

# Note several things here:
# The first element in paste is of length 1, the second is a vector 1:5; R recycles "Column."
# Rather than using 1:5 for the column numbers, we were safe and used dim(a)
# sep="" means we put no spaces between the things we are joining

letters; # a intrinsic character array from a to z
rownames(a)=letters[1:dim(a)[1]];a
a[rownames(a)=="b",]  # here rownames and colnames are default attributes of a matix, not dataframe yet.
dimnames(a); dimnames(a)[1]; dimnames(a)[[1]]; # row and col together.
a[2,] # same thing
a[1:2, 3]  # submatrix

# indexing dataframes: these are all equivalent
lab[["name"]]
lab[,1] # first column of a
lab$name

#subsets
lab[ lab$OS>"M", ]; 
lab[ lab$OS>"Mac", ]
subset(lab, OS>"M")  # same effect
subset(dfrm, select=c(colname1, ..., colnameN))
subset(dfrm, subset=(response > 0))
subset(dfrm, select=c(predictor,response), subset=(response > 0))

##### Sorting etc.   ====================================================

# Sort, order, rank, which
v=c(78,34,21,21,424,101)
sort(v, decreasing=TRUE) # default is increasing.

# "order" returns the list of indices that correspond to the sorted entries in the vector 
# order can process multi-demonsional ranking
places = order(v, decreasing=TRUE) ; places # results: the first/highest in v is the 5th element in original v.
v[places] ; sort(v,decreasing=TRUE)==v[places]  # same effect as the return value of sort(v).

# "rank" is similar but gives you the indices of the sorted entries, handles ties 
rank(v); v[rank(v)] # increasing by default.
which(v<30)  # similar to find in matlab.

 

##### Control Statements    ==============================================

# control statements &, |, <=, == etc.
1==2

a=1:10; b=11:20; ifelse(a>4, a, b) # so intense!
a=if(2>1) 999 else 0; a

# comparison of vectors element-by-element:
c(TRUE, TRUE, FALSE) & c(TRUE, FALSE, FALSE) 


#  FOR loops are usually slow
v=1:1e6   ;
sumsq=0
system.time(for(i in 1:length(v)) sumsq=sumsq+v[i]^2)
#Compare to 
system.time(sum(v^2))  # timing function.

##### Searching and cross-referencing (towards relational databases) ======================

# Use  %in% and match 
v=c(5,4,7,2,9,3) 

# Do elements of another vector appear in v?
c(1,2,3) %in% v

# At what positions in v do these elements appear?
match(c(1,2,3),v)

##### Functions    ===================================================

#Functions return the last expression evaluated inside it;
#...you can be clear about this by signalling exit with return() 
# call by value.

# Global variables: Within a function you can change a global variable by using the <<- assignment operator, but this is not encouraged.

f=function(x) sum(x>10)

# more complex example
my_factorial=function(x){
  if (trunc(x)!=x || x<0) {print("error!"); return(NA)} # truncating towards 0
  if(x==0) return(1) # 0! is defined to be 1
  f=1
  temp=x
  while(temp>1){
    f=f*temp
    temp=temp-1
  }
  return(f)  # this line could be just "f"
}

# R has the same thing built-in... factorial(x)

#####  Repeated operations: apply ======================================


# Using apply to operate on rows or cols of matrices
m=matrix(c(70,12,42,87,19,25,67,12,89),nrow=3, byrow=TRUE);m
apply(m, MARGIN=2,FUN=sort, decreasing=TRUE)  # MARGIN determines the row or column being applied.
# margin=1 for row; =2 for column. MARGIN has to be capital word.
rownames(m)=letters[1:3];m
apply(m, MARGIN=a,FUN=sort, decreasing=TRUE)

## Compute row and column sums for a matrix:
x <- cbind(x1 = 3, x2 = c(4:1, 2:5)); x
dimnames(x)[[1]] <- letters[1:8]; x
apply(x, 2, mean, trim = .2)
col.sums <- apply(x, 2, sum); col.sums
row.sums <- apply(x, 1, sum); row.sums
rbind(cbind(x, Rtot = row.sums), Ctot = c(col.sums, sum(col.sums))) # so nice statistics!!!

stopifnot( apply(x, 2, is.vector))

# lapply always returns the results in list, 
# whereas sapply returns the results in a vector if that is possible:
lst <- lapply(lst, fun) 
vec <- sapply(lst, fun)  # lst can be dfrm.
sapply(1:10, seq)

# can use nameless functions
sapply(1:10, function(x){x^2})
# same as (1:10)^2
tests <- lapply(scores, t.test)
sapply(tests, function(t) t$conf.int) # display CI from last step.

# You want to apply the function element-wise to vectors and obtain a vector
# result. Unfortunately, the function is not vectorized; that is, it works on scalars but not on vectors.
# Use the mapply function. It will apply the function f to your arguments element-wise:
mapply(f, list1, list2, ..., listN)
mapply(f, vec1, vec2, ..., vecN)
mapply(gcd, c(1,2,3), c(9,6,3))  # replace for loop.

# You want to apply a function to groups of rows within a data frame.
by(dfrm, factor, fun)
by(trials, trials$sex, summary)
models <- by(trials, trials$sex, function(df) lm(post~pre+dose1+dose2, data=df))
lapply(models, confint)


### R course - Lecture 2

##### Load libraries: ======================================================

library(lattice)    # this is to source/load the library.
library(gplots)     # to install.packages("gplots")
require(gplots)     # does the same thing as library()

install.packages("gplots")
install.packages("ggplot")
if (!"xtable" %in% rownames(installed.packages())) install.packages();

# We'll be using two example datasets:
# 
# - Mortality rates due to malignant melanoma between 1950-1969 in white males, by state
# - 2008 Election results by state
#

##### Loading file/ import data  ======================
d=read.table("USmelanoma.txt")
p=read.table("Election2008-by-state.txt")

# Quick summary of the dataframes:
summary(d)
summary(p)

# advanced sort, order, rearrange.
idx=order(rownames(d),decreasing=TRUE)
idx=order(d$ocean,-d$mortality,decreasing=TRUE); d1=d[idx,]  # -d$mortality change decreasing to increasing.
d1[d1$ocean=="yes",][1:3,]  # results could be re-indexed directly.
d1[d1$ocean=="yes",][1:3,][2,]  # even works!!!! So, temporary/intermediate results can be directly used.
# what d1$ocean=="yes" gives is just a logic index, it's as simple as that.


##### Graphics, plotting:  =======================================================
# The mac command is quartz(); PC is windows(), Linux is probably x11()
x11(width=6, height=3)

# this is not necessary usually - a graphics command will usually open one automatically
# but sometimes the default size (7x7 inches) is not appropriate


# Box-whisker plots and histograms:

# 'boxplot' gives a summary of a vector of data - median, 25% and 75% quartiles, min and max
boxplot(d$mortality, horizontal=TRUE, main="Mortality in all states", xlab="Mortality"); # main is title of the plot
# when you invoke a plotting command, R usually returns an object as well as making the graph
bb=boxplot(d$mortality, horizontal=TRUE) # boxplot gives some statistics of the data.
names(bb);
bb$stats; # e.g. get the values of the box and whiskers, quartiles
bb$n;     # number of the samples
bb$conf

# plot into file: 
savePlot(filename="filename.ext", type="type")

png("myPlot.png", width=648, height=432) # not appendable 
plot(x, y, main="Scatterplot of X, Y")
dev.off()

pdf(file="plot"); boxplot(d$mortality, horizontal=TRUE); dev.off() # default to append plots

# histogram
hist(d$mortality)
# by default R uses an algorithm to calculate reasonable breaks, but you can override it
hist(d$mortality, breaks=20)

# multiple overlapping histogram.
#Random numbers
h2<-rnorm(1000,4);  h1<-rnorm(1000,6)
# Histogram Grey Color
hist(h1, col=rgb(0.1,0.1,0.1,0.5),xlim=c(0,10), ylim=c(0,200), main="Overlapping Histogram")
hist(h2, col=rgb(0.8,0.8,0.8,0.5), add=T); box() # the third arg of rgb is transparancy.
# Histogram Colored (blue and red)
hist(h1, col=rgb(1,0,0,0.3),xlim=c(0,10), ylim=c(0,200), main="Overlapping Histogram", xlab="Variable")
hist(h2, col=rgb(0,0,1,0.1), add=T); box()

# Plot density curve.
dat <- rnorm(1000) ; extra_dat <- rnorm(1000)
plot(density(dat),col="blue")
lines(density(extra_dat),col="red")

# fancy scattering plot with distribution on flanks.
http://www.statmethods.net/advgraphs/layout.html
# line shapes
http://www.cookbook-r.com/Graphs/Shapes_and_line_types/
  http://students.washington.edu/mclarkso/documents/line%20styles%20Ver2.pdf
  set.seed(331)

# Set up the plotting area
plot(NA, xlim=c(1,4), ylim=c(0,1))
# Plot solid circles with solid lines
points(1:4, runif(4), type="b", pch=19)
# Add open squares with dashed line, with heavier line width
points(1:4, runif(4), type="b", pch=0,  lty=2, lwd=3)
points(1:4, runif(4), type="b", pch=23,   # Diamond shape
       lty="dotted", cex=2,               # Dotted line, double-size shapes
       col="#000099", bg="#FF6666")       # blue line, red fill
  
# Side by Side histograms
require(ggplot2);
df <- data.frame(apple = rnorm(n = 1000, mean = 5, sd = 2),
                 pear = rnorm(n = 1000, mean = 2),
                 orange = rnorm(n = 1000, mean = 10))
ggplot(melt(df), aes(value, fill = variable)) + geom_histogram(position = "dodge")

# We might want to put the histogram and the boxplot together in one window
# Remove old windows (clutter) & make new one
graphics.off()
x11(width=6, height=5)

# look at ?par for details

# Here - make 2 plotting areas in a column, and "cex" ("character expansion") makes text smaller 
# using 'par' in this way sets the options for the window as a whole.
# You can also pass some of the 'par' parameters into plots individually (e.g. vary text sizes
# between plots

par(mfrow=c(2,1), cex=0.7) # plot parameters. mfrow/mfcol subplot with row first or col first.
par(mfrow=c(1,2),cex=0.8);  plot(mortality ~ latitude, data=d); plot(mortality ~ d$longitude, data=d)
# mfcol is multi figure, colomn first.

# We would also like both plots to be on the same horizontal scale so everything lines up nicely
mrange=range(d$mortality)*c(0.96, 1.04)
boxplot(d$mortality, horizontal=TRUE, main="Mortality in all states", xlab="Mortality", ylim=mrange)
hist(d$mortality, main="", xlab="", ylab="", xlim=mrange, axes=T)
hist(d$mortality, main="", xlab="", ylab="", xlim=mrange, axes=FALSE)
axis(1) # this adds the x-axis to the current plot


#  Basic use of "plot"
x11()
plot(x=d$latitude, y=d$mortality)

# You can also use the "with" function, which makes a space in which the components of d are variables
# 'with' helps to make code look cleaner (avoids having to use $, [["x"]], etc. to refer to components)
with(d, plot(x=latitude, y=mortality))

# Another alternative: "plot" (and many other functions) take formulas as expressions
# Formulas represent regression relationships
# formula "y ~ x" means "y modelled as a function of x"
# within "plot" you tell it which data frame to find y and x in 
plot(mortality ~ latitude, data=d)

# "plot" tries to act appropriately depending on what you give it
# E.g. "ocean" is a categorical variable - a factor
str(d)
is.factor(d$ocean)
# factors are useful for regression
# They are stored internally as numbers

# Another example of context-dependence: plotting "continuous" vs. "factor" gives parallel boxplots
plot(mortality ~ ocean, data=d)    #  "continuous" vs. "factor"

# Is latitude is more correlated to melanoma mortality than longitude?
plot(mortality ~ latitude, data=d, type="n") # i guess type=n supress the polt
plot(mortality ~ latitude, data=d)
ifelse(d$ocean=="yes", "blue", "red")
plot(mortality ~ latitude, data=d,col=ifelse(d$ocean=="yes", "blue", "red"), cex=0.7)
text(x=d$latitude, y=d$mortality, labels=rownames(d), col=ifelse(d$ocean=="yes", "blue", "red"), cex=0.7)
legend("topright", lty=0, legend=c("Coastal State", "Land State"), bty="n",cex=1.4, text.col=c("blue", "red"))

# make a political map of US
plot(x=d$longitude, y=d$latitude, type='n', xlim=rev(range(d$longitude))) # use xlim to reverse the x-direction.
text(y=d$latitude, x=d$longitude, labels=rownames(d), col=ifelse(d$ocean=="yes", "blue", "red"), cex=0.7);
rev(d$longitude)
# can see e.g. that incidence is lower in land states than in ocean states for a given latitude.


##### Passing arguments into functions - 1   ===============================================
# Be careful when passing in unnamed parameters...

xvalues=1:10
yvalues=xvalues^2
plot(yvalues, xvalues, type="b")     # wrong
plot(y=yvalues, x=xvalues, type="b") # right
plot(yvalues ~ xvalues, type="b")    # also right
# so it got to be plot(x, y) or plot(y ~ x)

# Can pass in optional unnamed arguments to inner functions.
iqr=function(x,...){
	q=quantile(x, prob=c(0.25, 0.75), names=FALSE, ...)
	return(q[2]-q[1])
}

v=rno100, mean=0, sd=10)  # random normal distribution.
quantile(v, prob=c(0.05, 0.25, 0.5, 0.75,0.95), names=FALSE)

v[sample(1:100, 5, replace=FALSE)]=NA  # randomly select 5 out of 100 elements in v, and set them to NA
#iqr(v)
iqr(v, na.rm=TRUE)
# compare to R's built-in function IQR
IQR(v, na.rm=TRUE)

# you can look at R's built in code for IQR;
# see that it uses the diff() function (look it up)
IQR

#################################################  Rstudio can perform folding for 5 #s.
# Using tapply to work out summary statistics by factor; t is for facTor ?
# tapply(x, INDEX(is.factor), FUN,...)
# ... means "Apply the function FUN to subsets of x determined by INDEX
tapply(x, f, fun)
# Here, x is a vector, f is a grouping factor, and fun is a function. 
tapply(d$mortality, d$ocean, mean)
with(d, tapply(mortality, ocean, mean))

# If your function returns multiple values, tapply returns a list, or each level of the factor:
is.factor(d$ocean); is.factor(d$mortality)
with(d, tapply(mortality, ocean, range))


#####  Using "table" to enumerate instances of categorical variables  ============
# Combine the melanoma data (d) and the 2008 election data (p) 

# check that the row names match up
all(rownames(p) == rownames(d))

alldata=cbind(d,p)
# enumerate combinations of party and proximity to ocean
x=table(alldata$ocean, alldata$president); x
x=with(alldata, table(ocean, president)) ;x # nicer, also gives names of the categorical variables being tabled.
with(alldata, table(ocean,president, governor))

Z <- stats::rno10000)
Zt = table(cut(Z, breaks = -6:6))

#####  Debugging: Pitfalls #####
mean(9,10,11) # gives 9, mean(c(),...)
mean(c(9,10,11))

