!-----------------------------------------------------------------------
      program test
      implicit none
      include 'ceed/fortran.h'

      integer ceed,err
      integer i,x,n
      integer*8 aoffset,boffset
      real*8 a(10)
      real*8 b(10)
      real*8 diff
      character arg*32

      call getarg(1,arg)

      call ceedinit(trim(arg)//char(0),ceed,err)

      n=10

      call ceedvectorcreate(ceed,n,x,err)

      do i=1,10
        a(i)=10+i
      enddo

      aoffset=0
      call ceedvectorsetarray(x,ceed_mem_host,ceed_use_pointer,a,aoffset,err)
      call ceedvectorreciprocal(x,err)

      call ceedvectorgetarrayread(x,ceed_mem_host,b,boffset,err)
      do i=1,10
        diff=1./(real(10+i,8))-b(i+boffset)
        if (abs(diff)>1.0D-15) then
! LCOV_EXCL_START
          write(*,*) 'Error reading array b(',i,')=',b(i+boffset),diff
! LCOV_EXCL_STOP
        endif
      enddo

      call ceedvectorrestorearrayread(x,b,boffset,err)
      call ceedvectordestroy(x,err)
      call ceeddestroy(ceed,err)

      end
!-----------------------------------------------------------------------
