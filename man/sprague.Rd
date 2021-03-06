% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Sprague.R
\name{sprague}
\alias{sprague}
\title{The basic Sprague age-splitting method.}
\usage{
sprague(popmat, Age = as.integer(rownames(as.matrix(popmat))),
  OAG = TRUE)
}
\arguments{
\item{popmat}{numeric. A matrix of population counts in 5-year age groups with integer-labeled 
margins (age in rows and year in columns).}

\item{Age}{integer. Vector of lower age bound of age groups. Detected from row names of \code{popmat} if missing.}

\item{OAG}{logical. Whether or not the final age group open. Default \code{TRUE}.}
}
\value{
An age-period matrix of split population counts with the same number of 
columns as \code{popmat}, and single ages in rows.
}
\description{
This method is used to interpolate counts based on the Sprague formula. It is based on the first stage of the Sprague R 
script prepared by Thomas Buettner and Patrick Gerland, itself based on the description
in Siegel and Swanson, 2004, p. 727.
}
\details{
Ages should refer to lower age bounds, ending in the open age group in the last row (not a closed terminal age). Dimension labelling is necessary. There must be at least six age groups (including the open group). One year of data will work as well, as long as it's given as or coercible to a single-column matrix. This method may produce negative values, most likely in the youngest or oldest ages.

If the highest age does not end in a 0 or 5, and \code{OAG == TRUE}, then the open age will be grouped down to the next 
highest age ending in 0 or 5. If the highest age does not end in a 0 or 5, and \code{OAG == FALSE}, then results extend
to single ages covering the entire 5-year age group.
}
\examples{
head(pop5_mat) # this is the entire matrix
# the last value is an open age group, preserve as such:
p1 <- sprague(pop5_mat, OAG = TRUE)
head(p1); tail(p1)
colSums(p1) - colSums(pop5_mat) 

# another case, starting with single ages
Age         <- 0:100
# notice how this particular case produces a negative value in the last age
# before OAG:
pops <- sprague(popmat = pop1m_ind, Age = Age, OAG = TRUE)

\dontrun{
yrs <- as.character(1950:1954)
matplot(0:100,p1, type = 'l', col = 5:9,lty = 1,xlab = 'Age',ylab = 'Counts',
main= 'Ungrouped counts')
legend('topright',
title = 'Year',
lty=1,
col=5:9,
legend = yrs
)
}
}
\references{
\insertRef{sprague1880explanation}{DemoTools}
\insertRef{shryock1973methods}{DemoTools}
\insertRef{siegel2004methods}{DemoTools}
}
