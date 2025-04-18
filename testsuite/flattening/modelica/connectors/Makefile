TEST=../../../rtest -v

TESTFILES=\
Bug3649.mos \
Connect1.mo \
Connect2.mo \
Connect4.mo \
Connect5.mo \
Connect6.mo \
Connect7.mo \
Connect8.mo \
Connect9.mo \
Connect12.mo \
Connect13.mo \
Connect14.mo \
Connect15.mo \
Connect16.mo \
Connect17.mo \
Connect18.mo \
ConnectArray1.mo \
ConnectArrayCond.mo \
ConnectEnumArray.mo \
ConnectFlowEffort.mo \
ConnectFlowEffort2.mo\
ConnectHierarchical1.mo \
ConnectHierarchical2.mo \
ConnectInner1.mo \
ConnectInner2.mo \
ConnectInner3.mo \
ConnectInnerOuter.mo \
ConnectInnerOuter2.mo \
ConnectInnerOuter3.mo \
ConnectInnerOuter4.mo \
ConnectInnerOuterArray1.mo \
ConnectionOrder1.mo \
ConnectionOrder2.mo \
ConnectParamArray.mo \
ConnectorBalance1.mo \
ConnectorBalance2.mo \
ConnectorBalance3.mo \
ConnectorBalance4.mo \
ConnectorBalance5.mo \
ConnectorBalance6.mo \
ConnectorBalance7.mo \
ConnectorBalance8.mos \
ConnectorBalance9.mo \
ConnectorComponents.mo \
ConnectorCompOrder.mo \
ConnectorIllegal.mo \
ConnectorIllegal2.mo \
ConnectorInheritance1.mo \
ConnectorSimple.mo \
ConnectorSubtypeComp.mo \
ConnectTheSameConnector.mo \
ConnectTwoSources.mo \
ConnectTypes.mo \
EnumArrayConnector.mo \
EqualityConstraintLookup1.mo \
HeatTank.mo \
HeatTankExpanded.mo \
InitialConnection.mo \
MultipleInheritanceConnect.mo \
Tank.mo \
TankHybridPI.mo \
TankHybridPID.mo \
TankPI.mo \
TankPID.mo \
TanksConnectedPI.mo \
Ticket4062.mo \
TypeConnector.mo \
Units2.mo \
ZeroDimUnconnectedFlow1.mo \
ZeroDimUnconnectedFlow2.mo \
CGraphBug.mos \


# test that currently fail. Move up when fixed.
# Run make testfailing
FAILINGTESTFILES=\
Connect3.mo \
Connect10.mo \
Connect11.mo \
ConnectArrayCond2.mo \
ConnectConst1.mo \
ConnectForEquations.mo \
Units1.mo

# Dependency files that are not .mo .mos or Makefile
# Add them here or they will be cleaned.
DEPENDENCIES = \
*.mo \
*.mos \
Makefile

CLEAN = `ls | grep -w -v -f deps.tmp`

DOCFILES=modtest.texi cases.texi VERSION.texi
DISTFILES=$(TESTFILES) VERSION modtest.texi \
	Makefile rtest cases.texi index.html
HTMLFILE=modtest_toc.html

TEXI2DVI=texi2dvi
TEXI2HTML=texi2html -split_chapte
MAKEINFO=makeinfo

VERSION = $(shell cat VERSION)

.PHONY : default
default : modtest.info modtest.ps $(HTMLFILE)

.PHONY : test failingtest clean getdeps
test :
	@echo
	@echo Running tests:
	@echo
	@$(TEST) $(TESTFILES)

# Cleans all files that are not listed as dependencies
clean :
	@echo $(DEPENDENCIES) | sed 's/ /\\|/g' > deps.tmp
	@rm -f $(CLEAN)

# Run this if you want to list out the files (dependencies).
# do it after cleaning and updating the folder
# then you can get a list of file names (which must be dependencies
# since you got them from repository + your own new files)
# then add them to the DEPENDENCIES. You can find the
# list in deps.txt
getdeps:
	@echo $(DEPENDENCIES) | sed 's/ /\\|/g' > deps.tmp
	@echo $(CLEAN) | sed -r 's/deps.txt|deps.tmp//g' | sed 's/ / \\\n/g' > deps.txt
	@echo Dependency list saved in deps.txt.
	@echo Copy the list from deps.txt and add it to the Makefile @DEPENDENCIES

failingtest :
	@echo
	@echo Running failing tests:
	@echo
	@$(TEST) $(FAILINGTESTFILES)

keywords :
	$(TEST) -l $(TESTFILES)

modtest.dvi : $(DOCFILES)
	$(TEXI2DVI) $<

modtest.ps : modtest.dvi
	dvips -o $@ $<

modtest.info : $(DOCFILES)
	$(MAKEINFO) $<

$(HTMLFILE) : $(DOCFILES)
	$(TEXI2HTML) $<

cases.texi : $(TESTFILES)
	$(RM) $@
	cases=`$(TEST) -L $(TESTFILES) | sort`; \
	echo "@menu" >> $@; \
	for c in $$cases; do echo "* $$c::" >> $@; done; \
	echo "@end menu" >> $@; \
	set "Test Cases" $$cases ""; \
	while [ "$$2" != "" ] ; do \
		echo ""                 	    >> $@; \
		echo "@node $$2,$$3,$$1,Test Cases" >> $@; \
		echo "@appendixsec $$2" 	    >> $@; \
		echo "@example"         	    >> $@; \
		echo "@include $$2.mo"  	    >> $@; \
		echo "@end example"     	    >> $@; \
		shift ; \
	done

VERSION.texi : VERSION
	sed -e 's/^\(.*\)$$/@set VERSION \1/' < $< > $@

.PHONY : dist
dist : $(DISTFILES)
	mkdir modtest-$(VERSION)
	cp $(DISTFILES) modtest-$(VERSION)
	tar cvf modtest-$(VERSION).tar modtest-$(VERSION)
	gzip -9 modtest-$(VERSION).tar
	$(RM) -r modtest-$(VERSION)
