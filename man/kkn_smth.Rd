% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AGESMTH.R
\name{kkn_smth}
\alias{kkn_smth}
\title{Karup-King-Newton method of population count smoothing}
\usage{
kkn_smth(Value, Age, OAG = TRUE)
}
\arguments{
\item{Value}{numeric vector of counts in single, abridged, or 5-year age groups.}

\item{Age}{numeric vector of ages corresponding to the lower integer bound of the counts.}

\item{OAG}{logical. Whether or not the top age group is open. Default \code{TRUE}.}
}
\value{
numeric vector of smoothed counts in 5-year age groups.
}
\description{
Smooth population counts in 5-year age groups.
}
\details{
This method does not account for ages < 10 nor for the 10 year age 
interval prior to the open age group. These are returned imputed with \code{NA}.
Age classes must be cleanly groupable to 5-year age groups.
}
\examples{
# from PASEX AGESMTH
MalePop      <- c(642367, 515520, 357831, 275542, 268336, 278601, 242515, 
		198231, 165937, 122756, 96775, 59307, 63467, 32377, 29796, 16183, 34729)
Ages         <- seq(0, 80, by = 5)
KKNtest <- c(NA,NA,354871,278502,285508,261429,236513 ,
		204233,162138,126555,90094,65988,54803,41041,NA,NA,NA)

KKNmales <- kkn_smth(MalePop, Ages, TRUE)
all(round(KKNmales) - KKNtest == 0, na.rm = TRUE)
\dontrun{
plot(Ages, MalePop)
lines(as.integer(names(KKNmales)),KKNmales)
}
}
\references{
Carrier, Norman H., and A. M. Farrag. "The reduction of errors 
in census populations for statistically underdeveloped countries." 
Population Studies 12.3 (1959): 240-285.
}
