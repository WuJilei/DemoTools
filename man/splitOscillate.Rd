% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Sprague.R
\name{splitOscillate}
\alias{splitOscillate}
\title{An oscillatory average of age splits.}
\usage{
splitOscillate(Value, Age = 1:length(Value) - 1, OAG = TRUE,
  splitfun = sprague, closeout = "mono", pivotAge = 90, ...)
}
\arguments{
\item{Value}{numeric. Vector of single age counts.}

\item{Age}{integer. Vector of single ages.}

\item{OAG}{logical. Whether or not the last value is the open age group. Default \code{TRUE}.}

\item{splitfun}{function used to split at each digit grouping. Default \code{sprague()}.}

\item{closeout}{logical or character. Default \code{"mono"}.}

\item{pivotAge}{integer. Age to start blending in closeout values.}

\item{...}{optional arguments passed to \code{splitfun()}.}
}
\value{
Numeric vector of smoothed counts.
}
\description{
Single ages can be grouped into 5-year age groups in 5 ways by staggering terminal digits.
This method is a bit smoother than the standard Sprague or Beers methods, but not as smooth as \code{grabill()}.
}
\details{
This function works on a single vector of single-age counts, not on a matrix. Results are not
constrained to any particular age group, but are constrained to the total count. Negatives, \code{NA}, or \code{NaN} 
values are ignored in averaging. This can happen in older ages . It is recommended to run \code{monoCloseout()} or 
similar after the oscillatory split in such situations.
}
\examples{
# code currently breaking, needs to be revisited and updates completed, sorry
\dontrun{

Value <- structure(pop1m_ind, .Names = 0:100)
#barplot(Value, main = "yup, these have heaping!")
# this is the basic case we compare with:
pop0    <- sprague(groupAges(Value),  OAG = TRUE)
# note: this function needs single ages to work because
# ages are grouped into 5-year age groups in 5 different ways.
# breaks
#pop1    <- splitOscillate(Value, OAG = TRUE, splitfun = sprague)
pop2    <- splitOscillate(Value, OAG = TRUE, splitfun = beers)
# what's smoother, splitOscillate() or grabill()?
# note, same closeout problem, can be handled by monoCloseout()
pop3    <- grabill(Value, OAG = TRUE)
# and technically you could give grabill as splitfun too
pop4   <- splitOscillate(Value, OAG = TRUE, splitfun = grabill)

Age <- 0:100
plot(Age, Value)
lines(Age, pop0, col = "blue")
# slightly smoother (also shifted though)
lines(Age, pop1)
# only different at very high ages, small nrs
lines(Age, pop2, col = "red", lty = 2, lwd = 2) 
lines(Age, pop3, col = "magenta")
lines(Age, pop4, col = "orange", lty = 2)
legend("topright", 
lty = c(1,1,2,1,2), 
lwd = c(1,1,2,1,1), 
col = c("blue","black","red","magenta","orange"),
		legend = c("sprague()",
                "splitOscillate(splitfun = sprague)", 
				   "splitOscillate(splitfun = beers)",
				   "grabill()",
                "splitOscillate(splitfun = grabill)"))

# index of dissimilarity
ID(Value, pop0) # original vs sprague
ID(pop0,pop1) # sprague vs sprague osc
ID(pop1,pop2) # sprague osc vs beers osc
ID(pop2,pop3) # beers osc vs grabill
ID(pop3,pop4) # grabill vs grabill osc
# measre of smoothness:
mean(abs(diff(Value)))
mean(abs(diff(pop0)))
mean(abs(diff(pop1)))
mean(abs(diff(pop2)))
mean(abs(diff(pop3)))
mean(abs(diff(pop4)))
}
}
\references{
\insertRef{booth2015demographic}{DemoTools}
}
