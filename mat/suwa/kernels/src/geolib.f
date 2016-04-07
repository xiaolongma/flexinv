      SUBROUTINE AHOUSE(N,IU,C,Y,A,B,P,TA,TB,W,V,EV)
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
C   SCM VERSION
      DIMENSION A(1),B(1),P(1),TA(1),TB(1),W(1),Y(1),V(1)
      DIMENSION C(3),EV(1)
      EPS=1.D-14
      UMEPS=1.D0-EPS
      TOL=1.D-70
      JSKIP=0
      KSKIP=1
      NM1=N-1
      I=1
      IDM1=0
      P(1)=0.D0
      V(1)=0.D0
      W(1)=0.D0
      IF(N.LE.0) RETURN
      IF(N.GT.2) GO TO 4
      IF(N.EQ.2) GO TO 3
      EV(1)=C(1)
      Y(1)=1.D0
      WRITE(IU) EV(1),Y(1)
      END FILE IU
      REWIND IU
      RETURN
    3 A(1)=C(1)
      B(1)=-C(2)
      CKJ=C(3)
      IP1=2
      GO TO 215
    4 IP1=I+1
      NMI=N-I
      KJ=IDM1
      J=I
    5 JP1=J+1
      VJ=V(J)
      K=J
      LJ=N-J+1
      JD=KJ+1
      IF(KSKIP.EQ.1) GO TO 6
      PJ=P(J)
      WJ=W(J)
    6 KJ=KJ+1
      CKJ=C(KJ)
      IF(KSKIP.EQ.1) GO TO 7
      DC=-(PJ*W(K)+WJ*P(K))
      CKJ=DC+CKJ
      C(KJ)=CKJ
    7 IF(J.GT.I) GO TO 14
      IF(K.GT.J) GO TO 8
      A(I)=CKJ
      K=K+1
      GO TO 6
    8 Y(K)=0.D0
      V(K)=CKJ
      K=K+1
      IF(K.LE.N) GO TO 6
      JSKIP=0
      SUM=DOT(V(JP1),1,V(JP1),1,LJ-1)
      IF(SUM.LE.TOL) GO TO 10
      S=DSQRT(SUM)
      CSD=V(JP1)
      IF(CSD.LT.0.D0) S=-S
      V(JP1)=CSD+S
      C(JD+1)=V(JP1)
      H=SUM+CSD*S
      B(I)=-S
      GO TO 12
   10 B(I)=0.D0
      JSKIP=1
   12 IDM1=KJ
      IF(JSKIP.EQ.1.AND.KSKIP.EQ.1) GO TO 215
      J=JP1
      GO TO 5
   14 IF(JSKIP.EQ.0) GO TO 15
      K=K+1
      IF(K.LE.N) GO TO 6
      J=JP1
      IF(J.LE.N) GO TO 5
      GO TO 215
   15 Y(K)=Y(K)+CKJ*VJ
      K=K+1
      IF(K.LE.N) GO TO 6
      IF(J.EQ.N) GO TO 17
      Y(J)=Y(J)+DOT(C(JD+1),1,V(JP1),1,LJ-1)
      J=JP1
      GO TO 5
 
   17 SP=DOT(V(IP1),1,Y(IP1),1,NMI)/(H+H)
      DO 21 J=IP1,N
      W(J)=V(J)
   21 P(J)=(Y(J)-SP*V(J))/H
  215 KSKIP=JSKIP
      I=IP1
      IF(I.LE.NM1) GO TO 4
      A(N)=CKJ
      B(NM1)=-B(NM1)
      B(N)=0.D0
      U=DABS(A(1))+DABS(B(1))
      DO 22 I=2,N
   22 U=DMAX1(U,DABS(A(I))+DABS(B(I))+DABS(B(I-1)))
      BD=U
      RBD=1.D0/U
      DO 23 I=1,N
      W(I)=B(I)
      B(I)=(B(I)/U)**2
      A(I)=A(I)/U
      V(I)=0.D0
   23 EV(I)=-1.D0
      U=1.D0
      IK=1
      NDIM=KJ
 1000 K=IK
      EL=EV(K)
   24 ELAM=.5D0*(U+EL)
      DU=(4.D0*DABS(ELAM)+RBD)*EPS
      IF(DABS(U-EL).LE.DU) GO TO 42
      IAG=0
      Q=A(1)-ELAM
      IF(Q.GE.0.D0) IAG=IAG+1
      DO 38 I=2,N
      IF(Q.EQ.0.D0) X=DABS(W(I-1)/BD)/EPS
      IF(Q.NE.0.D0) X=B(I-1)/Q
      Q=A(I)-ELAM-X
      IF( Q.GE.0.D0) IAG=IAG+1
   38 CONTINUE
      IF(IAG.GE.K) GO TO 39
      U=ELAM
      GO TO 24
   39 IF(IAG.EQ.K) GO TO 41
      M=K+1
      DO 40 MM=M,IAG
   40 EV(MM)=ELAM
   41 EL=ELAM
      GO TO 24
   42 ELAM=BD*ELAM
      EV(K)=ELAM
      IF(IK.EQ.1) GO TO 44
      IF(ELAM.GE.EV(IK-1)) EV(IK)=UMEPS*EV(IK-1)
   44 I=IK
      II=1
      L=N-1
      DO 49 J=1,N
   49 Y(J)=1.D0
   50 DO 51 K=1,N
      P(K)=0.D0
      TB(K)=W(K)
   51 TA(K)=BD*A(K)-EV(I)
      J=1
      DO 57 JP1=2,N
      IF(DABS(TA(J)).LT.DABS(W(J))) GO TO 53
      IF(TA(J).EQ.0.D0) TA(J)=EPS
      F=W(J)/TA(J)
      GO TO 55
   53 F=TA(J)/W(J)
      TA(J)=W(J)
      T=TA(JP1)
      TA(JP1)=TB(J)
      TB(J)=T
      P(J)=TB(JP1)
      TB(JP1)=0.D0
      T=Y(J)
      Y(J)=Y(JP1)
      Y(JP1)=T
   55 TB(JP1)=TB(JP1)-F*P(J)
      TA(JP1)=TA(JP1)-F*TB(J)
      Y(JP1)=Y(JP1)-F*Y(J)
   57 J=JP1
      IF(TA(N).EQ.0.D0) TA(N)=EPS
      IF(TA(L).EQ.0.D0) TA(L)=EPS
      Y(N)=Y(N)/TA(N)
      Y(L)=(Y(L)-Y(N)*TB(L))/TA(L)
      DO 62 J=2,L
      K=N-J
      IF(TA(K).EQ.0.D0) TA(K)=EPS
   62 Y(K)=(Y(K)-Y(K+1)*TB(K)-Y(K+2)*P(K))/TA(K)
      AY=DABS(Y(1))
      DO 63 J=2,N
   63 AY=DMAX1(AY,DABS(Y(J)))
      DO 64 J=1,N
   64 Y(J)=Y(J)/AY
      II=II+1
      IF(II.LE.2) GO TO 50
      ID=NDIM-2
      L=N-2
      DO 68 J=1,L
      ID=ID-J-2
      M=N-J
      H=W(M-1)
      IF(H.EQ.0.D0) GO TO 68
      JP1=J+1
      T=DOT(C(ID+1),1,Y(M),1,JP1)/(H*C(ID+1))
      KJ=ID
      DO 67 K=M,N
      KJ=KJ+1
   67 Y(K)=Y(K)+T*C(KJ)
   68 CONTINUE
      XNORM=DSQRT(DOT(Y,1,Y,1,N))
      DO 70 J=1,N
   70 Y(J)=Y(J)/XNORM
      WRITE(IU) EV(IK),(Y(J),J=1,N)
      WRITE(6,901) IK,EV(IK)
  901 FORMAT(I6,5X,D20.12)
      IK=IK+1
      IF(IK.LE.N) GO TO 1000
      END FILE IU
      REWIND IU
      RETURN
      END
 
 
      SUBROUTINE BHOUSE(N,C,Y,A,B,P,TA,TB,W,V,EV,UU,IDU)
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
C   SCM VERSION
      DIMENSION A(1),B(1),P(1),TA(1),TB(1),W(1),Y(1),V(1)
     1   ,UU(IDU,IDU)
      DIMENSION C(3),EV(1)
      EPS=1.D-14
      UMEPS=1.D0-EPS
      TOL=1.D-70
      JSKIP=0
      KSKIP=1
      NM1=N-1
      I=1
      IDM1=0
      P(1)=0.D0
      V(1)=0.D0
      W(1)=0.D0
      IF(N.LE.0) RETURN
      IF(N.GT.2) GO TO 4
      IF(N.EQ.2) GO TO 3
      EV(1)=C(1)
      Y(1)=1.D0
C     WRITE(IU) EV(1),Y(1)
C     END FILE IU
C     REWIND IU
      RETURN
    3 A(1)=C(1)
      B(1)=-C(2)
      CKJ=C(3)
      IP1=2
      GO TO 215
    4 IP1=I+1
      NMI=N-I
      KJ=IDM1
      J=I
    5 JP1=J+1
      VJ=V(J)
      K=J
      LJ=N-J+1
      JD=KJ+1
      IF(KSKIP.EQ.1) GO TO 6
      PJ=P(J)
      WJ=W(J)
    6 KJ=KJ+1
      CKJ=C(KJ)
      IF(KSKIP.EQ.1) GO TO 7
      DC=-(PJ*W(K)+WJ*P(K))
      CKJ=DC+CKJ
      C(KJ)=CKJ
    7 IF(J.GT.I) GO TO 14
      IF(K.GT.J) GO TO 8
      A(I)=CKJ
      K=K+1
      GO TO 6
    8 Y(K)=0.D0
      V(K)=CKJ
      K=K+1
      IF(K.LE.N) GO TO 6
      JSKIP=0
      SUM=DOT(V(JP1),1,V(JP1),1,LJ-1)
      IF(SUM.LE.TOL) GO TO 10
      S=DSQRT(SUM)
      CSD=V(JP1)
      IF(CSD.LT.0.D0) S=-S
      V(JP1)=CSD+S
      C(JD+1)=V(JP1)
      H=SUM+CSD*S
      B(I)=-S
      GO TO 12
   10 B(I)=0.D0
      JSKIP=1
   12 IDM1=KJ
      IF(JSKIP.EQ.1.AND.KSKIP.EQ.1) GO TO 215
      J=JP1
      GO TO 5
   14 IF(JSKIP.EQ.0) GO TO 15
      K=K+1
      IF(K.LE.N) GO TO 6
      J=JP1
      IF(J.LE.N) GO TO 5
      GO TO 215
   15 Y(K)=Y(K)+CKJ*VJ
      K=K+1
      IF(K.LE.N) GO TO 6
      IF(J.EQ.N) GO TO 17
      Y(J)=Y(J)+DOT(C(JD+1),1,V(JP1),1,LJ-1)
      J=JP1
      GO TO 5
   17 SP=DOT(V(IP1),1,Y(IP1),1,NMI)/(H+H)
      DO 21 J=IP1,N
      W(J)=V(J)
   21 P(J)=(Y(J)-SP*V(J))/H
  215 KSKIP=JSKIP
      I=IP1
      IF(I.LE.NM1) GO TO 4
      A(N)=CKJ
      B(NM1)=-B(NM1)
      B(N)=0.D0
      U=DABS(A(1))+DABS(B(1))
      DO 22 I=2,N
   22 U=DMAX1(U,DABS(A(I))+DABS(B(I))+DABS(B(I-1)))
      BD=U
      RBD=1.D0/U
      DO 23 I=1,N
      W(I)=B(I)
      B(I)=(B(I)/U)**2
      A(I)=A(I)/U
      V(I)=0.D0
   23 EV(I)=-1.D0
      U=1.D0
      IK=1
      NDIM=KJ
 1000 K=IK
      EL=EV(K)
   24 ELAM=.5D0*(U+EL)
      DU=(4.D0*DABS(ELAM)+RBD)*EPS
      IF(DABS(U-EL).LE.DU) GO TO 42
      IAG=0
      Q=A(1)-ELAM
      IF(Q.GE.0.D0) IAG=IAG+1
      DO 38 I=2,N
      IF(Q.EQ.0.D0) X=DABS(W(I-1)/BD)/EPS
      IF(Q.NE.0.D0) X=B(I-1)/Q
      Q=A(I)-ELAM-X
      IF( Q.GE.0.D0) IAG=IAG+1
   38 CONTINUE
      IF(IAG.GE.K) GO TO 39
      U=ELAM
      GO TO 24
   39 IF(IAG.EQ.K) GO TO 41
      M=K+1
      DO 40 MM=M,IAG
   40 EV(MM)=ELAM
   41 EL=ELAM
      GO TO 24
   42 ELAM=BD*ELAM
      EV(K)=ELAM
      IF(IK.EQ.1) GO TO 44
      IF(ELAM.GE.EV(IK-1)) EV(IK)=UMEPS*EV(IK-1)
   44 I=IK
      II=1
      L=N-1
      DO 49 J=1,N
   49 Y(J)=1.D0
   50 DO 51 K=1,N
      P(K)=0.D0
      TB(K)=W(K)
   51 TA(K)=BD*A(K)-EV(I)
      J=1
      DO 57 JP1=2,N
      IF(DABS(TA(J)).LT.DABS(W(J))) GO TO 53
      IF(TA(J).EQ.0.D0) TA(J)=EPS
      F=W(J)/TA(J)
      GO TO 55
   53 F=TA(J)/W(J)
      TA(J)=W(J)
      T=TA(JP1)
      TA(JP1)=TB(J)
      TB(J)=T
      P(J)=TB(JP1)
      TB(JP1)=0.D0
      T=Y(J)
      Y(J)=Y(JP1)
      Y(JP1)=T
   55 TB(JP1)=TB(JP1)-F*P(J)
      TA(JP1)=TA(JP1)-F*TB(J)
      Y(JP1)=Y(JP1)-F*Y(J)
   57 J=JP1
      IF(TA(N).EQ.0.D0) TA(N)=EPS
      IF(TA(L).EQ.0.D0) TA(L)=EPS
      Y(N)=Y(N)/TA(N)
      Y(L)=(Y(L)-Y(N)*TB(L))/TA(L)
      DO 62 J=2,L
      K=N-J
      IF(TA(K).EQ.0.D0) TA(K)=EPS
   62 Y(K)=(Y(K)-Y(K+1)*TB(K)-Y(K+2)*P(K))/TA(K)
      AY=DABS(Y(1))
      DO 63 J=2,N
   63 AY=DMAX1(AY,DABS(Y(J)))
      DO 64 J=1,N
   64 Y(J)=Y(J)/AY
      II=II+1
      IF(II.LE.2) GO TO 50
      ID=NDIM-2
      L=N-2
      DO 68 J=1,L
      ID=ID-J-2
      M=N-J
      H=W(M-1)
      IF(H.EQ.0.D0) GO TO 68
      JP1=J+1
      T=DOT(C(ID+1),1,Y(M),1,JP1)/(H*C(ID+1))
      KJ=ID
      DO 67 K=M,N
      KJ=KJ+1
   67 Y(K)=Y(K)+T*C(KJ)
   68 CONTINUE
      XNORM=DSQRT(DOT(Y,1,Y,1,N))
      DO 70 J=1,N
   70 Y(J)=Y(J)/XNORM
C     WRITE(IU) EV(IK),(Y(J),J=1,N)
C     WRITE(6,901) IK,EV(IK)
C 901 FORMAT(I6,5X,D20.12)
      DO 90 J=1,N
   90 UU(J,IK)=Y(J)
      IK=IK+1
      IF(IK.LE.N) GO TO 1000
C     END FILE IU
C     REWIND IU
      RETURN
      END
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
 
c---probably very old. cant find bset(). I comment CONVSP out. Not called
c---from anywhere. Lapo 09 Feb 04.
c      SUBROUTINE CONVSP(J)
c      IF(J.GE.0) RETURN
c      J=-J
c      CALL BSET(J,0)
c      RETURN
c      END
 
      SUBROUTINE COOL2 (DATA,NPREV,N,NREM,ISIGN)
C     DISCRETE FOURIER TRANSFORM OF LENGTH N.  IN-PLACE COOLEY-TUKEY
C     ALGORITHM, BIT-REVERSED TO NORMAL ORDER, SANDE-TUKEY PHASE SHIFTS.
C     DIMENSION DATA(NPREV,N,NREM)
C     COMPLEX DATA
C     DATA(J1,K4,J5) = SUM(DATA(J1,J4,J5)*EXP(ISIGN*2*PI*I*(J4-1)*
C     (K4-1)/N)), SUMMED OVER J4 = 1 TO N FOR ALL J1 FROM 1 TO NPREV,
C     K4 FROM 1 TO N AND J5 FROM 1 TO NREM.  N MUST BE A POWER OF TWO.
C     METHOD--LET IPREV TAKE THE VALUES 1, 2 OR 4, 4 OR 8, ..., N/16,
C     N/4, N.  THE CHOICE BETWEEN 2 OR 4, ETC., DEPENDS ON WHETHER N IS
C     A POWER OF FOUR.  DEFINE IFACT = 2 OR 4, THE NEXT FACTOR THAT
C     IPREV MUST TAKE, AND IREM = N/(IFACT*IPREV).  THEN--
C     DIMENSION DATA(NPREV,IPREV,IFACT,IREM,NREM)
C     COMPLEX DATA
C     DATA(J1,J2,K3,J4,J5) = SUM(DATA(J1,J2,J3,J4,J5)*EXP(ISIGN*2*PI*I*
C     (K3-1)*((J3-1)/IFACT+(J2-1)/(IFACT*IPREV)))), SUMMED OVER J3 = 1
C     TO IFACT FOR ALL J1 FROM 1 TO NPREV, J2 FROM 1 TO IPREV, K3 FROM
C     1 TO IFACT, J4 FROM 1 TO IREM AND J5 FROM 1 TO NREM.  THIS IS
C     A PHASE-SHIFTED DISCRETE FOURIER TRANSFORM OF LENGTH IFACT.
C     FACTORING N BY FOURS SAVES ABOUT TWENTY FIVE PERCENT OVER FACTOR-
C     ING BY TWOS.  DATA MUST BE BIT-REVERSED INITIALLY.
C     IT IS NOT NECESSARY TO REWRITE THIS SUBROUTINE INTO COMPLEX
C     NOTATION SO LONG AS THE FORTRAN COMPILER USED STORES REAL AND
C     IMAGINARY PARTS IN ADJACENT STORAGE LOCATIONS.  IT MUST ALSO
C     STORE ARRAYS WITH THE FIRST SUBSCRIPT INCREASING FASTEST.
      DIMENSION DATA(1)
      TWOPI=6.2831853072*FLOAT(ISIGN)
      IP0=2
      IP1=IP0*NPREV
      IP4=IP1*N
      IP5=IP4*NREM
      IP2=IP1
C     IP2=IP1*IPROD
      NPART=N
 10   IF (NPART-2) 60,30,20
 20   NPART=NPART/4
      GO TO 10
C     DO A FOURIER TRANSFORM OF LENGTH TWO
 30   IF (IP2-IP4) 40,160,160
 40   IP3=IP2*2
C     IP3=IP2*IFACT
      DO 50 I1=1,IP1,IP0
C     I1 = 1+(J1-1)*IP0
      DO 50 I5=I1,IP5,IP3
C     I5 = 1+(J1-1)*IP0+(J4-1)*IP3+(J5-1)*IP4
      I3A=I5
      I3B=I3A+IP2
C     I3 = 1+(J1-1)*IP0+(J2-1)*IP1+(J3-1)*IP2+(J4-1)*IP3+(J5-1)*IP4
      TEMPR=DATA(I3B)
      TEMPI=DATA(I3B+1)
      DATA(I3B)=DATA(I3A)-TEMPR
      DATA(I3B+1)=DATA(I3A+1)-TEMPI
      DATA(I3A)=DATA(I3A)+TEMPR
 50   DATA(I3A+1)=DATA(I3A+1)+TEMPI
      IP2=IP3
C     DO A FOURIER TRANSFORM OF LENGTH FOUR (FROM BIT REVERSED ORDER)
 60   IF (IP2-IP4) 70,160,160
 70   IP3=IP2*4
C     IP3=IP2*IFACT
C     COMPUTE TWOPI THRU WR AND WI IN DOUBLE PRECISION, IF AVAILABLE.
      THETA=TWOPI/FLOAT(IP3/IP1)
      SINTH=SIN(THETA/2.)
      WSTPR=-2.*SINTH*SINTH
      WSTPI=SIN(THETA)
      WR=1.
      WI=0.
      DO 150 I2=1,IP2,IP1
C     I2 = 1+(J2-1)*IP1
      IF (I2-1) 90,90,80
 80   W2R=WR*WR-WI*WI
      W2I=2.*WR*WI
      W3R=W2R*WR-W2I*WI
      W3I=W2R*WI+W2I*WR
 90   I1MAX=I2+IP1-IP0
      DO 140 I1=I2,I1MAX,IP0
C     I1 = 1+(J1-1)*IP0+(J2-1)*IP1
      DO 140 I5=I1,IP5,IP3
C     I5 = 1+(J1-1)*IP0+(J2-1)*IP1+(J4-1)*IP3+(J5-1)*IP4
      I3A=I5
      I3B=I3A+IP2
      I3C=I3B+IP2
      I3D=I3C+IP2
C     I3 = 1+(J1-1)*IP0+(J2-1)*IP1+(J3-1)*IP2+(J4-1)*IP3+(J5-1)*IP4
      IF (I2-1) 110,110,100
C     APPLY THE PHASE SHIFT FACTORS
 100  TEMPR=DATA(I3B)
      DATA(I3B)=W2R*DATA(I3B)-W2I*DATA(I3B+1)
      DATA(I3B+1)=W2R*DATA(I3B+1)+W2I*TEMPR
      TEMPR=DATA(I3C)
      DATA(I3C)=WR*DATA(I3C)-WI*DATA(I3C+1)
      DATA(I3C+1)=WR*DATA(I3C+1)+WI*TEMPR
      TEMPR=DATA(I3D)
      DATA(I3D)=W3R*DATA(I3D)-W3I*DATA(I3D+1)
      DATA(I3D+1)=W3R*DATA(I3D+1)+W3I*TEMPR
 110  T0R=DATA(I3A)+DATA(I3B)
      T0I=DATA(I3A+1)+DATA(I3B+1)
      T1R=DATA(I3A)-DATA(I3B)
      T1I=DATA(I3A+1)-DATA(I3B+1)
      T2R=DATA(I3C)+DATA(I3D)
      T2I=DATA(I3C+1)+DATA(I3D+1)
      T3R=DATA(I3C)-DATA(I3D)
      T3I=DATA(I3C+1)-DATA(I3D+1)
      DATA(I3A)=T0R+T2R
      DATA(I3A+1)=T0I+T2I
      DATA(I3C)=T0R-T2R
      DATA(I3C+1)=T0I-T2I
      IF (ISIGN) 120,120,130
 120  T3R=-T3R
      T3I=-T3I
 130  DATA(I3B)=T1R-T3I
      DATA(I3B+1)=T1I+T3R
      DATA(I3D)=T1R+T3I
 140  DATA(I3D+1)=T1I-T3R
      TEMPR=WR
      WR=WSTPR*TEMPR-WSTPI*WI+TEMPR
 150  WI=WSTPR*WI+WSTPI*TEMPR+WI
      IP2=IP3
      GO TO 60
 160  RETURN
      END
      DOUBLE PRECISION FUNCTION DDABS(X)
      DOUBLE PRECISION X
      IF(X.GE.0.D0) DDABS=X
      IF(X.LT.0.D0) DDABS=-X
      RETURN
      END
      DOUBLE PRECISION FUNCTION DFLOAT(I)
      DFLOAT=DBLE(I)
      RETURN
      END
 
      DOUBLE PRECISION FUNCTION DOT(A,J,B,K,N)
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION A,B
      DIMENSION A(J,N),B(K,N)
      DOT=0.D0
      DO 1 I=1,N
    1 DOT=DOT+A(1,I)*B(1,I)
      RETURN
      END
      DOUBLE PRECISION FUNCTION DRSPLE(I1,I2,X,Y,Q,S)
C
C C$C$C$C$C$ CALLS ONLY LIBRARY ROUTINES C$C$C$C$C$
C
C   RSPLE RETURNS THE VALUE OF THE FUNCTION Y(X) EVALUATED AT POINT S
C   USING THE CUBIC SPLINE COEFFICIENTS COMPUTED BY RSPLN AND SAVED IN
C   Q.  IF S IS OUTSIDE THE INTERVAL (X(I1),X(I2)) RSPLE EXTRAPOLATES
C   USING THE FIRST OR LAST INTERPOLATION POLYNOMIAL.  THE ARRAYS MUST
C   BE DIMENSIONED AT LEAST - X(I2), Y(I2), AND Q(3,I2).
C
C                                                     -RPB
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DIMENSION X(1),Y(1),Q(3,1)
      DOUBLE PRECISION X,Y,Q,S
      DATA I/1/
      II=I2-1
C   GUARANTEE I WITHIN BOUNDS.
      I=MAX0(I,I1)
      I=MIN0(I,II)
C   SEE IF X IS INCREASING OR DECREASING.
      IF(X(I2)-X(I1))1,2,2
C   X IS DECREASING.  CHANGE I AS NECESSARY.
 1    IF(S-X(I))3,3,4
 4    I=I-1
      IF(I-I1)11,6,1
 3    IF(S-X(I+1))5,6,6
 5    I=I+1
      IF(I-II)3,6,7
C   X IS INCREASING.  CHANGE I AS NECESSARY.
 2    IF(S-X(I+1))8,8,9
 9    I=I+1
      IF(I-II)2,6,7
 8    IF(S-X(I))10,6,6
 10   I=I-1
      IF(I-I1)11,6,8
 7    I=II
      GO TO 6
 11   I=I1
C   CALCULATE RSPLE USING SPLINE COEFFICIENTS IN Y AND Q.
 6    H=S-X(I)
      DRSPLE=Y(I)+H*(Q(1,I)+H*(Q(2,I)+H*Q(3,I)))
      RETURN
      END
      SUBROUTINE DRSPLN(I1,I2,X,Y,Q,F)
C
C C$C$C$C$C$ CALLS ONLY LIBRARY ROUTINES C$C$C$C$C$
C
C   SUBROUTINE RSPLN COMPUTES CUBIC SPLINE INTERPOLATION COEFFICIENTS
C   FOR Y(X) BETWEEN GRID POINTS I1 AND I2 SAVING THEM IN Q.  THE
C   INTERPOLATION IS CONTINUOUS WITH CONTINUOUS FIRST AND SECOND
C   DERIVITIVES.  IT AGREES EXACTLY WITH Y AT GRID POINTS AND WITH THE
C   THREE POINT FIRST DERIVITIVES AT BOTH END POINTS (I1 AND I2).
C   X MUST BE MONOTONIC BUT IF TWO SUCCESSIVE VALUES OF X ARE EQUAL
C   A DISCONTINUITY IS ASSUMED AND SEPERATE INTERPOLATION IS DONE ON
C   EACH STRICTLY MONOTONIC SEGMENT.  THE ARRAYS MUST BE DIMENSIONED AT
C   LEAST - X(I2), Y(I2), Q(3,I2), AND F(3,I2).  F IS WORKING STORAGE
C   FOR RSPLN.
C                                                     -RPB
C
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION X,Y,Q,F
      DIMENSION X(1),Y(1),Q(3,1),F(3,1),YY(3)
      EQUIVALENCE (YY(1),Y0)
      DATA SMALL/1.D-10/,YY/0.D0,0.D0,0.D0/
      J1=I1+1
      Y0=0.D0
C   BAIL OUT IF THERE ARE LESS THAN TWO POINTS TOTAL.
      IF(I2-I1)13,17,8
 8    A0=X(J1-1)
C   SEARCH FOR DISCONTINUITIES.
      DO 3 I=J1,I2
      B0=A0
      A0=X(I)
      IF(DDABS((A0-B0)/DMAX1(A0,B0)).LT.SMALL) GO TO 4
 3    CONTINUE
 17   J1=J1-1
      J2=I2-2
      GO TO 5
 4    J1=J1-1
      J2=I-3
C   SEE IF THERE ARE ENOUGH POINTS TO INTERPOLATE (AT LEAST THREE).
 5    IF(J2+1-J1)9,10,11
C   ONLY TWO POINTS.  USE LINEAR INTERPOLATION.
 10   J2=J2+2
      Y0=(Y(J2)-Y(J1))/(X(J2)-X(J1))
      DO 15 J=1,3
      Q(J,J1)=YY(J)
 15   Q(J,J2)=YY(J)
      GO TO 12
C   MORE THAN TWO POINTS.  DO SPLINE INTERPOLATION.
 11   A0=0.
      H=X(J1+1)-X(J1)
      H2=X(J1+2)-X(J1)
      Y0=H*H2*(H2-H)
      H=H*H
      H2=H2*H2
C   CALCULATE DERIVITIVE AT NEAR END.
      B0=(Y(J1)*(H-H2)+Y(J1+1)*H2-Y(J1+2)*H)/Y0
      B1=B0
C   EXPLICITLY REDUCE BANDED MATRIX TO AN UPPER BANDED MATRIX.
      DO 1 I=J1,J2
      H=X(I+1)-X(I)
      Y0=Y(I+1)-Y(I)
      H2=H*H
      HA=H-A0
      H2A=H-2.D0*A0
      H3A=2.D0*H-3.D0*A0
      H2B=H2*B0
      Q(1,I)=H2/HA
      Q(2,I)=-HA/(H2A*H2)
      Q(3,I)=-H*H2A/H3A
      F(1,I)=(Y0-H*B0)/(H*HA)
      F(2,I)=(H2B-Y0*(2.D0*H-A0))/(H*H2*H2A)
      F(3,I)=-(H2B-3.D0*Y0*HA)/(H*H3A)
      A0=Q(3,I)
 1    B0=F(3,I)
C   TAKE CARE OF LAST TWO ROWS.
      I=J2+1
      H=X(I+1)-X(I)
      Y0=Y(I+1)-Y(I)
      H2=H*H
      HA=H-A0
      H2A=H*HA
      H2B=H2*B0-Y0*(2.D0*H-A0)
      Q(1,I)=H2/HA
      F(1,I)=(Y0-H*B0)/H2A
      HA=X(J2)-X(I+1)
      Y0=-H*HA*(HA+H)
      HA=HA*HA
C   CALCULATE DERIVITIVE AT FAR END.
      Y0=(Y(I+1)*(H2-HA)+Y(I)*HA-Y(J2)*H2)/Y0
      Q(3,I)=(Y0*H2A+H2B)/(H*H2*(H-2.D0*A0))
      Q(2,I)=F(1,I)-Q(1,I)*Q(3,I)
C   SOLVE UPPER BANDED MATRIX BY REVERSE ITERATION.
      DO 2 J=J1,J2
      K=I-1
      Q(1,I)=F(3,K)-Q(3,K)*Q(2,I)
      Q(3,K)=F(2,K)-Q(2,K)*Q(1,I)
      Q(2,K)=F(1,K)-Q(1,K)*Q(3,K)
 2    I=K
      Q(1,I)=B1
C   FILL IN THE LAST POINT WITH A LINEAR EXTRAPOLATION.
 9    J2=J2+2
      DO 14 J=1,3
 14   Q(J,J2)=YY(J)
C   SEE IF THIS DISCONTINUITY IS THE LAST.
 12   IF(J2-I2)6,13,13
C   NO.  GO BACK FOR MORE.
 6    J1=J2+2
      IF(J1-I2)8,8,7
C   THERE IS ONLY ONE POINT LEFT AFTER THE LATEST DISCONTINUITY.
 7    DO 16 J=1,3
 16   Q(J,I2)=YY(J)
C   FINI.
 13   RETURN
      END
 
      SUBROUTINE DSPINT(R,F,I1,I2,A,WORK,IWORK)
C
C    SPLINT DOES QUADRATURE ON A SPLINE FITTED INTEGRAND.
C
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DIMENSION F(1),R(1),WORK(3,1)
      DATA T/.333333333333333333/
      IF(IWORK.LT.6*(I2-I1+1)) PAUSE 'INSUFFICIENT WORK SPACE IN SPLINT'
      CALL DRSPLN(I1,I2,R,F,WORK,WORK(1,I2-I1+2))
      A=0.D0
      DO 20 I=I1,I2-1
      B=R(I+1)-R(I)
      A=A+B*(F(I)+B*(.5D0*WORK(1,I)+B*(T*WORK(2,I)+.25D0*B*WORK(3,I))))
   20 CONTINUE
      RETURN
      END
 
      SUBROUTINE FIXRL (DATA,N,NREM,ISIGN,IFORM)
C     FOR IFORM = 0, CONVERT THE TRANSFORM OF A DOUBLED-UP REAL ARRAY,
C     CONSIDERED COMPLEX, INTO ITS TRUE TRANSFORM.  SUPPLY ONLY THE
C     FIRST HALF OF THE COMPLEX TRANSFORM, AS THE SECOND HALF HAS
C     CONJUGATE SYMMETRY.  FOR IFORM = -1, CONVERT THE FIRST HALF
C     OF THE TRUE TRANSFORM INTO THE TRANSFORM OF A DOUBLED-UP REAL
C     ARRAY.  N MUST BE EVEN.
C     USING COMPLEX NOTATION AND SUBSCRIPTS STARTING AT ZERO, THE
C     TRANSFORMATION IS--
C     DIMENSION DATA(N,NREM)
C     ZSTP = EXP(ISIGN*2*PI*I/N)
C     DO 10 I2=0,NREM-1
C     DATA(0,I2) = CONJ(DATA(0,I2))*(1+I)
C     DO 10 I1=1,N/4
C     Z = (1+(2*IFORM+1)*I*ZSTP**I1)/2
C     I1CNJ = N/2-I1
C     DIF = DATA(I1,I2)-CONJ(DATA(I1CNJ,I2))
C     TEMP = Z*DIF
C     DATA(I1,I2) = (DATA(I1,I2)-TEMP)*(1-IFORM)
C 10  DATA(I1CNJ,I2) = (DATA(I1CNJ,I2)+CONJ(TEMP))*(1-IFORM)
C     IF I1=I1CNJ, THE CALCULATION FOR THAT VALUE COLLAPSES INTO
C     A SIMPLE CONJUGATION OF DATA(I1,I2).
      DIMENSION DATA(3)
      TWOPI=6.283185307*FLOAT(ISIGN)
      IP0=2
      IP1=IP0*(N/2)
      IP2=IP1*NREM
      IF (IFORM) 10,70,70
C     PACK THE REAL INPUT VALUES (TWO PER COLUMN)
 10   J1=IP1+1
      DATA(2)=DATA(J1)
      IF (NREM-1) 70,70,20
 20   J1=J1+IP0
      I2MIN=IP1+1
      DO 60 I2=I2MIN,IP2,IP1
      DATA(I2)=DATA(J1)
      J1=J1+IP0
      IF (N-2) 50,50,30
 30   I1MIN=I2+IP0
      I1MAX=I2+IP1-IP0
      DO 40 I1=I1MIN,I1MAX,IP0
      DATA(I1)=DATA(J1)
      DATA(I1+1)=DATA(J1+1)
 40   J1=J1+IP0
 50   DATA(I2+1)=DATA(J1)
 60   J1=J1+IP0
 70   DO 80 I2=1,IP2,IP1
      TEMPR=DATA(I2)
      DATA(I2)=DATA(I2)+DATA(I2+1)
 80   DATA(I2+1)=TEMPR-DATA(I2+1)
      IF (N-2) 200,200,90
 90   THETA=TWOPI/FLOAT(N)
      SINTH=SIN(THETA/2.)
      ZSTPR=-2.*SINTH*SINTH
      ZSTPI=SIN(THETA)
      ZR=(1.-ZSTPI)/2.
      ZI=(1.+ZSTPR)/2.
      IF (IFORM) 100,110,110
 100  ZR=1.-ZR
      ZI=-ZI
 110  I1MIN=IP0+1
      I1MAX=IP0*(N/4)+1
      DO 190 I1=I1MIN,I1MAX,IP0
      DO 180 I2=I1,IP2,IP1
      I2CNJ=IP0*(N/2+1)-2*I1+I2
      IF (I2-I2CNJ) 150,120,120
  120 IF (ISIGN*(2*IFORM+1)) 130,140,140
 130  DATA(I2+1)=-DATA(I2+1)
 140  IF (IFORM) 170,180,180
 150  DIFR=DATA(I2)-DATA(I2CNJ)
      DIFI=DATA(I2+1)+DATA(I2CNJ+1)
      TEMPR=DIFR*ZR-DIFI*ZI
      TEMPI=DIFR*ZI+DIFI*ZR
      DATA(I2)=DATA(I2)-TEMPR
      DATA(I2+1)=DATA(I2+1)-TEMPI
      DATA(I2CNJ)=DATA(I2CNJ)+TEMPR
      DATA(I2CNJ+1)=DATA(I2CNJ+1)-TEMPI
      IF (IFORM) 160,180,180
 160  DATA(I2CNJ)=DATA(I2CNJ)+DATA(I2CNJ)
      DATA(I2CNJ+1)=DATA(I2CNJ+1)+DATA(I2CNJ+1)
 170  DATA(I2)=DATA(I2)+DATA(I2)
      DATA(I2+1)=DATA(I2+1)+DATA(I2+1)
 180  CONTINUE
      TEMPR=ZR-.5
      ZR=ZSTPR*TEMPR-ZSTPI*ZI+ZR
 190  ZI=ZSTPR*ZI+ZSTPI*TEMPR+ZI
C     RECURSION SAVES TIME, AT A SLIGHT LOSS IN ACCURACY.  IF AVAILABLE,
C     USE DOUBLE PRECISION TO COMPUTE ZR AND ZI.
 200  IF (IFORM) 270,210,210
C     UNPACK THE REAL TRANSFORM VALUES (TWO PER COLUMN)
 210  I2=IP2+1
      I1=I2
      J1=IP0*(N/2+1)*NREM+1
      GO TO 250
 220  DATA(J1)=DATA(I1)
      DATA(J1+1)=DATA(I1+1)
      I1=I1-IP0
      J1=J1-IP0
 230  IF (I2-I1) 220,240,240
 240  DATA(J1)=DATA(I1)
      DATA(J1+1)=0.
 250  I2=I2-IP1
      J1=J1-IP0
      DATA(J1)=DATA(I2+1)
      DATA(J1+1)=0.
      I1=I1-IP0
      J1=J1-IP0
      IF (I2-1) 260,260,230
 260  DATA(2)=0.
 270  RETURN
      END
 
      FUNCTION FLOAT2(I)
      INTEGER*2 I
      FLOAT2=I
      RETURN
      END
 
      SUBROUTINE FOUR2 (DATA,N,NDIM,ISIGN,IFORM)
C     COOLEY-TUKEY FAST FOURIER TRANSFORM IN USASI BASIC FORTRAN.
C     MULTI-DIMENSIONAL TRANSFORM, EACH DIMENSION A POWER OF TWO,
C     COMPLEX OR REAL DATA.
C     TRANSFORM(K1,K2,...) = SUM(DATA(J1,J2,...)*EXP(ISIGN*2*PI*SQRT(-1)
C     *((J1-1)*(K1-1)/N(1)+(J2-1)*(K2-1)/N(2)+...))), SUMMED FOR ALL
C     J1 AND K1 FROM 1 TO N(1), J2 AND K2 FROM 1 TO N(2),
C     ETC. FOR ALL NDIM SUBSCRIPTS.  NDIM MUST BE POSITIVE AND
C     EACH N(IDIM) MUST BE A POWER OF TWO.  ISIGN IS +1 OR -1.
C     LET NTOT = N(1)*N(2)*...*N(NDIM).  THEN A -1 TRANSFORM
C     FOLLOWED BY A +1 ONE (OR VICE VERSA) RETURNS NTOT
C     TIMES THE ORIGINAL DATA.  IFORM = 1, 0 OR -1, AS DATA IS
C     COMPLEX, REAL OR THE FIRST HALF OF A COMPLEX ARRAY.  TRANSFORM
C     VALUES ARE RETURNED TO ARRAY DATA.  THEY ARE COMPLEX, REAL OR
C     THE FIRST HALF OF A COMPLEX ARRAY, AS IFORM = 1, -1 OR 0.
C     THE TRANSFORM OF A REAL ARRAY (IFORM = 0) DIMENSIONED N(1) BY N(2)
C     BY ... WILL BE RETURNED IN THE SAME ARRAY, NOW CONSIDERED TO
C     BE COMPLEX OF DIMENSIONS N(1)/2+1 BY N(2) BY ....  NOTE THAT IF
C     IFORM = 0 OR -1, N(1) MUST BE EVEN, AND ENOUGH ROOM MUST BE
C     RESERVED.  THE MISSING VALUES MAY BE OBTAINED BY COMPLEX CONJUGA-
C     TION.  THE REVERSE TRANSFORMATION, OF A HALF COMPLEX ARRAY DIMEN-
C     SIONED N(1)/2+1 BY N(2) BY ..., IS ACCOMPLISHED BY SETTING IFORM
C     TO -1.  IN THE N ARRAY, N(1) MUST BE THE TRUE N(1), NOT N(1)/2+1.
C     THE TRANSFORM WILL BE REAL AND RETURNED TO THE INPUT ARRAY.
C     RUNNING TIME IS PROPORTIONAL TO NTOT*LOG2(NTOT), RATHER THAN
C     THE NAIVE NTOT**2.  FURTHERMORE, LESS ERROR IS BUILT UP.
C     WRITTEN BY NORMAN BRENNER OF MIT LINCOLN LABORATORY, JANUARY 1969.
C     SEE-- IEEE AUDIO TRANSACTIONS (JUNE 1967), SPECIAL ISSUE ON FFT.
      DIMENSION DATA(1), N(1)
      NTOT=1
      DO 10 IDIM=1,NDIM
 10   NTOT=NTOT*N(IDIM)
      IF (IFORM) 70,20,20
 20   NREM=NTOT
      DO 60 IDIM=1,NDIM
      NREM=NREM/N(IDIM)
      NPREV=NTOT/(N(IDIM)*NREM)
      NCURR=N(IDIM)
      IF (IDIM-1+IFORM) 30,30,40
 30   NCURR=NCURR/2
 40   CALL BITRV (DATA,NPREV,NCURR,NREM)
      CALL COOL2 (DATA,NPREV,NCURR,NREM,ISIGN)
      IF (IDIM-1+IFORM) 50,50,60
 50   CALL FIXRL (DATA,N(1),NREM,ISIGN,IFORM)
      NTOT=(NTOT/N(1))*(N(1)/2+1)
 60   CONTINUE
      RETURN
 70   NTOT=(NTOT/N(1))*(N(1)/2+1)
      NREM=1
      DO 100 JDIM=1,NDIM
      IDIM=NDIM+1-JDIM
      NCURR=N(IDIM)
      IF (IDIM-1) 80,80,90
 80   NCURR=NCURR/2
      CALL FIXRL (DATA,N(1),NREM,ISIGN,IFORM)
      NTOT=NTOT/(N(1)/2+1)*N(1)
 90   NPREV=NTOT/(N(IDIM)*NREM)
      CALL BITRV (DATA,NPREV,NCURR,NREM)
      CALL COOL2 (DATA,NPREV,NCURR,NREM,ISIGN)
 100  NREM=NREM*N(IDIM)
      RETURN
      END
 
      SUBROUTINE INSTR(T0,TG,H0,H1,SIGMA,PERIOD,IFGO,XMAG,PHASE)
      PI=3.1415926
      TWOPI=2.*PI
      IF(IFGO.GT.0) GO TO 100
      XMU=TG/T0
      U1=25./T0
      IF(T0.EQ.15.)U1=15./T0
      GO TO 101
  100 U1=PERIOD/T0
  101  FT=1.-((1.+1./(XMU**2))+4.*H0*H1*(1.-SIGMA**2)/XMU)*(U1**2)
     1+(U1**4)/(XMU**2)
      ST=-2.*(H0+H1/XMU)*U1+2.*(H0/XMU+H1)*(U1**3)/XMU
      F=U1/SQRT(FT**2+ST**2)
      PHASE=ATAN2(FT,ST)+PI
      IF(IFGO.GT.0) GO TO 102
      Q=750.*TWOPI/(T0*F)
      XMAG=750.
      RETURN
  102 XMAG=Q*T0*F/TWOPI
      RETURN
      END
      SUBROUTINE LEGNDR(THETA,L,M,X,XP,XCOSEC)
      DIMENSION X(2),XP(2),XCOSEC(2)
      DOUBLE PRECISION SMALL,SUM,COMPAR,CT,ST,FCT,COT,FPI,X1,X2,X3,
     1F1,F2,XM,TH,DFLOAT
      DATA FPI/12.56637062D0/
      DFLOAT(I)=FLOAT(I)
      SUM=0.D0
      LP1=L+1
      TH=THETA
      CT=DCOS(TH)
      ST=DSIN(TH)
      MP1=M+1
      FCT=DSQRT(DFLOAT(2*L+1)/FPI)
      SFL3=SQRT(FLOAT(L*(L+1)))
      COMPAR=DFLOAT(2*L+1)/FPI
      DSFL3=SFL3
      SMALL=1.D-16*COMPAR
      DO 1 I=1,MP1
      X(I)=0.
      XCOSEC(I)=0.
    1 XP(I)=0.
      IF(L.GT.1.AND.ABS(THETA).GT.1.E-5) GO TO 3
      X(1)=FCT
      IF(L.EQ.0) RETURN
      X(1)=CT*FCT
      X(2)=-ST*FCT/DSFL3
      XP(1)=-ST*FCT
      XP(2)=-.5D0*CT*FCT*DSFL3
      IF(ABS(THETA).LT.1.E-5) XCOSEC(2)=XP(2)
      IF(ABS(THETA).GE.1.E-5) XCOSEC(2)=X(2)/ST
      RETURN
    3 X1=1.D0
      X2=CT
      DO 4 I=2,L
      X3=(DFLOAT(2*I-1)*CT*X2-DFLOAT(I-1)*X1)/DFLOAT(I)
      X1=X2
    4 X2=X3
      COT=CT/ST
      COSEC=1./ST
      X3=X2*FCT
      X2=DFLOAT(L)*(X1-CT*X2)*FCT/ST
      X(1)=X3
      X(2)=X2
      SUM=X3*X3
      XP(1)=-X2
      XP(2)=DFLOAT(L*(L+1))*X3-COT*X2
      X(2)=-X(2)/SFL3
      XCOSEC(2)=X(2)*COSEC
      XP(2)=-XP(2)/SFL3
      SUM=SUM+2.D0*X(2)*X(2)
      IF(SUM-COMPAR.GT.SMALL) RETURN
      X1=X3
      X2=-X2/DSQRT(DFLOAT(L*(L+1)))
      DO 5 I=3,MP1
      K=I-1
      F1=DSQRT(DFLOAT((L+I-1)*(L-I+2)))
      F2=DSQRT(DFLOAT((L+I-2)*(L-I+3)))
      XM=K
      X3=-(2.D0*COT*(XM-1.D0)*X2+F2*X1)/F1
      SUM=SUM+2.D0*X3*X3
      IF(SUM-COMPAR.GT.SMALL.AND.I.NE.LP1) RETURN
      X(I)=X3
      XCOSEC(I)=X(I)*COSEC
      X1=X2
      XP(I)=-(F1*X2+XM*COT*X3)
    5 X2=X3
      RETURN
      end
 
      SUBROUTINE MATINV(A,N,M,DET)
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION A,DET
C     THIS SUBROUTINE IS FOR MATRIX INVERSION AND SIMULT. LINEAR EQS.
C     A = THE GIVEN COEFFICIENT MATRIX A; A-1 WILL BE STORED IN THIS MAT
C         -RIX AT RETURN TO THE MAIN PROGRAM
C     N = ORDER OF A, N > OR = 1.
C     M = DIMENSION OF A IN THE CALLING PROGRAM
C     DET = VALUE OF DETERMINANT
      DIMENSION A(M,M),IPVOT(40),INDEX(40,2),PIVOT(40)
      EQUIVALENCE (IROW,JROW),(ICOL,JCOL)
C     FOLLOWING 3 STATMENTS FOR INITIALIZATION
      DET=1.D0
      DO 17 J=1,N
   17 IPVOT(J)=0
      DO 135 I=1,N
C     FOLLOWING 12 STATEMENTS FOR SEARCH FOR PIVOT ELEMENT
      T=0.D0
      DO 9 J=1,N
      IF(IPVOT(J)-1)13,9,13
   13 DO 23 K=1,N
      IF(IPVOT(K)-1)43,23,81
   43 IF(DDABS(T)-DDABS(A(J,K)))83,23,23
   83 IROW=J
      ICOL=K
      T=A(J,K)
   23 CONTINUE
    9 CONTINUE
      IPVOT(ICOL)=IPVOT(ICOL)+1
C     FOLLOWING 15 STATEMENTS TO PUT PIVOT ELEMENT ON DIAGONAL
      IF(IROW-ICOL)73,109,73
   73 DET=-DET
      DO 12 L=1,N
      T=A(IROW,L)
      A(IROW,L)=A(ICOL,L)
   12 A(ICOL,L)=T
  109 INDEX(I,1)=IROW
      INDEX(I,2)=ICOL
      PIVOT(I)=A(ICOL,ICOL)
      DET=DET*PIVOT(I)
C     FOLLOWING 6 STATEMENTS TO DIVIDE PIVOT ROW BY PIVOT ELEMENT
      A(ICOL,ICOL)=1.D0
      DO 205 L=1,N
  205 A(ICOL,L)=A(ICOL,L)/PIVOT(I)
C      FOLLOWING 10 STATEMENTS TO REDUCE NON-PIVOT ROWS
      DO 135 LI=1,N
      IF(LI-ICOL)21,135,21
   21 T=A(LI,ICOL)
      A(LI,ICOL)=0.D0
      DO 89 L=1,N
   89 A(LI,L)=A(LI,L)-A(ICOL,L)*T
  135 CONTINUE
C     FOLLOWING 11 STATEMENTS TO INTERCHANGE COLUMNS
      DO 3 I=1,N
      L=N-I+1
      IF(INDEX(L,1)-INDEX(L,2))19,3,19
   19 JROW=INDEX(L,1)
      JCOL=INDEX(L,2)
      DO 549 K=1,N
      T=A(K,JROW)
      A(K,JROW)=A(K,JCOL)
      A(K,JCOL)=T
  549 CONTINUE
    3 CONTINUE
   81 RETURN
      END
      SUBROUTINE RFOUR(DATA,M,NN)
      DIMENSION DATA(1),NTOT(3)
      NTOT(1)=2*2**M
      XN=NTOT(1)/2
      NTP2=NTOT(1)+2
      IF(NN.LT.0) GO TO 1
      NT=NTOT(1)
      DO 2 N=1,NT
    2 DATA(N)=DATA(N)/XN
      CALL FOUR2(DATA,NTOT,1,-1,0)
      RETURN
    1 DO 4 N=1,NTP2
    4 DATA(N)=DATA(N)/2.
      CALL FOUR2(DATA,NTOT,1,1,-1)
      RETURN
      END
 
      FUNCTION RSPLE(I1,I2,X,Y,Q,S)
C
C C$C$C$C$C$ CALLS ONLY LIBRARY ROUTINES C$C$C$C$C$
C
C   RSPLE RETURNS THE VALUE OF THE FUNCTION Y(X) EVALUATED AT POINT S
C   USING THE CUBIC SPLINE COEFFICIENTS COMPUTED BY RSPLN AND SAVED IN
C   Q.  IF S IS OUTSIDE THE INTERVAL (X(I1),X(I2)) RSPLE EXTRAPOLATES
C   USING THE FIRST OR LAST INTERPOLATION POLYNOMIAL.  THE ARRAYS MUST
C   BE DIMENSIONED AT LEAST - X(I2), Y(I2), AND Q(3,I2).
C
C                                                     -RPB
      DIMENSION X(1),Y(1),Q(3,1)
      DATA I/1/
      II=I2-1
C   GUARANTEE I WITHIN BOUNDS.
      I=MAX0(I,I1)
      I=MIN0(I,II)
C   SEE IF X IS INCREASING OR DECREASING.
      IF(X(I2)-X(I1))1,2,2
C   X IS DECREASING.  CHANGE I AS NECESSARY.
 1    IF(S-X(I))3,3,4
 4    I=I-1
      IF(I-I1)11,6,1
 3    IF(S-X(I+1))5,6,6
 5    I=I+1
      IF(I-II)3,6,7
C   X IS INCREASING.  CHANGE I AS NECESSARY.
 2    IF(S-X(I+1))8,8,9
 9    I=I+1
      IF(I-II)2,6,7
 8    IF(S-X(I))10,6,6
 10   I=I-1
      IF(I-I1)11,6,8
 7    I=II
      GO TO 6
 11   I=I1
C   CALCULATE RSPLE USING SPLINE COEFFICIENTS IN Y AND Q.
 6    H=S-X(I)
      RSPLE=Y(I)+H*(Q(1,I)+H*(Q(2,I)+H*Q(3,I)))
      RETURN
      END
 
      SUBROUTINE RSPLN(I1,I2,X,Y,Q,F)
C
C C$C$C$C$C$ CALLS ONLY LIBRARY ROUTINES C$C$C$C$C$
C
C   SUBROUTINE RSPLN COMPUTES CUBIC SPLINE INTERPOLATION COEFFICIENTS
C   FOR Y(X) BETWEEN GRID POINTS I1 AND I2 SAVING THEM IN Q.  THE
C   INTERPOLATION IS CONTINUOUS WITH CONTINUOUS FIRST AND SECOND
C   DERIVITIVES.  IT AGREES EXACTLY WITH Y AT GRID POINTS AND WITH THE
C   THREE POINT FIRST DERIVITIVES AT BOTH END POINTS (I1 AND I2).
C   X MUST BE MONOTONIC BUT IF TWO SUCCESSIVE VALUES OF X ARE EQUAL
C   A DISCONTINUITY IS ASSUMED AND SEPERATE INTERPOLATION IS DONE ON
C   EACH STRICTLY MONOTONIC SEGMENT.  THE ARRAYS MUST BE DIMENSIONED AT
C   LEAST - X(I2), Y(I2), Q(3,I2), AND F(3,I2).  F IS WORKING STORAGE
C   FOR RSPLN.
C                                                     -RPB
C
      DIMENSION X(1),Y(1),Q(3,1),F(3,1),YY(3)
      EQUIVALENCE (YY(1),Y0)
      DATA SMALL/1.E-5/,YY/0.,0.,0./
      J1=I1+1
      Y0=0.
C   BAIL OUT IF THERE ARE LESS THAN TWO POINTS TOTAL.
      IF(I2-I1)13,17,8
 8    A0=X(J1-1)
C   SEARCH FOR DISCONTINUITIES.
      DO 3 I=J1,I2
      B0=A0
      A0=X(I)
      IF(ABS((A0-B0)/AMAX1(A0,B0)).LT.SMALL) GO TO 4
 3    CONTINUE
 17   J1=J1-1
      J2=I2-2
      GO TO 5
 4    J1=J1-1
      J2=I-3
C   SEE IF THERE ARE ENOUGH POINTS TO INTERPOLATE (AT LEAST THREE).
 5    IF(J2+1-J1)9,10,11
C   ONLY TWO POINTS.  USE LINEAR INTERPOLATION.
 10   J2=J2+2
      Y0=(Y(J2)-Y(J1))/(X(J2)-X(J1))
      DO 15 J=1,3
      Q(J,J1)=YY(J)
 15   Q(J,J2)=YY(J)
      GO TO 12
C   MORE THAN TWO POINTS.  DO SPLINE INTERPOLATION.
 11   A0=0.
      H=X(J1+1)-X(J1)
      H2=X(J1+2)-X(J1)
      Y0=H*H2*(H2-H)
      H=H*H
      H2=H2*H2
C   CALCULATE DERIVITIVE AT NEAR END.
      B0=(Y(J1)*(H-H2)+Y(J1+1)*H2-Y(J1+2)*H)/Y0
      B1=B0
C   EXPLICITLY REDUCE BANDED MATRIX TO AN UPPER BANDED MATRIX.
      DO 1 I=J1,J2
      H=X(I+1)-X(I)
      Y0=Y(I+1)-Y(I)
      H2=H*H
      HA=H-A0
      H2A=H-2.*A0
      H3A=2.*H-3.*A0
      H2B=H2*B0
      Q(1,I)=H2/HA
      Q(2,I)=-HA/(H2A*H2)
      Q(3,I)=-H*H2A/H3A
      F(1,I)=(Y0-H*B0)/(H*HA)
      F(2,I)=(H2B-Y0*(2.*H-A0))/(H*H2*H2A)
      F(3,I)=-(H2B-3.*Y0*HA)/(H*H3A)
      A0=Q(3,I)
 1    B0=F(3,I)
C   TAKE CARE OF LAST TWO ROWS.
      I=J2+1
      H=X(I+1)-X(I)
      Y0=Y(I+1)-Y(I)
      H2=H*H
      HA=H-A0
      H2A=H*HA
      H2B=H2*B0-Y0*(2.*H-A0)
      Q(1,I)=H2/HA
      F(1,I)=(Y0-H*B0)/H2A
      HA=X(J2)-X(I+1)
      Y0=-H*HA*(HA+H)
      HA=HA*HA
C   CALCULATE DERIVITIVE AT FAR END.
      Y0=(Y(I+1)*(H2-HA)+Y(I)*HA-Y(J2)*H2)/Y0
      Q(3,I)=(Y0*H2A+H2B)/(H*H2*(H-2.*A0))
      Q(2,I)=F(1,I)-Q(1,I)*Q(3,I)
C   SOLVE UPPER BANDED MATRIX BY REVERSE ITERATION.
      DO 2 J=J1,J2
      K=I-1
      Q(1,I)=F(3,K)-Q(3,K)*Q(2,I)
      Q(3,K)=F(2,K)-Q(2,K)*Q(1,I)
      Q(2,K)=F(1,K)-Q(1,K)*Q(3,K)
 2    I=K
      Q(1,I)=B1
C   FILL IN THE LAST POINT WITH A LINEAR EXTRAPOLATION.
 9    J2=J2+2
      DO 14 J=1,3
 14   Q(J,J2)=YY(J)
C   SEE IF THIS DISCONTINUITY IS THE LAST.
 12   IF(J2-I2)6,13,13
C   NO.  GO BACK FOR MORE.
 6    J1=J2+2
      IF(J1-I2)8,8,7
C   THERE IS ONLY ONE POINT LEFT AFTER THE LATEST DISCONTINUITY.
 7    DO 16 J=1,3
 16   Q(J,I2)=YY(J)
C   FINI.
 13   RETURN
      END
 
      SUBROUTINE SPINT(R,F,I1,I2,A,WORK,IWORK)
C
C    SPLINT DOES QUADRATURE ON A SPLINE FITTED INTEGRAND.
C
      DIMENSION F(1),R(1),WORK(3,1)
      DATA T/.333333333333333333/
      IF(IWORK.LT.6*(I2-I1+1)) PAUSE 'INSUFFICIENT WORK SPACE IN SPLINT'
      CALL RSPLN(I1,I2,R,F,WORK,WORK(1,I2-I1+2))
      A=0.D0
      DO 20 I=I1,I2-1
      B=R(I+1)-R(I)
      A=A+B*(F(I)+B*(.5D0*WORK(1,I)+B*(T*WORK(2,I)+.25D0*B*WORK(3,I))))
   20 CONTINUE
      RETURN
      END
 
      SUBROUTINE TRNSLT(IBUFF,NWORDS,IFASCI)
      DIMENSION IBUFF(1),IASC(250),IEBCD(95)
      DATA IASC(64)/32/
      DATA (IASC(I),I=74,79)/91,46,60,40,43,33/
      DATA IASC(80)/38/
      DATA (IASC(I),I=90,97)/93,36,42,41,59,94,45,47/
      DATA (IASC(I),I=107,111)/44,37,45,62,63/
      DATA (IASC(I),I=122,127)/58,35,64,39,61,34/
      DATA (IASC(I),I=193,201)/65,66,67,68,69,70,71,72,73/
      DATA (IASC(I),I=209,217)/74,75,76,77,78,79,80,81,82/
      DATA (IASC(I),I=226,233)/83,84,85,86,87,88,89,90/
      DATA (IASC(I),I=240,249)/48,49,50,51,52,53,54,55,56,57/
      DATA (IEBCD(I),I=32,47)/64,79,127,123,91,108,80,125,77,93,92,78,
     1107,96,75,97/
      DATA (IEBCD(I),I=48,57)/240,241,242,243,244,245,246,247,248,249/
      DATA (IEBCD(I),I=58,64)/122,94,76,126,110,111,124/
      DATA (IEBCD(I),I=65,90)/193,194,195,196,197,198,199,200,201,209,
     1210,211,212,213,214,215,216,217,226,227,228,229,230,231,232,233/
      DATA (IEBCD(I),I=91,95)/74,97,90,95,109/
      NCHAR=NWORDS*4
      IF(IFASCI.GT.0)GO TO 3
      DO 1 J=1,NCHAR
      CALL ILBYTE(K,IBUFF,J-1)
      K=IASC(K)
    1 CALL ISBYTE(K,IBUFF,J-1)
      RETURN
    3 DO 2 J=1,NCHAR
      CALL ILBYTE(K,IBUFF,J-1)
      IF(K.LT.32.OR.K.GT.95)K=32
      K=IEBCD(K)
    2 CALL ISBYTE(K,IBUFF,J-1)
      RETURN
      END
