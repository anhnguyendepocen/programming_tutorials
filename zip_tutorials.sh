#!/bin/bash
# Zip R tutorials for upload to GitHub

# Define tutorial directory (iterate through all dirs later)
PROJDIR='/Users/hansenjohnson/Projects/programming_tutorials/R/tutorial_01'

# Zip tutorial, recursively excluding all hidden files
zip -r "$PROJDIR.zip" $PROJDIR -x "*/\.*"
