FUNCTION tprimepdf( x, q, a1, TOL, MAXITER, ier )
    !-----------------------------------------------------------------------
    !     Calculates the density that a random variable distributed
    !     according to the t' distribution with Q degrees of
    !     freedom, A1 centrality parameter, is equal to X
    !
    !     P       - Input . p value of the desired quantile (0<P<1) - Real
    !     Q       - Input . Degrees of freedom              (Q > 0) - Real
    !     A1      - Input . Eccentricity parameter                  - Real
    !     TOL     - Input . Maximum absolute error required on      - Real
    !                     kprimecdf (stopping criteria)
    !                     (eps < TOL < 1 where eps is machine
    !                     epsilon; see parameter statement below)
    !     MAXITER - Input . Maximum number of iterations            - Integer
    !     IER     - Output. unreturned...                           - Integer
    !
    !     External functions called:
    !       LPRIMECDF
    !     Fortran functions called:
    !       ABS    MAX
    !
    !*********************************************************************************************!
    !**                                                                                         **!
    !** This function was added by Denis Cousineau, 28 november 2020.                           **!
    !** It is just a wrapper to the generic function dfridr from Numerical Reciepes.            **!
    !**                                                                                         **!
    !*********************************************************************************************!

    IMPLICIT NONE
    INTEGER, PARAMETER        :: PR=KIND(1.0D0)

    !  Function
    !  --------
    REAL(PR) :: tprimepdf

    !  Arguments
    !  ---------
    REAL(PR),     INTENT(in)  :: x, q, a1, TOL
    INTEGER,      INTENT(in)  :: MAXITER
    REAL(PR),     INTENT(out) :: ier

    !  Local declarations
    !  ------------------
    REAL(PR), EXTERNAL  :: tprimecdf

    ier = 0
    tprimepdf = dfridr( func, x, 0.1D0, ier )

CONTAINS

    FUNCTION func( x )
        real(PR), intent(in) :: x
        real(PR), external   :: tprimecdf
        real(PR)  :: func
        integer       :: iok
        iok = 0
        func = tprimecdf(x, q, a1, TOL, MAXITER, iok)
    END FUNCTION func

    FUNCTION dfridr(func, x, h, rer )
        ! Reference: Press, Teukolsky, Vetterling, Flannery (1992) Numerical Receipes in fortran 77 (vol. 1)
        real(PR)              :: dfridr
        real(PR), external    :: func
        real(PR), intent(in)  :: x, h
        real(PR), intent(out) :: rer
        real(PR), parameter   :: CON=1.4D0, CON2=1.96D0, BIG=1.0D30, SAFE=2.0D0
        integer,      parameter   :: NTAB=10
        integer                   :: i, j
        real(PR)              :: errt, fac, hh, a(NTAB,NTAB)
        ! Returns the derivative of a function func at a point x by Ridders� method of polynomial
        ! extrapolation. The value h is input as an estimated initial stepsize; it need not be small,
        ! but rather should be an increment in x over which func changes substantially. An estimate
        ! of the error in the derivative is returned as err.
        ! Parameters: Stepsize is decreased by CON at each iteration. Max size of tableau is set by
        ! NTAB. Return when error is SAFE worse than the best so far.
        if (h .eq. 0.) then
            dfridr = -10.0D0
        end if

        hh = h
        a(1,1) = (func(x+hh) - func(x-hh)) / (2.0*hh)
        rer = BIG

        do i = 2,NTAB !Successive columns in the Neville tableau will go to smaller stepsizes and higher orders of extrapolation. 
            hh = hh / CON
            a(1,i) = (func(x+hh)-func(x-hh)) / (2.0*hh) !Try new, smaller stepsize.
            fac = CON2
            do j = 2,i !Compute extrapolations of various orders, requiring no new function evaluations.
                a(j,i) = (a(j-1,i)*fac-a(j-1,i-1)) / (fac-1.)
                fac = CON2*fac
                errt = max(abs(a(j,i)-a(j-1,i)),abs(a(j,i)-a(j-1,i-1)))
                ! The error strategy is to compare each new extrapolation to one order lower, both at
                ! the present stepsize and the previous one.
                if (errt .le. rer) then !If error is decreased, save the improved answer.
                    rer = errt
                    dfridr = a(j,i)
                end if
            end do

            ! If higher order is worse by a significant factor SAFE, then quit early.
            if (abs(a(i,i)-a(i-1,i-1)) .ge. SAFE * rer) then
                return
            end if 
        end do
        return
    END FUNCTION dfridr

END FUNCTION tprimepdf



