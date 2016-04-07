
C      SUBROUTINE BITRV
C$PROG BITRV
      SUBROUTINE BITRV (DATA,NPREV,N,NREM)
C     SHUFFLE THE DATA BY BIT REVERSAL.
C     DIMENSION DATA(NPREV,N,NREM)
C     COMPLEX DATA
C     EXCHANGE DATA(J1,J4REV,J5) WITH DATA(J1,J4,J5) FOR ALL J1 FROM 1
C     TO NPREV, ALL J4 FROM 1 TO N (WHICH MUST BE A POWER OF TWO), AND
C     ALL J5 FROM 1 TO NREM.  J4REV-1 IS THE BIT REVERSAL OF J4-1.  E.G.
C     SUPPOSE N = 32.  THEN FOR J4-1 = 10011, J4REV-1 = 11001, ETC.
      DIMENSION DATA(1)
      IP0=2
      IP1=IP0*NPREV
      IP4=IP1*N
      IP5=IP4*NREM
      I4REV=1
C     I4REV = 1+(J4REV-1)*IP1
      DO 60 I4=1,IP4,IP1
C     I4 = 1+(J4-1)*IP1
      IF (I4-I4REV) 10,30,30
 10   I1MAX=I4+IP1-IP0
      DO 20 I1=I4,I1MAX,IP0
C     I1 = 1+(J1-1)*IP0+(J4-1)*IP1
      DO 20 I5=I1,IP5,IP4
C     I5 = 1+(J1-1)*IP0+(J4-1)*IP1+(J5-1)*IP4
      I5REV=I4REV+I5-I4
C     I5REV = 1+(J1-1)*IP0+(J4REV-1)*IP1+(J5-1)*IP4
      TEMPR=DATA(I5)
      TEMPI=DATA(I5+1)
      DATA(I5)=DATA(I5REV)
      DATA(I5+1)=DATA(I5REV+1)
      DATA(I5REV)=TEMPR
 20   DATA(I5REV+1)=TEMPI
C     ADD ONE WITH DOWNWARD CARRY TO THE HIGH ORDER BIT OF J4REV-1.
 30   IP2=IP4/2
 40   IF (I4REV-IP2) 60,60,50
 50   I4REV=I4REV-IP2
      IP2=IP2/2
      IF (IP2-IP1) 60,40,40
 60   I4REV=I4REV+IP2
      RETURN
      END
