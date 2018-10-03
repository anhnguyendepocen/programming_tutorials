## Tutorial 04: Loops, conditions, and custom functions ##

# Now's time to introduce the big three: loops, conditions, and custom
# functions. These may seem like daunting concepts, but learn the basics and
# they'll become your best friends. I think this tutorial may the most important
# of all of them, simply because these 3 relatively simple ingredients, when
# used correctly, can transform your coding game from one of misery to delight
# :)

# Basic conditions --------------------------------------------------------

# A condition is simple way of asking R a yes or no question. If phrased
# correctly and used in 'conditional statements', this 'logic' can be an
# incredibly powerful tool. Conditions are typically comprised of two different
# objects compared with an 'operator'. We learned some operators in tutorial 02.
# Here are a few of the more common examples:
#     ==    "equal to"
#     !=    "not equal to"
#     <=    "less than or equal to"
#     >=    "greater than or equal to"
#     <     "less than"
#     >     "greater than"
#     %in%  "within"
#     !     "not"

# Is 'cat' equal to 'cat'?
'cat' == 'cat' # TRUE

# Is 'cat' not equal to 'dog'?
'cat' != 'dog' # TRUE

# Is 1.00312 equal to 1.00009?
1.00312 == 1.00009 # FALSE

# Is 'cat' less than or equal to 17?
'cat' <= 17 # FALSE

# Is 'cat' NOT less than or equal to 17?
!('cat' <= 17) # TRUE

# Is the sum of 7+12 equal to 712?
sum(c(7,12)) == 712 # FALSE

# Is it TRUE that cat is equal to cat?
('cat' == 'cat') == TRUE # TRUE

# Is 14 less than NA?
14 < NA # NA (NOTE THIS IMPORTANT EXCEPTION!!!)

# Is "a" within this vector?
"a" %in% c(27, 31, "B", "x", 1, "a", 'BOAT', 201.34) # TRUE

# Other useful conditions -------------------------------------------------

# Often times in R it's very important for us to know what data type we're
# working with. Here are a set of helper functions that essentially contain
# conditions for determining if an object matches a particlar data type:
#   is.na()           "Is this an NA?"
#   is.numeric()      "Is this a numeric object?"
#   is.character()    "Is this a character object?"
#   ...               ...

# Is 17 an NA?
is.na(17) # FALSE

# Is 'cat' a character data type?
is.character('cat') # TRUE

# Is "dog", converted to a numeric, a numeric data type?
is.numeric(as.numeric("dog")) # TRUE (Isn't that weird? Pay attention to the warning...)

# There are also several helper functions that are really nice for working with
# conditions involving files:
#   file.exists()   "Does this file exist?"
#   dir.exists()    "Does this directory exist?"

# Does this crazy file exist?
file.exists('/the_cool_one/BeST DtaSET evr.csv') # FALSE

# Does the current working directory exist?
dir.exists(getwd()) # TRUE

# Combining conditions ----------------------------------------------------
# There are many situations where you want multiple conditions to be met, or
# not. Those are achieved with a few more operators, some of which we've seen
# before:
#     &   "And"
#     |   "Or"

# Is either "cat" the same as "cat", or "dog" the same as "cat"?
("cat" == "cat") | ("cat" == "dog") # TRUE (Also possible without parenthases)

# Is "cat" the same as "cat", and "dog" the same as "cat"?
"cat" == "cat" & "cat" == "dog" # FALSE

# Basic conditional statements --------------------------------------------

# A conditional statment is a simple way to have R execute an action depending
# on the outcome of a logical statement. We're only going to introduce "if" and
# "if, else" statements for this tutorial, but there are a few others.

# Let's say we want to have R tell us if a vector contains a specific number. Begin
# by defining your vector and number of interest:

# Define a short vector
vec = c(22,31,21,1,30,45,4444,42,3,29,2387,14,49,30,397)

# Define a value of interest
val = 42

# Set up the "if statement". This can be read: "If [val] is within [vec], then send a message"
if(val %in% vec){
  
  message(val, ' is in the vector :)')
  
}
# Note the syntax here, or the way this statement is written. The condition is
# written within the () following if, and the action occurs within {}

# Now, what if you want to print a message if the vector has the number, or does
# not. That's easy with an "if else" statement:
if(val %in% vec){
  message(val, ' is in the vector :)')
} else {
  message(val, ' is NOT in the vector :(')
}
# Play around with the value of 'val', and watch the printed message change. Fun fun!

# As a last step, what if we want a heirarchy of conditions? For example, we
# prefer the value of [val], but if it's not there, we'd like to know if it was
# larger than the mean value in the vector That might be achieved this way:

# First, define the mean value of the vector
mean_vec = mean(vec)

# Then set up the conditional statement, this time with an extra 'if' statement
if(val %in% vec){
  message(val, ' is in the vector :)')
} else if(val > mean_vec){
  message(val, ' is not in the vector, but larger than ', mean_vec, ', the mean value of the vector :|')
} else {
  message(val, ' is not in the vector, and less than or equal to ', mean_vec, ', the mean of the vector :(')
}

# Basic for loop ----------------------------------------------------------

# A FOR LOOP is a way to iteratively loop through a section of code and make a
# slight change each time. This works by assigning a variable, usually called
# 'i', whose value changes with each iteration of the loop. You must supply a
# vector of values that 'i' will loop through and be assigned to. Usually this
# is a simple sequence. Here are a few examples of how they might be defined.

7:47 # Linear sequence from 7 to 47
1:length(vec) # Linear sequence from 1 to the length of vec
seq(from = 21, to = 2014, by = 450) # Sequence from 21 to 2014 by 450
seq(from = 21, by = 450, length.out = 14) # Sequence of 14 values from 21 by 450
seq_along(vec) # this is a convenient function for doing the same thing as 1:15

for(i in 1:length(vec)){
  
  # define temporary variable
  ivec = vec[i]
  
  if(i==1){
    message("The ", i, "st value in the vector is: ", ivec)  
  } else if(i == 2){
    message("The ", i, "nd value in the vector is: ", ivec)  
  } else if(i == 3){
    message("The ", i, "rd value in the vector is: ", ivec)  
  } else {
    message("The ", i, "th value in the vector is: ", ivec)  
  }
  
}

# Here's an example for how to store output from a loop

# best practice is to initialize a vector that will be populated by a loop
out = rep(NA, length(vec))
# loop
for(i in 1:(length(vec)-1)){
  
  # define temporary variable
  out[i] = vec[i]+vec[i+1]
  
}

# Basic custom function ---------------------------------------------------
# Here I'll just show a few examples of how to make custom functions. 

# In this syntax, 'in_vector' is the name of the function, and 'myval' and
# 'myvec' are arguments. The curly brackets denote the beginning and end of the
# function

# Define the function
in_vector = function(myval,myvec){
  
  # calculate mean of vector
  mean_myvec = mean(myvec)
  
  # print message
  if(myval %in% myvec){
    message(myval, ' is in the vector :)')
  } else if(myval > mean_myvec){
    message(myval, ' is not in the vector, but larger than ', mean_myvec, ', the mean value of the vector :|')
  } else {
    message(myval, ' is not in the vector, and less than or equal to ', mean_myvec, ', the mean of the vector :(')
  }
  
}

# Test it!
in_vector(myval = 503, myvec = vec)
in_vector(myval = 1000000, myvec = c(23,42,11111,17))

# Define the same function, but this time set default values using =
in_vector2 = function(myval = 17, myvec = vec){
  
  # calculate mean of vector
  mean_myvec = mean(myvec)
  
  # print message
  if(myval %in% myvec){
    message(myval, ' is in the vector :)')
  } else if(myval > mean_myvec){
    message(myval, ' is not in the vector, but larger than ', mean_myvec, ', the mean value of the vector :|')
  } else {
    message(myval, ' is not in the vector, and less than or equal to ', mean_myvec, ', the mean of the vector :(')
  }
  
}

# Test it!
in_vector2() # Default values are used when you don't specify inputs
# in_vector() # Note the error if you try this with the original function
in_vector2(myval = 32)
