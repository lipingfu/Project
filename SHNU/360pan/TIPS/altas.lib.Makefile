LIBTOOL=/usr/bin/libtool
DESTDIR=/Users/zyhuang/develop/local
INCINSTdir=$(DESTDIR)/include
LIBINSTdir=$(DESTDIR)/lib
shared_all :
	$(MAKE) dylib
	- $(MAKE) ptdylib
include Make.inc
LD = ld
mySRCdir = $(SRCdir)/lib
#
# override with libatlas.so only when atlas is built to one lib
#
DYNlibs = liblapack.so libf77blas.so libcblas.so libatlas.so 
PTDYNlibs = liblapack.so libptf77blas.so libptcblas.so libatlas.so 
CDYNlibs = liblapack.so libcblas.so libatlas.so 
CPTDYNlibs = liblapack.so libptcblas.so libatlas.so 

VER=3.9.72
tmpd = RCW_tMp
tarnam = atlas$(VER)_$(ARCH)
tar : tarfile
tarfile : $(tarnam).tgz
$(tarnam).tgz :
	mkdir $(ARCH)
	cd $(ARCH) ; mkdir include lib
	cp $(TOPdir)/doc/LibReadme.txt $(ARCH)/README
	cp $(TOPdir)/Make.$(ARCH) $(ARCH)/.
	cp $(BINdir)/INSTALL_LOG/SUMMARY.LOG $(ARCH)/.
	cp $(INCSdir)/cblas.h $(ARCH)/include/.
	cp $(INCSdir)/clapack.h $(ARCH)/include/.
	cp $(LIBdir)/libatlas.a $(ARCH)/lib/.
	cp $(LIBdir)/libf77blas.a $(ARCH)/lib/.
	cp $(LIBdir)/libcblas.a $(ARCH)/lib/.
	cp $(LIBdir)/liblapack.a $(ARCH)/lib/.
	- cp $(LIBdir)/libptcblas.a $(ARCH)/lib/.
	- cp $(LIBdir)/libptf77blas.a $(ARCH)/lib/.
	$(TAR) cf $(tarnam).tar $(ARCH)
	rm -rf $(ARCH)
	$(GZIP) --best $(tarnam).tar
	mv $(tarnam).tar.gz $(tarnam).tgz

# ===================================================================
# The following commands are to build dynamic/shared objects on Linux
# using the gnu gcc or ld
# ===================================================================
ptshared: fat_ptshared
shared : fat_shared
cptshared : fat_cptshared
cshared : fat_cshared

#
# These are a bunch of different ways to attempt to build a .so, try them all
#
LDTRY:
	$(LD) $(LDFLAGS) -shared -soname $(LIBINSTdir)/$(outso) -o $(outso) \
           -rpath-link $(LIBINSTdir) \
           --whole-archive $(libas) --no-whole-archive $(LIBS)
GCCTRY:
	$(GOODGCC) -shared -o $(outso) -Wl,"rpath-link $(LIBINSTdir)" \
           -Wl,--whole-archive $(libas) -Wl,--no-whole-archive $(LIBS)
#
# TRYALL is going to just try a bunch of library combinations that may work
# on gnu platforms, hopefully one does.  It also tests doing the link by
# LD or gcc; some places don't use the gnu LD command, but gcc may still work
#
TRYALL :
	if $(MAKE) GCCTRY outso="$(outso)" libas="$(libas)" \
        LIBS="$(F77SYSLIB) -lc $(LIBS) -lgcc" LIBINSTdir="$(LIBINSTdir)"; then \
           echo "$(outso) built wt gcc and all libs" ; \
        elif $(MAKE) LDTRY outso="$(outso)" libas="$(libas)" \
        LIBS="$(F77SYSLIB) -lc $(LIBS) -lgcc" LIBINSTdir="$(LIBINSTdir)"; then \
           echo "$(outso) built wt ld and all sys libs" ; \
        elif $(MAKE) GCCTRY outso="$(outso)" libas="$(libas)" \
        LIBS="-lc $(LIBS) -lgcc" LIBINSTdir="$(LIBINSTdir)"; then \
           echo "$(outso) built wt gcc and all C libs" ; \
        elif $(MAKE) LDTRY outso="$(outso)" libas="$(libas)" \
        LIBS="-lc $(LIBS) -lgcc" LIBINSTdir="$(LIBINSTdir)"; then \
           echo "$(outso) built wt ld and -lc -lgcc" ; \
        elif $(MAKE) GCCTRY outso="$(outso)" libas="$(libas)" \
        LIBS="$(F77SYSLIB) -lc $(LIBS)" LIBINSTdir="$(LIBINSTdir)"; then \
           echo "$(outso) built wt gcc and all libs except -lgcc" ; \
        elif $(MAKE) LDTRY outso="$(outso)" libas="$(libas)" \
        LIBS="$(F77SYSLIB) -lc $(LIBS)" LIBINSTdir="$(LIBINSTdir)"; then \
           echo "$(outso) built wt all libs except -lgcc" ; \
        elif $(MAKE) GCCTRY outso="$(outso)" libas="$(libas)" \
        LIBS="-lc $(LIBS)" LIBINSTdir="$(LIBINSTdir)"; then \
           echo "$(outso) built wt gcc and -lc" ; \
        elif $(MAKE) LDTRY outso="$(outso)" libas="$(libas)" \
        LIBS="-lc $(LIBS)" LIBINSTdir="$(LIBINSTdir)"; then \
           echo "$(outso) built wt ld and -lc" ; \
        elif $(MAKE) LDTRY outso="$(outso)" libas="$(libas)" \
        LIBS="$(LIBS)" LIBINSTdir="$(LIBINSTdir)"; then \
           echo "$(outso) built wt ld" ; \
        else \
           $(MAKE) GCCTRY outso="$(outso)" libas="$(libas)" \
           LIBS="$(LIBS)" LIBINSTdir="$(LIBINSTdir)" ; \
        fi

#
# Builds one shared lib from all ATLAS files
#
fat_ptshared :                              # threaded target
	$(MAKE) TRYALL outso=libtatlas.so \
                libas="libptlapack.a libptf77blas.a libptcblas.a libatlas.a" \
                LIBINSTdir="$(LIBINSTdir)"
fat_shared :                                # serial target
	$(MAKE) TRYALL outso=libsatlas.so \
                libas="liblapack.a libf77blas.a libcblas.a libatlas.a" \
                LIBINSTdir="$(LIBINSTdir)"
#
# Builds shared lib, not include fortran codes from LAPACK
#
fat_cptshared : libptclapack.a              # threaded target
	$(MAKE) TRYALL outso=libtatlas.so \
                libas="libptclapack.a libptcblas.a libatlas.a" \
                LIBINSTdir="$(LIBINSTdir)"
fat_cshared : libclapack.a                  # unthreaded target
	$(MAKE) TRYALL outso=libsatlas.so \
                libas="libclapack.a libcblas.a libatlas.a" \
                LIBINSTdir="$(LIBINSTdir)"

libclapack.a : liblapack.a
	rm -rf clapack libclapack.a
	mkdir clapack
	cd clapack ; ar x ../liblapack.a
	rm -f clapack/*f77wrap* clapack/*C2F*
	ar r libclapack.a clapack/ATL_* clapack/clapack_*
	rm -rf clapack
libptclapack.a : libptlapack.a
	rm -rf clapack libptclapack.a
	mkdir clapack
	cd clapack ; ar x ../libptlapack.a
	rm -f clapack/*f77wrap* clapack/*C2F*
	ar r libptclapack.a clapack/ATL_* clapack/clapack_*
	rm -rf clapack

#  ============================================
#  The following commands build DLLs on Windows
#  ============================================
dlls: tdlls sdlls
tdlls:                          # threaded target
	$(MAKE) TRYALL outso=libtatlas.dll \
                libas="libptlapack.a libptf77blas.a libptcblas.a libatlas.a" \
                LIBINSTdir="$(LIBINSTdir)"
sdlls:                          # serial target
	$(MAKE) TRYALL outso=libsatlas.dll \
                libas="liblapack.a libf77blas.a libcblas.a libatlas.a" \
                LIBINSTdir="$(LIBINSTdir)"
cdlls: ctdlls csdlls
ctdlls: libptclapack.a          # threaded target
	$(MAKE) TRYALL outso=libtatlas.dll \
                libas="libptclapack.a libptcblas.a libatlas.a" \
                LIBINSTdir="$(LIBINSTdir)"
csdlls: libclapack.a            # serial target
	$(MAKE) TRYALL outso=libsatlas.dll \
                libas="libclapack.a libcblas.a libatlas.a" \
                LIBINSTdir="$(LIBINSTdir)"

#  =======================================================================
#  The following commands are to build dynamib libraries on OS X (in BETA)
#  =======================================================================
dylib :
	rm -rf $(tmpd) ; mkdir $(tmpd)
	cd $(tmpd) ; ar x ../liblapack.a 
	cd $(tmpd) ; ar x ../libf77blas.a
	cd $(tmpd) ; ar x ../libcblas.a 
	cd $(tmpd) ; ar x ../libatlas.a
	cd $(tmpd) ; $(LIBTOOL) -dynamic -o ../libsatlas.dylib \
        -install_name $(LIBINSTdir)/libsatlas.dylib -current_version $(VER) \
        -compatibility_version $(VER) *.o $(LIBS) $(F77SYSLIB)
	rm -rf $(tmpd)
ptdylib :
	rm -rf $(tmpd) ; mkdir $(tmpd)
	cd $(tmpd) ; ar x ../libptlapack.a 
	cd $(tmpd) ; ar x ../libptf77blas.a 
	cd $(tmpd) ; ar x ../libptcblas.a 
	cd $(tmpd) ; ar x ../libatlas.a
	cd $(tmpd) ; $(LIBTOOL) -dynamic -o ../libtatlas.dylib \
        -install_name $(LIBINSTdir)/libtatlas.dylib -current_version $(VER) \
        -compatibility_version $(VER) *.o $(LIBS) $(F77SYSLIB)
	rm -rf $(tmpd)
cdylib : libclapack.a
	rm -rf $(tmpd) ; mkdir $(tmpd)
	cd $(tmpd) ; ar x ../libclapack.a 
	cd $(tmpd) ; ar x ../libcblas.a 
	cd $(tmpd) ; ar x ../libatlas.a
	cd $(tmpd) ; $(LIBTOOL) -dynamic -o ../libsatlas.dylib \
        -install_name $(LIBINSTdir)/libsatlas.dylib -current_version $(VER) \
        -compatibility_version $(VER) *.o $(LIBS)
	rm -rf $(tmpd)
ptcdylib : libptclapack.a
	rm -rf $(tmpd) ; mkdir $(tmpd)
	cd $(tmpd) ; ar x ../libptclapack.a
	cd $(tmpd) ; ar x ../libptcblas.a 
	cd $(tmpd) ; ar x ../libatlas.a
	cd $(tmpd) ; $(LIBTOOL) -dynamic -o ../libtatlas.dylib \
        -install_name $(LIBINSTdir)/libtatlas.dylib -current_version $(VER) \
        -compatibility_version $(VER) *.o $(LIBS)
	rm -rf $(tmpd)

# libclapack.dylib : libcblas.dylib libatlas.dylib liblapack.a
# 	rm -rf $(tmpd) ; mkdir $(tmpd)
# 	cd $(tmpd) ; ar x ../liblapack.a
# 	rm -f $(tmpd)/*C2F $(tmpd)/*f77wrap*
# 	cd $(tmpd) ; libtool -dynamic -o ../libclapack.dylib \
#            -install_name $(LIBINSTdir)/libclapack.dylib \
#            -compatibility_version $(VER) -current_version $(VER) \
#            *.o ../libcblas.dylib ../libatlas.dylib $(LIBS)
# 	rm -rf $(tmpd)

################################################################################

libatlas.dylib : libatlas.a
	rm -rf $(tmpd) ; mkdir $(tmpd)
	cd $(tmpd) ; ar x ../libatlas.a
	rm -f $(tmpd)ATL_[z,c,d,s]ref*.o
	cd $(tmpd) ; $(LIBTOOL) -dynamic -o ../libatlas.dylib \
        -install_name $(LIBINSTdir)/libatlas.dylib -current_version $(VER) \
        -compatibility_version $(VER) *.o $(LIBS)
	rm -rf $(tmpd)
libptcblas.dylib : libatlas.dylib libptcblas.a
	rm -rf $(tmpd) ; mkdir $(tmpd)
	cd $(tmpd) ; ar x ../libptcblas.a
	cd $(tmpd) ; $(LIBTOOL) -dynamic -o ../libptcblas.dylib \
           -install_name $(LIBINSTdir)/libptcblas.dylib \
           -compatibility_version $(VER) -current_version $(VER) \
           *.o ../libatlas.dylib $(LIBS)
	rm -rf $(tmpd)
libcblas.dylib : libatlas.dylib libcblas.a
	rm -rf $(tmpd) ; mkdir $(tmpd)
	cd $(tmpd) ; ar x ../libcblas.a
	cd $(tmpd) ; $(LIBTOOL) -dynamic -o ../libcblas.dylib \
           -install_name $(LIBINSTdir)/libcblas.dylib \
           -compatibility_version $(VER) -current_version $(VER) \
           *.o ../libatlas.dylib $(LIBS)
	rm -rf $(tmpd)
libptf77blas.dylib : libatlas.dylib libptf77blas.a
	rm -rf $(tmpd) ; mkdir $(tmpd)
	cd $(tmpd) ; ar x ../libptf77blas.a
	cd $(tmpd) ; $(LIBTOOL) -dynamic -o ../libptf77blas.dylib \
           -install_name $(LIBINSTdir)/libptf77blas.dylib \
           -compatibility_version $(VER) -current_version $(VER) \
           *.o ../libatlas.dylib $(F77SYSLIB) $(LIBS)
	rm -rf $(tmpd)
libf77blas.dylib : libatlas.dylib libf77blas.a
	rm -rf $(tmpd) ; mkdir $(tmpd)
	cd $(tmpd) ; ar x ../libf77blas.a
	cd $(tmpd) ; libtool -dynamic -o ../libf77blas.dylib \
           -install_name $(LIBINSTdir)/libf77blas.dylib \
           -compatibility_version 3.9.32 -current_version 3.9.32 \
           *.o ../libatlas.dylib $(F77SYSLIB) $(LIBS)
	rm -rf $(tmpd)
liblapack.dylib : libf77blas.dylib libcblas.dylib libatlas.dylib liblapack.a
	rm -rf $(tmpd) ; mkdir $(tmpd)
	cd $(tmpd) ; ar x ../liblapack.a
	cd $(tmpd) ; libtool -dynamic -o ../liblapack.dylib \
           -install_name $(LIBINSTdir)/liblapack.dylib \
           -compatibility_version $(VER) -current_version $(VER) \
           *.o ../libf77blas.dylib ../libcblas.dylib ../libatlas.dylib \
           $(F77SYSLIB) $(LIBS)
	rm -rf $(tmpd)

# libclapack.dylib : libcblas.dylib libatlas.dylib liblapack.a
# 	rm -rf $(tmpd) ; mkdir $(tmpd)
# 	cd $(tmpd) ; ar x ../liblapack.a
# 	rm -f $(tmpd)/*C2F $(tmpd)/*f77wrap*
# 	cd $(tmpd) ; libtool -dynamic -o ../libclapack.dylib \
#            -install_name $(LIBINSTdir)/libclapack.dylib \
#            -compatibility_version $(VER) -current_version $(VER) \
#            *.o ../libcblas.dylib ../libatlas.dylib $(LIBS)
# 	rm -rf $(tmpd)

################################################################################

xtst_lp: $(DYNlibs)
	$(ICC) $(CDEFS) -o $@ $(mySRCdir)/qr.c $(DYNlibs) -Wl,--rpath ./
xtst : $(DYNlibs)
	$(ICC) $(CDEFS) -o $@ $(mySRCdir)/test_dynlink.c $(DYNlibs) \
           -Wl,--rpath ./

xtry_lp:
	$(ICC) $(CDEFS) -o $@ $(mySRCdir)/qr.c libsatlas.so -Wl,--rpath ./
xtry_lp_pt:
	$(ICC) $(CDEFS) -o $@ $(mySRCdir)/qr.c libtatlas.so -Wl,--rpath ./
xtry :
	$(ICC) $(CDEFS) -o $@ $(mySRCdir)/test_dynlink.c libsatlas.so \
           -Wl,--rpath ./
xtry_pt :
	$(ICC) $(CDEFS) -o $@ $(mySRCdir)/test_dynlink.c libtatlas.so \
           -Wl,--rpath ./
