func_timeToSec <- function(time) {
  
  t <- strsplit(as.character(time), " |:")[[1]]
  seconds <- NaN
  
  if (length(t) == 1 )
    seconds <- as.numeric(t[1])
  else if (length(t) == 2)
    seconds <- as.numeric(t[1]) * 60 + as.numeric(t[2])
  else if (length(t) == 3)
    seconds <- (as.numeric(t[1]) * 60 * 60 
                + as.numeric(t[2]) * 60 + as.numeric(t[3]))   
  else if (length(t) == 4)
    seconds <- (as.numeric(t[1]) * 24 * 60 * 60 +
                  as.numeric(t[2]) * 60 * 60  + as.numeric(t[3]) * 60 +
                  as.numeric(t[4]))
  
  return(seconds)
}