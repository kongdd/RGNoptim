#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP init_param(SEXP, SEXP, SEXP);

/* .Fortran calls */
extern void F77_NAME(rgnoptim)(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);

static const R_CallMethodDef CallEntries[] = {
    {"init_param", (DL_FUNC) &init_param, 3},
    {NULL, NULL, 0}
};

static const R_FortranMethodDef FortranEntries[] = {
    {"rgnoptim", (DL_FUNC) &F77_NAME(rgnoptim), 10},
    {NULL, NULL, 0}
};

void R_init_RGNoptim(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, FortranEntries, NULL);
    R_useDynamicSymbols(dll, FALSE);
}

