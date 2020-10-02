#---------------------------------------------------------------------------
# factor_to_numeric_icpsr.R
# 2012/12/06
#
# Convert R factor variable back to numeric in an ICPSR-produced R data
# frame. This works because the original numeric codes were prepended by
# ICSPR to the factor levels in the process of converting the original
# numeric categorical variable to factor during R data frame generation.
#
# REQUIRES add.value.labels function from prettyR package
#    http://cran.r-project.org/web/packages/prettyR/index.html
#
#
# Substitute the actual variable and data frame names for da99999.0001$MYVAR
# placeholders in syntax below.
#
#    data frame = da99999.0001
#    variable   = MYVAR
#
#
# Line-by-line comments:
#
# (1) Load prettyR package
#
# (2) Create object (lbls) containing the factor levels for the specified
#     variable.  Sort will be numeric as original codes (zero-padded, if
#     necessary) were preserved in the factor levels.
#
# (3) Strip original codes from lbls, leaving only the value labels, e.g.,
#       "(01) STRONGLY DISAGREE" becomes "STRONGLY DISAGREE"
#
# (4) Strip labels from data, leaving only the original codes, e.g.,
#       "(01) STRONGLY DISAGREE" becomes "1"
#
#     Then, coerce variable to numeric
#
# (5) Add value labels, making this a named numeric vector
#---------------------------------------------------------------------------

library(prettyR)
# lbls <- sort(levels(da37441.0001$FEML))
# lbls <- (sub("^\\([0-9]+\\) +(.+$)", "\\1", lbls))
# da37441.0001$MYVAR <- as.numeric(sub("^\\(0*([0-9]+)\\).+$", "\\1", da37441.0001$FEML))
# da37441.0001$MYVAR <- add.value.labels(da37441.0001$FEML, lbls)

#---------------------------------------------------------------------------
# Sarah's super code to get values from this mess

# Load da37441.0001 fromr.rda file
x <- da37441.0001

# Subset to California
ca <- x[x$STATE == "CA",]
head(ca)
cat <- data.frame(t(ca)) # Transpose
colnames(cat) <- c("Value")

# Which variables have actual values:
na_rows <- as.numeric(which(is.na(cat$Value)==TRUE))
cat_sub <- data.frame(cat[-na_rows,])
colnames(cat_sub) <- c("Value")
vars <- rownames(cat_sub)
rownames(cat_sub) <- NULL 
cat_sub <- cbind(vars, cat_sub)
print(Cat_sub)
# Variable descriptions at: https://www.icpsr.umich.edu/web/NACJD/series/328/variables
