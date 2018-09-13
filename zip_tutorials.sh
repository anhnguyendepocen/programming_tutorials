#!/bin/bash
# Zip R tutorials for upload to GitHub

# Define main tutorial directory
MAINDIR='/Users/hansenjohnson/Projects/programming_tutorials/R'

# Move to main directory
cd $MAINDIR

# Zip tutorial, recursively excluding all hidden files (loop later)
zip -r tutorial_01.zip tutorial_01/ -x "*/\.*"
