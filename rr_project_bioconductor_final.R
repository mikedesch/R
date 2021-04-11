


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

##########################
##
## End: GLOBAL IMPORTS
##
##########################










############################################################
##
## Begin: load my variants.vcf file into VariantAnnotation
## Based on YT tutorial by Valerie Obenchain
## YT: https://www.youtube.com/watch?v=Ro0lHQ_J--I
##
############################################################



## extract into a matrix:
## the zygosity for each of the 100 samples : for each of the 18,318 loci

zygosityMatrix <- readGeno("variants.vcf", "GT", row.names = FALSE)
zygosityMatrix
class(zygosityMatrix)


##
##
## readGeno() outputs a matrix of
## form, eg: zygosityMatrix(row#,col#)
##
##
## zygosityMatrix[1,10]
##
##



############################################################
##
## End: load my variants.vcf file into VariantAnnotation
## Based on YT tutorial by Valerie Obenchain
## YT: https://www.youtube.com/watch?v=Ro0lHQ_J--I
##
############################################################







#############################################
##
## Begin : function zygosityCountsPerSample()
##
#############################################


zygosityCountsPerSample <- function(GTmatrix){
  
  
  ## NO LONGER A GLOBAL MATRIX B/C ALL PROCESSING FOR THE CSV IS NOW WITHIN THIS FUNCTION
  ## defining dimensions of GTResultsMatrixPerSample, which is a matrix of 100-columns, 4-rows;
  ## i.e. dim(GTResultsMatrixPerSample) returns [1] 100  4 (rows first, columns second)
  GTResultsMatrixPerSample <- matrix(nrow = 100, ncol = 4)
  dim(GTResultsMatrixPerSample)
  
  
  
  ## getting the dimensions of the matrix that is received as an argument to this function
  numberLoci       <- dim(GTmatrix)[1]
  numberSamples    <- dim(GTmatrix)[2]
  
  
  
  
  ## for-loop used to iterate on the columns of the GTmatrix,
  ## adding up counts for each of "./.", "0/0", "1/1", "0/1"
  ## via the count(matrix, value=termToMatchOn) function
  
  ## C.f. this "outer" loop (to the inner "count()" loops) is in row-major order
  ## i.e. akin to the elements of a row being consecutively referenced / "contiguous in memory"
  for (i in 1:numberSamples){
    
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
    numberGTNotAvailable      <- count(GTmatrix[,i], value = "./.")
    
    numberGTHomozygousRef     <- count(GTmatrix[,i], value = "0/0")
    
    numberGTHomozygousAlt     <- count(GTmatrix[,i], value = "1/1")
    
    numberGTHeterozygous      <- count(GTmatrix[,i], value = "0/1")
    
    
    
    
    ## saving the resulting counts for each sample in a globally-accessible matrix of size 100 rows x 4 columns
    ## (each of the 100 samples has 4 counts)
    GTResultsMatrixPerSample[i,1] <- numberGTNotAvailable
    GTResultsMatrixPerSample[i,2] <- numberGTHomozygousRef
    GTResultsMatrixPerSample[i,3] <- numberGTHomozygousAlt
    GTResultsMatrixPerSample[i,4] <- numberGTHeterozygous
    
    
  }
  
  
  ## writing the GTResultsMatrixPerSample matrix -> .csv file ; for import into JMP for visualizing data
  write.csv(GTResultsMatrixPerSample, "GTResultsMatrixPerSample.csv")
  
}


#############################################
##
## End : function zygosityCountsPerSample()
##
#############################################


zygosityCountsPerSample(zygosityMatrix)


## Function for getting an average for Run-Time performance
## for a user-provided (default = 50) number of iterations
## Output: a RunTimePerformanceResultsMatrix.csv file containing
## the results
getRunTimePerformance <- function(number = 50){
  
  ## Matrix used to store the results from each of the Run-Time performance tests.
  RunTimePerformanceResultsMatrix <- matrix(nrow = number, ncol = 1)
  

  for (i in 1:number){
    
    ## Ensure that the outputs from each iteration of the loop
    ## are removed between each iteration of the performance test.
    if (exists("zygosityMatrix")){ rm(zygosityMatrix) }
    if (exists("GTResultsMatrixPerSample")){ rm(GTResultsMatrixPerSample) }
    
    ## re-initializing the GTResultsMatrixPerSample to an empty matrix ; dim = [1] 100 4
    GTResultsMatrixPerSample <- matrix(nrow = 100, ncol = 4)
    
    
    StartTime <- Sys.time()
    
    
      zygosityMatrix <- readGeno("variants.vcf", "GT", row.names = FALSE)
    
      zygosityCountsPerSample(zygosityMatrix)
      
    RunTime <- Sys.time() - StartTime
    
    ## Saving each Run-Time result to RunTimePerformanceResultsMatrix[]
    RunTimePerformanceResultsMatrix[i,1] <- RunTime
    
  }
  
  
  write.csv(RunTimePerformanceResultsMatrix, "RunTimePerformanceResultsMatrix.csv")
  
    
}


getRunTimePerformance(10)







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







