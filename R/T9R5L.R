# Author: Juan Galeano
# TR: TODO: if abridged data give, group to 5. Remove ns arg. make util for ns stuff.
# handle OAG with care.
###############################################################################

#' Feeney'S formula on 9 years to correct for heaping on multiples of 5.

#' @description  Fenney's technique for correcting age distributions for heaping on multiples of five.
 
#' @param Value numeric. A vector of demographic counts in single age groups.
#' @param Age numeric or character. A vector with ages in single years.
#' @param ns numeric. Cases of unknown (not-stated) age. By default this is equal to 0.
#' @param maxit integer. Maximum number of iterations.

#' @details Value is assumed to be in single ages. The last element of Value is assumed to be the open age group, and it is assumed that this age is evenly divisible by 5.

#' @return a dataframe with 4 columns: 
#' \itemize{
#'   \item Age 
#'   \item Age Interval character 5, except open age group and unstated ages.
#'   \item recorded numeric original data grouped to 5-year ages.
#'   \item corrected numeric adjusted data in 5-year age groups.
#' } 
#' 
#' @export
#' @references 
#' \insertRef{feeney1979}{DemoTools}

#' @examples 
#' # data from feeney1979, Table 1, page 12: Population of Indonesia, 22 provinces, 
#' # by single year of age: Census of 24 September 1971.
#'  Pop <- c(2337,3873,3882,3952,4056,3685,3687,3683,3611,3175,
#'          3457,2379,3023,2375,2316,2586,2014,2123,2584,1475,
#'          3006,1299,1236,1052,992,3550,1334,1314,1337,942,
#'          3951,1128,1108,727,610,3919,1221,868,979,637,
#'          3409,887,687,533,313,2488,677,426,524,333,
#'          2259,551,363,290,226,1153,379,217,223,152,
#'          1500,319,175,143,89,670,149,96,97,69,
#'          696,170,60,38,23,745)
#'  Ages <- c(0:75)
#'  result <- T9R5L(Pop, Ages, ns = 15)
#' 
#'  \dontrun{
#'  plot(Ages, Pop, type= 'l')
#'  segments(result$Age,
#' 		 result$recorded/5,
#' 		 result$Age+5,
#' 		 result$recorded/5,
#' 		 col = "blue")
#'  segments(result$Age,
#' 		 result$corrected/5,
#' 		 result$Age+5,
#' 		 result$corrected/5,
#' 		 col = "red")
#'  legend("topright",col=c("black","blue","red"),
#'    lty=c(1,1,1),
#'    legend=c("recorded 1","recorded 5","corrected 5"))
#' }

T9R5L <- function(Value, Age, ns = 0, maxit = 100){
  
	# internal function used iteratively
	f_adjust <- function(A,B){
		N       <- length(B)
		Bup     <- c(1, shift.vector(B, -1, fill = 0) + B)[1:N]
		FC      <- (8 / 9) * ((A + Bup) / Bup)
		FC[1]   <- 1
		POB1    <- c(A - (FC - 1) * Bup)
		POB2    <- (c(c(shift.vector(FC, -1, fill = 0) + FC)[-N],
							(FC[N] + 1)) - 1 ) * B
		# return a list of 3 components	
		aj       <- list(FC, POB1, POB2)
		aj
	}
	
	N            <- length(Value)
	ages_implied <- seq_along(Value) - 1
	last_age     <- ages_implied[N]
	a5           <- ages_implied - ages_implied %% 5
    OAG          <- Value[N]
	
	# TR: no function requried for this stuff
	Px     <- Value[seq(1, N, 5)]
	# assuming final value is open age group
	Pxp    <- Px[ -length(Px)]
	P5     <- c(tapply(Value, a5, sum))
	# assuming final value is open age group
	P5     <- P5[-length(P5)]
	# i.e. the value of pop in age groups excluding single ages divisible by 5
	Px4    <- P5 - Pxp
	
	n      <- length(P5)

  # adjustment loop
  for (i in 1:maxit) {
	adjust <- f_adjust(A = Pxp, B = Px4)
    Pxp    <- adjust[[2]] 
	Px4    <- adjust[[3]] 
	if (all(abs(adjust[[1]]) < 1e-8)){
		break
	}
  }
  
  G      <- (Pxp * .6)[c(2:(n - 1))]
  H      <- (Pxp * .4)[c(3:n)]
  I      <- G + H #f(x+2.5)
  
  # corrected, but unknowns still need to be redistributed
  Pxp5   <- c(P5[1], I * 5, P5[n], OAG) 
	 
  # redistribute unknown ages
  Px5    <- Pxp5 * (sum(Value) + ns) / sum(Pxp5)
  
  # get lower bound to age groups
  a      <- 0:(N - 1)
  lower  <- a[a %% 5 == 0]
  
  # return data.frame of before/after in 5-year age groups.
  out    <- data.frame(Age = c(lower,
									NA),
						  AgeInterval = c(rep(5, length(lower)-1),"+","NA"),
                          recorded = c(P5, OAG, ns),
                          corrected = c(Px5, NA))
  out
}
