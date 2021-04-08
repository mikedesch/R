#example from Derek Banas Tutorial
# https://www.youtube.com/watch?v=s3FozVfd7q4

# data() shows built-in datasets -> not super useful
# head(dataset_name, ##) shows first## rows in the data set
# able to execute multiple statements per line by delimiting by ;
# eg data(esoph);head(esoph,10) -> loads esoph data, and writes first 10 rows

mlbPlayers=read.table(file=file.choose(),
                      header=T, sep=(" "),
                      na.strings="`",
                      stringsAsFactors = F)


# how does average affect RBI (runs batted in)

playerData = mlbPlayers[,c("RBI","AVG")] # c( .. ) =vector


png(file="player_rbi_avg.png") # png file, scatter plot

# the data frame
plot(x=playerData$RBI, y=playerData$AVG,
     xlab="RBI", ylab="AVG", main="RBIs and Average")


dev.off()

# at this point, can highlight all of the above -> click on Run



# for assignments, can use = or <-
# var <- <string>
# vars start with letter, contain #s, underscores, or dots
# dynamic typing of vars



# DATA TYPES

print(class(4))
print(class(T))
print(class(4L))
print(class("sample text"))
print(class(charToRaw("sample text")))



is.integer()
is.character()
is.complex()



# string interpolation; also: whitespace does not matter (at least here)
sprintf (" 4 + 5 = %d", 4+    5 )


#floating point w/ div
sprintf("1 / 7 = %0.5f",1/7)

#exponential op
sprintf("1 ^ 7 = %0.5f",1^7)

# modulus div
sprintf(" 7 % 3 = %d", 7%%3)




# VECTORS IN R
# vectors just store multiple (different) values

#create a vector
numbers = c(1,3,5,6)
# 1-based indexing


numbers[1]

length(numbers)

numbers[length(numbers)]

numbers[-1] # describing everything that we don't want to get; will return everything except the value at index=1

# passing a vector containing multiple values, as an index, to the numbers vector
numbers[c(-4,-3)] # what to exclude
numbers[c(1,2)] # what to include

# specifying index values via a range, i.e. provide a minIndex#:maxIndex# ; these are inclusive of minIndex#, maxIndex#
numbers[2:4]



# replace a value

numbers[1] = 100
numbers[2:4] = 1001
numbers[2:4] = c(1001, 901, 801)
# above and below lines are the same, just referenced by a range, or by a vector
numbers[c(2,3,4)] = c(1001, 901, 801)

numbers


# sorting

sort(numbers, decreasing=F)

oneToTen = 1:10 # strictly assignment, doesn't include a print command by default
oneToTen # printing the var oneToTen

add3 = seq(from=3, to=99, by=3)
add3



evens = seq(from=2, by=2, length.out=5) # when you know the **# of values** you want the output to contain
evens

evens2 = seq(from=2, by=2, to=10) # when you know **up to what value** you want your output to contain
evens2
help(seq)


sprintf("4 in evens %s",4 %in% evens)


rep(x=2, times=5, each=1)


rep(x=c(1,2,3), times=3, each=1)

rep(x=c(1,2,3), times=2, each=2)



# relational operators

#typical = != > < <= >= 


oneToTwenty = c(1:20)
oneToTwenty

isEven = oneToTwenty %% 2 == 0
isEven

justEvens = oneToTwenty[oneToTwenty %% 2 == 0]
justEvens

# wrt justEvens (above) and justOdds (below): we can access the members of a vector by passing T/F values as indices
# the # of T/F values passed must = the dimension of the vector; dimension = # of values
# cf accessing the values in a vector via
# oneToTwenty[#], oneToTwenty[#:#], oneToTwenty[c(#,#)], oneToTwenty[-#], oneToTwenty[c(-#,#)]


justOdds = oneToTwenty[c(T,F,T,F,T,F,T,F,T,F,T,F,T,F,T,F,T,F,T,F)]
justOdds


# LOGICAL OPERATORS


cat("testing test test TRUE %% FALSE =", T && F, "\n")

cat("testing test test TRUE || FALSE =", T || F, "\n")

cat("testing test test !TRUE =", !T, "\n") 



# DECISION MAKING IN R

age = 15

if (age>=18){
  
  print("drive and vote") 

}else if (age>=16){
  print("drive")
} else{
  print("wait")
}



grade = "c"
switch(grade,
       "A" = print("greate"),
       "B"= print("good"),
       "C" = print("okay"),
       print("no such grade") # default case
)




# STRINGS

str1 = "this is a string"

nchar(str1)


sprintf("eggo > egg = %s", "eggo" > "egg")
sprintf("eggo == egg = %s", "eggo" == "egg")

str2 = paste("Owl", "Bear", sep="")
str2


# substring

# INDEXING IS INCLUSIVE -- ALWAYS
# you have 7 characters in "testing"; therefore start = 4, stop=10, because 10-4=6
# but this is subtraction, so we have to then add 1, in order to be inclusive
substr(x=str2, start=4, stop=10)



# SUBSTITUTE

sub(pattern="Owl", replacement="Hawk", x=str2) # substitutes the FIRST match


gsub(pattern="egg", replacement = "chicken", x="egg egg")



# split text into vectors
strVect = strsplit(" the quick brown fox", "")
strVect

help("strsplit")
# from the help doc for strsplit:
x <- c(as = "asfef", qu = "qwerty", "yuiop[", "b", "stuff.blah.yech")
# split x on the letter e
strsplit(x, "e")



length(strVect)
cat(strVect) # cat does not handle arguments of type list
print(strVect)


##############################################
#
# LEFT OFF @: https://www.youtube.com/watch?v=s3FozVfd7q4&t=29m30s
#
##############################################


## begin: random stuff

myvar <- c("test",1,"coding",2,"vari")

myvar[1]

dim(myvar) <- 5

dim(myvar)

help(dim)

x <- matrix(1:27,3)
y <- array(1:10, c(2,5))
x
identical(x,y)
dim(x)
cat("dimension of y is", dim(y))
cat("dimension of x is", dim(x))
dim(y) <- NULL


help(system.file)

help(readGT())

## end: random stuff

