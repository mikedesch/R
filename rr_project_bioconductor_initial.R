install.packages("vcfR")

library(vcfR)
data(vcfR_example)
vcf

strwrap(vcf@meta[1:7])

# data(./variants.vcf)
# help(vcfR)

help(vcfR)


# read.vcfR() -> read in (sub) sets of VCF data, reads the data into a VCF Class (in R)

# readGT(), readGeno(), readInfo() -> don't read all the VCF data into a VCF Class (in R),
# but instead read in single variables from the VCF file (i.e. numeric, character,
# vector, depending on the dimension of the data being read in)
# -> JUST A SINGLE FIELD, and more readily computable form of the data (for R pipelines, etc.)


#readVCFAsVRanges() -> a flattened form of the data;reads data into a VRanges Class (an extension
# of the GRanges Class); it expands the data BY SAMPLE

read.vcfR("variants.vcf") %>%
                          vcfR::AD_frequency()


# COMPARE the library(vcfR) package library ( VCF file manipulation and visualization tool) TO:
#
# library(VariantAnnotation)

# VariantAnnotation dependencies:
# Biocmanager package
# Rtools (?)



##########################
##
## Begin: GLOBAL IMPORTS
##
##########################


## wrt library(examplePackage) and require(examplePackage) functions:
## each loads the namespace of the package with name examplePackage, and attaches
## the namespace to the search list. require() is designed for use inside other functions:
## it returns FALSE (w/ a warning, rather than library()'s error) if examplePackage DNE
## both functions: check and update the list of currently attached packages AND do **not**
## reload a namespace which is already loaded!

## C.f. reload a package with either of library() or require() by first calling either of
## detach(unload = TRUE) OR unloadNamespace(), and THEN calling the library/require fxn

## Begin: VariantAnnotation

    if (!requireNamespace("Biocmanager", quietly = TRUE))
      install.packages("Biocmanager")
    
    # check version of the installed Biocmanager package
    BiocManager::version()
    
    # VariantAnnotation installs via Biocmanager, c.f. NOT via install.packages("VariantAnnotation")
    
    # proper installation of VariantAnnotation
    BiocManager::install("VariantAnnotation")
    
    
    library(VariantAnnotation)

## End: VariantAnnotation


## Begin: dplyr (data manipulation, including for piping, i.e. %>%)

    library(dplyr)
    
## End: dplyr (data manipulation, including for piping, i.e. %>%)

## Begin: "benchmarkme" -> https://github.com/csgillespie/benchmarkme
    
    install.packages("benchmarkme")

    library(benchmarkme)

## End: "benchmarkme" -> https://github.com/csgillespie/benchmarkme
    
## Begin: (TEST) measuring memory allocated by functions/objects -> http://adv-r.had.co.nz/memory.html

  install.packages("pryr")
  library(pryr)

## End: (TEST) measuring memory allocated by functions/objects -> http://adv-r.had.co.nz/memory.html


  
## Begin: install maftools
  
  
  if(!require("BiocManager"))
    install("BiocManager")
  BiocManager::install("maftools")
  
  help(require)
  ## require() returns false if the package does not exist!
  
## End: install maftools
  
  
##########################
##
## End: GLOBAL IMPORTS
##
##########################

############################################################
##
## Begin: YT https://www.youtube.com/watch?v=Ro0lHQ_J--I
## Valerie Obenchain - Reading VCF data
##
############################################################



## used to load example data from the package
fl <- system.file("extdata", "chr7-sub.vcf.gz", package="VariantAnnotation")

object_size(fl)
  
## read vcf with arguments= (file,genome build)
vcf1 <- readVcf(fl,"hg19")
## dim(vcf1) = 3791 2 (i.e. contains 3,791 variants and 2 samples)
vcf1

## the above call to the VcfClass object, "vcf1": the VcfClass formats the output
## from each of the seven (7) functions below ;
## this formatted/encapsulated data *is* the VcfClass object
class(vcf1)
dim(vcf1)
rowRanges(vcf1)
info(vcf1)
info(header(vcf1))
geno(vcf1)
geno(header(vcf1))


## select range -- if we know a range of variants we are interested in:
## we can create a ScanVcfParam object, and pass this as an argument into reafVcf
which <- GRanges("7", IRanges(55000723, width=1000))
param <- ScanVcfParam(which=which)
vcf2 <- readVcf(fl, "hg19", param=param)
vcf2

writeVcf(vcf2, "selectedRange_hg19_chr7.vcf")

dim(vcf2)

help("GRanges")
help("ScanVcfParam")
help("writeVcf")


## select fields (field=)
param <- ScanVcfParam(info="SS", geno="GT")
vcf3 <- readVcf(fl, "hg19", param=param)
vcf3


writeVcf(vcf3, "selectedField_SS-GT_hg19_chr7.vcf")
help("ScanVcfParam")

## read single field
ft <- readGeno(fl, "FT", row.names = FALSE)
class(ft)
dim(ft)
apply(ft,2,table)
help(apply)

## expanded form
vranges <- readVcfAsVRanges(fl, "hg19", use.names = TRUE)


############################################################
##
## End: YT https://www.youtube.com/watch?v=Ro0lHQ_J--I
## Valerie Obenchain - Reading VCF data
##
############################################################







############################################################
##
## Begin: load my variants.vcf file into VariantAnnotation
## Based on the above tutorial by Valerie Obenchain
##
############################################################


# HOW TO: load your own data from a VCF file
fl <- readVcf("variants.vcf")
fl
class(fl)

object_size(fl)
class(fl)


## select fields (field=)
param <- ScanVcfParam(info="NS", geno="")
vcf1 <- readVcf("variants.vcf", param=param)
vcf1

help("readGeno")
ft <- readInfo("variants.vcf", "AF", row.names = FALSE)
class(ft)
dim(ft)
apply(ft,2,table)
ft

## attempting to extract the % or count of homozygous samples for each contig site (each line)

zygosityMatrix <- readGeno("variants.vcf", "GT", row.names = FALSE)
zygosityMatrix
class(zygosityMatrix)

########################################
##
## readGeno() outputs a matrix of
## form, eg: zygosityMatrix(row#,col#)
##
########################################
zygosityMatrix[1,10]

help(print)


## function that accepts a GT matr

## i don't actually need this extractGTAnnotations function --
## the output of the above readGeno(...) function (as an OBJECT THAT EXISTS IN R)
## is sufficient for calculations, because it already allows me to
## iteratively access the data from both a site and sample POV
## the below nestet loop -- HOWEVER will probably be used, in some manner, to do the calculations of:
## heterozygosity / homozygosity for ref & alt alleles

printGTAnnotations <- function(GTmatrix, numRows, recordSeparator="\n") {

  ## printing the first ## rows (defined by numRows) of VCF records
  ## (i.e. the first ## rows, i.e. the first ## sites / contigs)
  ## containing only the genotype annotation [ 1/1 | 0/1 | 0/0 | ./.]
  ## **for all 100 samples**
  for (i in 1:numRows){      ## outer loop iterates on the rows, i.e. sites
    
    for (j in 1:100)    ## inner loop iterates on the columns, i.e. samples for each site
    {
      cat(GTmatrix[i,j], " ")
    }
    
    writeLines("", con = stdout(), sep = recordSeparator, useBytes = FALSE)
    
  }
  
}


dim(homozygousSiteCounts)[2]

printtGTAnnotations(homozygousSiteCounts, 15, "\n\n")


zygosityMatrix[1,1]
zygosityMatrix[,1]
testMatrix <- matrix(nrow=5, ncol=10)
class(testMatrix)

class(zygosityMatrix)
dim(zygosityMatrix)
count(zygosityMatrix[1,], value = "./.")
help(count)

## defining the dimensions of GTResultsMatrixPerSample, which is a 100-column, 4-row matrix,
## i.e. dim(GTResultsMatrixPerSample) returns [1] 100  4 (rows first, columns second)

GTResultsMatrixPerSample <- matrix(nrow = 100, ncol = 4)
dim(GTResultsMatrixPerSample)


zygosityCountsPerSample <- function(GTmatrix){
  
  ## getting the dimensions of the matrix that is received as an argument to this function
  
  numberLoci       <- dim(GTmatrix)[1]
  numberSamples    <- dim(GTmatrix)[2]
  
  ## for-loop used to iterate on the columns of the GTmatrix,
  ## adding up counts for each of "./.", "0/0", "1/1", "0/1"
  ## via the count(matrix, value=termToMatchOn) function
  
  ## C.f. this "outer" loop (to the inner "count()" loops) is in row-major order
  ## i.e. akin to the elements of a row being consecutively referenced / "contiguous in memory"
  for (i in 1:numberSamples){
    
    ## print("inside loop i = ")
    ## print(i)
    
    ## var definition statements
    ## these 4 counts reset at the beginning of each iteration of this outer loop
    ## (outer loop is for iterating on the samples, i.e. the 100 columns:
    ## one column for each of the 100 samples)
    
    numberGTNotAvailable      <- 0          ## counting all instances of ./.
    numberGTHomozygousRef     <- 0          ## counting all instances of 0/0
    numberGTHomozygousAlt     <- 0          ## counting all instances of 1/1
    numberGTHeterozygous      <- 0          ## counting all instances of 0/1
        
    ## the count() function is used to loop through and count the zygosity numbers,
    ## on a per-sample basis (i.e. count() iterates on the VCF records (i.e. the rows)
    ## of a given sample/column, while the outer loop iterates on the columns themselves)
    ## C.f. these inner loops (to the outer for-loop) is in column-major order
    ## i.e. akin to the elements of a column being consecutively referenced / "contiguous in memory"
    
    help(count)
    numberGTNotAvailable      <- count(GTmatrix[,i], value = "./.")
    
    numberGTHomozygousRef     <- count(GTmatrix[,i], value = "0/0")
    
    numberGTHomozygousAlt     <- count(GTmatrix[,i], value = "1/1")
    
    numberGTHeterozygous      <- count(GTmatrix[,i], value = "0/1")

    
    
    
    ## saving the resulting counts for each sample in a matrix of size 100 rows x 4 columns
    ## (each of the 100 samples has 4 counts)
    GTResultsMatrixPerSample[i,1] <<- numberGTNotAvailable
    GTResultsMatrixPerSample[i,2] <<- numberGTHomozygousRef
    GTResultsMatrixPerSample[i,3] <<- numberGTHomozygousAlt
    GTResultsMatrixPerSample[i,4] <<- numberGTHeterozygous
    
  }
  
  
  ############IN-PROGRESS###################
  ## summary statistics - calculating the average # of all for counts, across all 100 samples
  
  
  averageGTNotAvailable     <- 0          ## average of all instances of ./.
  averageGTHomozygousRef    <- 0          ## average of all instances of 0/0
  averageGTHomozygousAlt    <- 0          ## average of all instances of 1/1
  averageGTHeterozygous     <- 0          ## average of all instances of 0/1
  
  
  
  ############IN-PROGRESS###################
  ## print statements for summary
  ## (will probably remove this after testing -- summarizing 100 samples: meh.)
  
  print("sample 1 zygosity Results:")
  
  cat(sprintf("%i counts of './.'", GTResultsMatrixPerSample[1,1]),"\n")
  cat(sprintf("%i counts of '0/0'", GTResultsMatrixPerSample[1,2]),"\n")
  cat(sprintf("%i counts of '1/1'", GTResultsMatrixPerSample[1,3]),"\n")
  cat(sprintf("%i counts of '0/1'", GTResultsMatrixPerSample[1,4]))
  
}


zygosityCountsPerSample(zygosityMatrix)


help(chisq.test)


help(write.csv)

write.csv(GTResultsMatrixPerSample, "GTResultsMatrixPerSample2.csv")


convertGTResultsMatrixPerSampleTo




printZygosityCountsPerSite <- function(GTmatrix){
  
  
}


help("writeLines")

print(homozygousSiteCounts[1,27])

help(readGeno)

## below writeVcf does NOT work -- the homozygousSiteCounts object has a signature of
## '"matrix", "character"' -> and therefore is not suitable to be written as a VCF file
## writeVcf(homozygousSiteCounts, "genotypeRaw.vcf")

help(write)
write(homozygousSiteCounts, "sampleGenotypesRaw2.txt", ncolumns = 100)

## Setting global option for Limit of max.print
## options(max.print = 1831800)
options(max.print = 1000)


help("readGT")

##########################################################
## begin: testing run-time via Sys.time()
##########################################################

start_time <- Sys.time()

ft %>%
  mean()

Sys.time() - start_time

##########################################################
## end: testing run-time via Sys.time()
##########################################################



##########################################################
## begin: testing run-time via proc.time()
##########################################################

proc_time <- proc.time()

ft %>%
  mean()

proc.time() - proc_time

object_size(ft)


##########################################################
## end: testing run-time via proc.time()
##########################################################


##########################################################
## begin: testing benchmark via benchmarkme package
##########################################################



customPipeline <- ft %>% mean()

rm()

res <- benchmark_std(10,)


##########################################################
## end: testing benchmark via benchmarkme package
##########################################################


##########################################################
## begin: using mem_change() to determine memory usage
## of a pipeline
##########################################################

help(mem_change)

startTime <- Sys.time()

numberTrials <- 15
sum <- 0
means <- c()

for (i in 1:numberTrials) {
  
  ##means[i] <- mem_change(custom)
  means[i] <- mem_change(ft %>% mean())
  
  mem_change(ft %>% mean())
  
  print(means[i])
  sum <- sum + means[i]
}

runTime <- (Sys.time() - startTime)

sprintf("the average memory from %i tests equals: %f
        the total run time of collecting this average was: %s",
        numberTrials, (sum / numberTrials), runTime)






##########################################################
## end: using mem_change() to determine memory usage
## of a pipeline
##########################################################








## Setting global option for Limit of max.print
options(max.print = 1831800)


############################################################
##
## End: load my variants.vcf file into VariantAnnotation
## Based on the above tutorial by Valerie Obenchain
##
############################################################




## Testing


tmp <- readRDS("de_df_for_volcano.rds")
tmp


