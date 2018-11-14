""" Python Tutorial 04: for-Loops and Custom Functions

Follow along at: https://christophrenkl.github.io/programming_tutorials/

Author: Christoph Renkl (christoph.renkl@dal.ca)

In this tutorial, we will also introduce for-loops and learn how to writ your 
own functions. If you spot any mistakes or issues, please report them to
christoph.renkl@dal.ca.
"""

#%% for-Loops

# You may face a situation where you want to apply the same operation or
# analysis to multiple elements in an array or different variables. It is good
# practice to write your code in a flexible way and without repetition. This is
# where for-loops become useful because they allow you to iteratively run
# through a section of code. A for-loop is characterized by an iterator which
# changes its values each time you execute the code within the loop. An
# iterator can be just a sequence of numbers, but you can also iterate through
# items of lists, arrays, and even rows of pandas DataFrames.
# 
# Let's first define a list
lst = ['dog', 'cat', 'mouse', 'elefant', 'tiger', 'snake', 'squirrel']

# Now we loop through the list and print out each item individually
for ii in range(len(lst)):
    print('The item with index {} is {}'.format(ii, lst[ii]))
    
# Here, ii is the iterator which changes value every time we run through the
# loop. The values of ii are determined by the function range() which creates a
# sequence with length eqaual to that integer argument provided. In this
# example we use the len() function to determine the length of lst to create a
# sequence of equal length.
    
# Note the indentation - the indented block is the sequence of code that is
# executed for each iterator.

# If you are only interested in the values, but not the index of the list, you
# can loop through the list itself and the iterator takes on the value each
# item
for item in lst:
    print('The item is {}'.format(item))
    
# You can rewrite the first for-loop using the enumerate() function. This
# returns both the index and the value of an item:
for ii, item in enumerate(lst):
    print('The item with index {} is {}'.format(ii, item))

# Lists can also be modified through list comprehension which is basically a
# for-loop in one line enclosed by backets. This example adds the string 'a' to
# each item in the list.
['a '+item for item in lst]

#%% Custom Functions

# If you want to reuse your code in other scripts you should write your own
# functions rather than copying code snipppets back and forth. Here are a few
# examples how to write custom functions.

# Define a function
def in_list(lst, val):
    '''A function to check if val is an item in lst'''
    
    # if-statement to check the existance of val in lst
    if val in lst:
        
        # Find index of val in list
        idx = lst.index(val)
        
        # prepare answer 
        answer = 'Yes, {0} has index {1} in the list.'.format(val, idx)
        
    else:
        
        # prepare answer 
        answer = 'No, {} is not in the list.'.format(val)

    # return the answer to script
    return answer

# test the function
ans = in_list(lst, 'cat')
print(ans)

ans = in_list(lst, 'porcupine')
print(ans)

# Same function with default argument
def in_list2(lst, val='mouse'):
    '''A function to check if val is an item in lst'''
    
    # if-statement to check the existance of val in lst
    if val in lst:
        
        # Find index of val in list
        idx = lst.index(val)
        
        # prepare answer 
        answer = 'Yes, {0} has index {1} in the list.'.format(val, idx)
        
    else:
        
        # prepare answer 
        answer = 'No, {} is not in the list.'.format(val)

    # return the answer to script
    return answer

# test it
ans = in_list2(lst)
print(ans)

ans = in_list2(lst, 'zebra')
print(ans)




