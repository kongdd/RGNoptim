SUBROUTINE RGNoptim(nPar, nSim, x0, xLo, xHi, x, f, timeFunc, convcode) !bind(c, name="rgnoptim_")
! Purpose: Calibrate 2D Rosenbrock function with Robust Gauss-Newton Algorithm (RGN)
! ---
! Programmer: Youwei Qin, Dmitri Kavetski, Michael Leonard
! Created: July 2018 AD, Hohai University, China.
! Last modified: October 2018 AD, Hohai University, China
! Copyright, Youwei Qin, Dmitri Kavetski, Michael Leonard, 2018-2023. All rights reserved.
! ---
! This is the demo for calibrating Rosenbrock function with RGN
! The core of RGN is recorded in rgn.f90
! The data exchange between RGN and Rosenbrock function is through "objFunc"
! and the sum of least squares objective function value is evaluated and returned to RGN subroutine.
! The public variables were shared through subroutine "constantsMod.f90"
!******************************************************************
   USE rgnMod
   USE constantsMod
   IMPLICIT NONE
   
   EXTERNAL objFunc

   INTEGER(ik), intent(in) :: nPar, nSim
   REAL(rk)                :: x0(nPar), xLo(nPar), xHi(nPar)
   REAL(rk)   , intent(out):: x(nPar), f, timeFunc
   INTEGER(ik), intent(out):: convcode
   CHARACTER(256)          :: message 
   
   TYPE (rgnConvType)      :: cnv
   TYPE (rgnInfoType)      :: info
   ! CHARACTER(20) :: dfm1

   ! INTERFACE
   !    SUBROUTINE objFunc (nPar, nSim, x, r, f, timeFunc, error, message) bind(C)
   !       use iso_c_binding,   only: &
   !           c_short, c_int, c_long, c_float, c_double, c_char
   !       ! USE constantsMod, ONLY: ik, rk
   !       IMPLICIT NONE
   !       integer(c_int), INTENT(in)    :: nPar
   !       integer(c_int), INTENT(in)    :: nSim
   !       REAL(c_double), INTENT(in)    :: x(:)
   !       REAL(c_double), INTENT(out)   :: r(:)
   !       REAL(c_double), INTENT(out)   :: f
   !       REAL(c_double), INTENT(out)   :: timeFunc   
   !       INTEGER(c_int), INTENT(inout) :: error
   !       CHARACTER(len=100,kind=c_char),INTENT(inout) :: message
   !       INTEGER(c_int)::status
   !    END SUBROUTINE objFunc
   ! END INTERFACE
   !----
   !Write out the message what is running
   ! WRITE(*,'(a)') " Calibrating Rosenbrock with RGN, approximate running time 1-2 seconds"
   ! WRITE(*,*)
   !
   ! convcode=0                                           ! Initialize convcode flag
   ! message=""                                           ! Initialize message
   ! x0 = [-1.0_rk, 0.0_rk]                               ! Start point of the search, with the optimum at [1.0 1.0]
   ! xLo = [-1.5_rk, -1.0_rk]                             ! Low bound
   ! xhi = [ 1.5_rk,  3.0_rk]                             ! Upper bound

   !Give the format
   ! WRITE(dfm1,'(a,i4,a)')     '(a,', 2,'g15.7)'
   CALL setDefaultRgnConvergeSettings (cnvSet=cnv, dump=10_ik, fail=0_ik)
   ! key input parameters: nPar is the number of parameters to be optimized
   !                       nSim is the number of residuals
   CALL rgn (objFunc=objFunc, p=nPar, n=nSim, x0=x0, xLo=xlo, xHi=xHi, cnv=cnv, &
      x=x, info=info, error=convcode, message=message)
   IF(convcode /= 0)then
     WRITE(*,*) message
     READ(*,*)
   END IF

   f = info%f
   ! WRITE(*,dfm1)                "Best parameter set:      ", x
   ! WRITE(*,'(a,g15.7)')         "Best objfunc value:      ", info%f
   ! WRITE(*,'(a,4x,i0)')         "Number of objfunc calls: ", info%nEval
   ! WRITE(*,'(a,4x,i0)')         "Total iteration:         ", info%nIter
   ! WRITE(*,'(a,4x,i0)')         "Termination flag:        ", info%termFlag
   ! WRITE(*,'(a,g15.7)')         "CPU time:                ", info%cpuTime
END SUBROUTINE RGNoptim


! SUBROUTINE objFunc (nPar, nSim, x, r, f, timeFunc, convcode, message) 
!    USE constantsMod, ONLY: ik, rk
!    IMPLICIT NONE
!    INTEGER(ik), INTENT(in)   :: nPar
!    INTEGER(ik),INTENT(in)    :: nSim
!    REAL(rk), INTENT(in)      :: x(:)
!    REAL(rk), INTENT(out)     :: r(:)
!    REAL(rk), INTENT(out)     :: f
!    REAL(rk),INTENT(out)      :: timeFunc
!    INTEGER(ik), INTENT(inout):: convcode
!    CHARACTER(*),INTENT(inout):: message
!    INTEGER(ik) :: i
!    !---
!    !
!    !time for evaluating
!    REAL(rk)::timeObj(2)
!    CALL CPU_TIME (timeObj(1))
!    f = 0.0_rk
!    r(1) = 1.0_rk - x(1)
!    r(2) = 10.0_rk*(x(2) - x(1)**2) ! Compute residual, 子目标函数
!    f = f + r(1)**2 + r(2)**2       ! Calculate objective function， 总目标函数
!    f = f/2.0_rk
!    CALL CPU_TIME (timeObj(2))
!    timeFunc=timeObj(2)-timeObj(1)
! END SUBROUTINE objFunc
