
#' @export
RGNoptim <- function(x = c(0, 0), f = 0){
    r <- .Fortran("RGNoptim", as.double(x), as.double(f))
    r
}
