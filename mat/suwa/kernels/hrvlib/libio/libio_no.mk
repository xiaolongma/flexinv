# Note: no optimization of the c routines (at this time
# csubs is the only c code). The lockf function called by
# clockf does not seem to work properly when optimization
# is used.                    b.w. 10/90
#
# moved this library to hrvsrc -- new compilation flags for new
# FORTRAN compiler (-O3 -cg89 -libmil). g.e. 2/91
#
# added the modules chekli and getli from libdb to avoid cross-
# references (g.e. 02/17/91)
#   FFLAGS = $(FFLAG)
FFLAGS =
LIB =libio_no

.f.a:
	f77 $(FFLAGS) -c -e -Nl100   $<
	ar rv $@ $*.o
	rm -f $*.o

.c.a:
	cc $(FFLAGS) -c $<
	ar rv $@ $*.o
	rm -f $*.o

$(LIB): $(HRVLIB)/$(LIB).a

$(HRVLIB)/$(LIB).a: \
	$(HRVLIB)/$(LIB).a(lockfl.o) \
	$(HRVLIB)/$(LIB).a(charmap.o) \
	$(HRVLIB)/$(LIB).a(import.o) \
	$(HRVLIB)/$(LIB).a(fldg.o) \
	$(HRVLIB)/$(LIB).a(dfldg.o) \
	$(HRVLIB)/$(LIB).a(rcreat.o) \
	$(HRVLIB)/$(LIB).a(rcreao.o) \
	$(HRVLIB)/$(LIB).a(ftimes.o) \
	$(HRVLIB)/$(LIB).a(adnul.o) \
	$(HRVLIB)/$(LIB).a(backfl.o) \
	$(HRVLIB)/$(LIB).a(backsp.o) \
	$(HRVLIB)/$(LIB).a(bffi.o) \
	$(HRVLIB)/$(LIB).a(bffin.o) \
	$(HRVLIB)/$(LIB).a(bffis.o) \
	$(HRVLIB)/$(LIB).a(bffo.o) \
	$(HRVLIB)/$(LIB).a(bffos.o) \
	$(HRVLIB)/$(LIB).a(bffout.o) \
	$(HRVLIB)/$(LIB).a(check.o) \
	$(HRVLIB)/$(LIB).a(chekcl.o) \
	$(HRVLIB)/$(LIB).a(chekgl.o) \
	$(HRVLIB)/$(LIB).a(closfl.o) \
	$(HRVLIB)/$(LIB).a(endfl.o) \
	$(HRVLIB)/$(LIB).a(fillu.o) \
	$(HRVLIB)/$(LIB).a(fstat.o) \
	$(HRVLIB)/$(LIB).a(fstatn.o) \
	$(HRVLIB)/$(LIB).a(getflpos.o) \
	$(HRVLIB)/$(LIB).a(inunx.o) \
	$(HRVLIB)/$(LIB).a(istlen.o) \
	$(HRVLIB)/$(LIB).a(getunx.o) \
	$(HRVLIB)/$(LIB).a(getgnl.o) \
	$(HRVLIB)/$(LIB).a(getli.o) \
	$(HRVLIB)/$(LIB).a(chekli.o) \
	$(HRVLIB)/$(LIB).a(lenfl.o) \
	$(HRVLIB)/$(LIB).a(lenlu.o) \
	$(HRVLIB)/$(LIB).a(lower.o) \
	$(HRVLIB)/$(LIB).a(lufil.o) \
	$(HRVLIB)/$(LIB).a(openti.o) \
	$(HRVLIB)/$(LIB).a(openfl.o) \
	$(HRVLIB)/$(LIB).a(openw.o) \
	$(HRVLIB)/$(LIB).a(opnfil.o) \
	$(HRVLIB)/$(LIB).a(openfc.o) \
	$(HRVLIB)/$(LIB).a(opnflc.o) \
	$(HRVLIB)/$(LIB).a(glink.o) \
	$(HRVLIB)/$(LIB).a(glinkd.o) \
	$(HRVLIB)/$(LIB).a(rewfl.o) \
	$(HRVLIB)/$(LIB).a(rewtp.o) \
	$(HRVLIB)/$(LIB).a(skipfl.o) \
	$(HRVLIB)/$(LIB).a(upper.o) \
	$(HRVLIB)/$(LIB).a(ilbyte.o) \
	$(HRVLIB)/$(LIB).a(isbyte.o) \
	$(HRVLIB)/$(LIB).a(wait.o) \
	$(HRVLIB)/$(LIB).a(error.o) \
	$(HRVLIB)/$(LIB).a(getsafdir.o) \
	$(HRVLIB)/$(LIB).a(getolinkdir.o) \
	$(HRVLIB)/$(LIB).a(getotapedir.o) \
	$(HRVLIB)/$(LIB).a(getjukehost.o) \
	$(HRVLIB)/$(LIB).a(csubs_2_5.o) \
	$(HRVLIB)/$(LIB).a(oasopenserial.o) \
	$(HRVLIB)/$(LIB).a(oasgetdrive.o) \
	$(HRVLIB)/$(LIB).a(oasmountdrive.o) \
	$(HRVLIB)/$(LIB).a(oasmountdrivec.o) \
	$(HRVLIB)/$(LIB).a(oasopendrive.o) \
	$(HRVLIB)/$(LIB).a(oascheckdrive.o) \
	$(HRVLIB)/$(LIB).a(oasflushserial.o) \
	$(HRVLIB)/$(LIB).a(oassend.o) \
	$(HRVLIB)/$(LIB).a(oasstrip.o) \
	$(HRVLIB)/$(LIB).a(oascloseserial.o) \
	$(HRVLIB)/$(LIB).a(oaswait.o) \
	$(HRVLIB)/$(LIB).a(oasverbose.o) \
	$(HRVLIB)/$(LIB).a(oasnam.o)

$(HRVLIB)/$(LIB).a(backfl.o): openfile.h 
$(HRVLIB)/$(LIB).a(backsp.o): openfile.h 
$(HRVLIB)/$(LIB).a(bffi.o): openfile.h 
$(HRVLIB)/$(LIB).a(bffis.o): openfile.h 
$(HRVLIB)/$(LIB).a(bffo.o): openfile.h 
$(HRVLIB)/$(LIB).a(bffos.o): openfile.h
$(HRVLIB)/$(LIB).a(chekcl.o): getgnl.h getunx.h
$(HRVLIB)/$(LIB).a(chekgl.o): getgnl.h
$(HRVLIB)/$(LIB).a(chekli.o): getgnl.h getli.h
$(HRVLIB)/$(LIB).a(closfl.o): openfile.h 
$(HRVLIB)/$(LIB).a(endfl.o): openfile.h
$(HRVLIB)/$(LIB).a(fillu.o): openfile.h 
$(HRVLIB)/$(LIB).a(fstat.o): openfile.h 
$(HRVLIB)/$(LIB).a(fstatn.o): openfile.h 
$(HRVLIB)/$(LIB).a(getflpos.o): openfile.h 
$(HRVLIB)/$(LIB).a(getli.o): getgnl.h getli.h 
$(HRVLIB)/$(LIB).a(getunx.o): getgnl.h getunx.h 
$(HRVLIB)/$(LIB).a(getgnl.o): getgnl.h 
$(HRVLIB)/$(LIB).a(getsafdir.o): safdir.h
$(HRVLIB)/$(LIB).a(lenfl.o): openfile.h 
$(HRVLIB)/$(LIB).a(lenlu.o): openfile.h 
$(HRVLIB)/$(LIB).a(lockfl.o): openfile.h 
$(HRVLIB)/$(LIB).a(lufil.o): openfile.h 
$(HRVLIB)/$(LIB).a(opnfil.o): openfile.h 
$(HRVLIB)/$(LIB).a(rewfl.o): openfile.h 
$(HRVLIB)/$(LIB).a(rewtp.o): openfile.h 
$(HRVLIB)/$(LIB).a(skipfl.o): openfile.h 
$(HRVLIB)/$(LIB).a(opnflc.o): oasstatus.h openfile.h
$(HRVLIB)/$(LIB).a(oasopenserial.o): oasstatus.h
$(HRVLIB)/$(LIB).a(oasgetdrive.o): oasstatus.h
$(HRVLIB)/$(LIB).a(oasmountdrive.o): oasstatus.h
$(HRVLIB)/$(LIB).a(oasmountdrivec.o): oasstatus.h
$(HRVLIB)/$(LIB).a(oasopendrive.o): oasstatus.h
$(HRVLIB)/$(LIB).a(oascheckdrive.o): oasstatus.h
$(HRVLIB)/$(LIB).a(oasflushserial.o): oasstatus.h
$(HRVLIB)/$(LIB).a(oassend.o): oasstatus.h
$(HRVLIB)/$(LIB).a(oascloseserial.o): oasstatus.h 
$(HRVLIB)/$(LIB).a(oaswait.o): oasstatus.h 
$(HRVLIB)/$(LIB).a(oasverbose.o): oasstatus.h 
