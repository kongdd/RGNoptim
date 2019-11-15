#include <R.h>
#include <Rinternals.h>
#include <time.h>
#include <stdio.h>

// #include <stdlib.h> // for NULL
// #include <R_ext/BLAS.h>
// #include <R_ext/Print.h>

SEXP obj, obj_multi, rho;

void init_param(SEXP obj_, SEXP obj_multi_, SEXP rho_) {
    obj       = obj_;
    obj_multi = obj_multi_;
    rho       = rho_;
}

extern void objfunc_(int nPar, int nSim, double * x, double * r, double f, 
    double timeFunc, int error, char * message) 
{
    clock_t start, end;
    start = clock();

    SEXP dot_par_symbol = install(".par");
    SEXP xpt = findVarInFrame(rho, dot_par_symbol);
    defineVar(dot_par_symbol, duplicate(xpt), rho);

    f = asReal(eval(obj      , rho));
    r = (double *)(eval(obj_multi, rho));
    
    // printf("debug\n");
    end = clock();
    timeFunc = ((double) (end - start)) / CLOCKS_PER_SEC;
}

// extern void RGNoptim_c(SEXP obj_, SEXP obj_multi_, SEXP rho_, 
//     int nPar, int nSim, 
//     double * x0, double * xLo, double * xHi, 
//     double * x , double f,
//     double timeFunc, int convcode) 
// {
//     init_param(obj_, obj_multi_, rho_);
//     rgnoptim_(objFunc_C, nPar, nSim, x0, xLo, xHi,
//       x, f, timeFunc, convcode);
// }
