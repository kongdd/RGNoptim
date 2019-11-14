#include <R.h>
#include <Rinternals.h>

// #include <stdlib.h> // for NULL
// #include <R_ext/BLAS.h>
// #include <R_ext/Print.h>

extern void objFunc(SEXP fn, SEXP rho, int nPar, int nSim, double * x, double * r, 
    double f, 
    double timeFunc, int error, char * message) {

    f = asReal(eval(fn, rho));
}
