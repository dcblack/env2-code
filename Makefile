#!/bin/make -f

TOOL_NAME=env2
EXE=./$(TOOL_NAME)
INSTALL_DIR=/eda/hldw/bin
MANPAGE_DIR=/eda/hldw/man/manl

.PHONY: default test perms test0 test1 test2 test3 test4 test5 test6 test7 test8 test9 test10 test11 test12

default: test

test: perms test0 test1 test2 test3 test4 test5 test6 test7 test9 test10 test11 test12

HEADING=header -uc $@

perms :
	chmod a+rx $(EXE)
test0 :
	@$(HEADING)
	$(EXE) --save
test1 :
	@$(HEADING)
	file script1
	$(EXE) -o out1.sh script1
test2 :
	@$(HEADING)
	file script2
	$(EXE) -o - script2 | tee out2.bash
test3 :
	@$(HEADING)
	file script3
	env TOOL_SETUP=./script3 $(EXE) -from csh -to modulecmd -o out3.modules script3
test4 :
	@$(HEADING)
	file script4
	$(EXE) -from sh -to csh  -o out4.csh script4
test5 :
	@$(HEADING)
	file script5
	$(EXE) -to lua  -o out5.lua script5
test6 :
	@$(HEADING)
	file script6
	env OLDVAR=bad $(EXE) -to ksh  -o out6.ksh script6
test7 :
	@$(HEADING)
	file script7
	$(EXE) -from yaml -to tcl  -o out7.tcl script7
test8 :
	@$(HEADING)
	file script8
	$(EXE) -from lua -to bash -o out8.ksh script8
test9 :
	@$(HEADING)
	file script9
	$(EXE) -to zsh  -o out9.all script9
test10 :
	@$(HEADING)
	file script10
	cat script10 | $(EXE) -all -to perl -o out10.perl -
test11 :
	@$(HEADING)
	$(EXE) -all -only USER,HOST -to sh   -o out11.sh
test12 :
	@$(HEADING)
	file script12
	$(EXE) -from sh -to csh  -o out12.csh script12

install :
	@$(HEADING)
	$(EXE) --INSTALL
	rsync -auvP $(EXE) $(INSTALL_DIR)/
	pod2man $(EXE) >$(MANPAGE_DIR)/$(EXE)

#TAF!
