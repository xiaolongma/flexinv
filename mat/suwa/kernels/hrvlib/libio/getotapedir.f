      subroutine getotapedir(string,ll)
      character*(*) string
      character*80 string2
      call getsafdir(string2,ll)
      string=string2(1:ll)//'/otapes'
      ll=ll+7
      return
      end
