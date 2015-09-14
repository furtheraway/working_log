# there are couple of R files in the directary /Dropbox/AMS_534/project/

# 1. Methylation.R 
is the oldest. I cant remember what problem it has, but just dont use it.
(it seems the window boundary files used here is problematic; i.e. boundary and not identical between chr1.+.800.dmr and chr1.-.800.dmr)
Its result is located in chr1_B_D_1_6

# 2. Methylation_start_at_least_5.R 
(with correct dmr files; i.e. window boundaries.)
this shiftes the beginning of a window to the first methylated position; but may not disgard windows having less than 5 mC positions.
Its result is located in strict_set

# 3. Methylation_start.R
(with correct dmr files; i.e. window boundaries.)
This strictly start a window at the beginning defined in dmr files, even if there is no methylation at the position files(1B.chr1.+.800 etc.).
Its result is located in strict_set folder, prefixed with "bare_start_"