      character*10 nameblock(2)
      character*9 namedrive(2)
      character*20 volumemounted,tapemounted
      common/oascommon/ioaswait,ioasverbose,
     #      ischan,iowned(2),imounted(2),
     #      volumemounted(2),tapemounted(2)
c---- changed devices numbers from 2,3 to 4,5 GE980802
      data nameblock /'/dev/nrst4','/dev/nrst5'/
      data namedrive /'/dev/rst4','/dev/rst5'/
