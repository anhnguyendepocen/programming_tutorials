## installation ##
# Script to install required packages for rmarkdown
# Adapted from: https://bookdown.org/yihui/rmarkdown/installation.html

# required ----------------------------------------------------------------

# install rmarkdown from CRAN repository
install.packages('rmarkdown')

# optional ----------------------------------------------------------------

# install latex for rendering PDF documents
install.packages("tinytex")

# install TinyTeX (this will fail if you have LaTeX already)
tinytex::install_tinytex()  