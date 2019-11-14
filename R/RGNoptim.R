#' Robust Gauss-Newton Algorithm
#'
#' @examples
#' x = c(0, 0)
#' RGNoptim2(x, func_obj, func_res)
#' @export
RGNoptim2 <- function(x = c(0, 0), objective, residual, lower = NULL, upper = NULL, ...)
{
    f = 0
    r = residual(x, ...)
    nPar = length(x)
    nSim = length(r)
    # nPar, nSim, as.double(x), as.double(r), f,
    if (is.null(lower)) lower = rep(-Inf, nPar)
    if (is.null(upper)) upper = rep( Inf, nPar)

    par       <- setNames(as.double(x), names(x))
    obj       <- quote(objective(.par, ...))
    obj_multi <- quote(residual(.par, ...))

    rho       <- new.env(parent = environment())
    assign(".par", par, envir = rho)

    timeFunc = 0.0
    convcode = 0L

    x  = as.double(x)
    x0 = x

    .Call("init_param", obj, obj_multi, rho)
    browser()

    r <- .Fortran("RGNoptim",
        nPar, nSim,
        x0, as.double(lower), as.double(upper),
        x, as.double(f), as.double(r),
        timeFunc, convcode)
    r
}
# tools::package_native_routine_registration_skeleton(".")

# objective function
func_obj <- function(x) {
    x1 <- x[1]
    x2 <- x[2]
    5 * (x2 - x1 * x1)^2 + (1 - x1)^2
}

# residual function
func_res <- function(x) {
    x1 <- x[1]
    x2 <- x[2]

    c(1 - x[1], 10 * (x2 - x1 * x1)^2)
}
