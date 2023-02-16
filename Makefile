#!/bin/make -f

TOOL_NAME=env2
EXE=./${TOOL_NAME}
INSTALL_DIR=${HOME}/.local/bin
MANPAGE_DIR=${HOME}/.local/man/manl

P=${HOME}/.local/bin:${HOME}/bin:/usr/bin:/bin

.PHONY: default test perms test0 test1 test2 test3 test4 test5 test6 test7 test8 test9 test10 test11 test12

default: test

test: perms test0 test1 test2 test3 test4 test5 test6 test7 test9 test10 test11 test12 test13

HEADING=echo "[92m"$@: $1"[0m"

perms :
	chmod a+rx "${EXE}"
test0 :
	@$(call HEADING,Save environment)
	env PATH="$P" "${EXE}" --save
test1 :
	@$(call HEADING,Basic shell)
	file script1
	env PATH="$P" CURVAR="unmodified" OLDVAR="old" "${EXE}" -o $(subst test,out,$@).sh script1
test2 :
	@$(call HEADING,Inline bash)
	file script2
	env PATH="$P" "${EXE}" -o - script2 | tee $(subst test,out,$@).bash
test3 :
	@$(call HEADING,Csh to modulecmd)
	file script3
	env PATH="$P" env TOOL_SETUP=./script3 "${EXE}" -from csh -to modulecmd -o $(subst test,out,$@).modules script3
test4 :
	@$(call HEADING,ksh to csh)
	file script4
	env PATH="$P" "${EXE}" -from sh -to csh  -o $(subst test,out,$@).csh script4
test5 :
	@$(call HEADING,perl to lua)
	file script5
	env PATH="$P" "${EXE}" -to lua  -o $(subst test,out,$@).lua script5
test6 :
	@$(call HEADING,tcl to ksh)
	file script6
	env PATH="$P" OLDVAR=bad "${EXE}" -to ksh  -o $(subst test,out,$@).ksh script6
test7 :
	@$(call HEADING,yaml to tcl)
	file script7
	env PATH="$P" "${EXE}" -from yaml -to tcl  -o $(subst test,out,$@).tcl script7
test8 :
	@$(call HEADING,lua to bash)
	file script8
	env PATH="$P" "${EXE}" -from lua -to bash -o $(subst test,out,$@).ksh script8
test9 :
	@$(call HEADING,bash to zsh)
	file script9
	env PATH="$P" "${EXE}" -to zsh  -o $(subst test,out,$@).all script9
test10 :
	@$(call HEADING,pipe sh to perl)
	file script10
	cat script10 | env PATH="$P" "${EXE}" -all -to perl -o $(subst test,out,$@).perl -
test11 :
	@$(call HEADING,specific variables to sh)
	env PATH="$P" "${EXE}" -all -only USER,HOST -to sh   -o $(subst test,out,$@).sh
test12 :
	@$(call HEADING,optional to csh)
	file script12
	env PATH="$P" TVAR_PRE="x:y" "${EXE}" -from sh -to csh  -o $(subst test,out,$@).csh script12

test13:
	@$(call HEADING,basic to cmake)
	file script1
	env PATH="$P" CURVAR="unmodified" OLDVAR="old" "${EXE}" -to cmake -o $(subst test,out,$@).cmake script1

update-sha1 :
	@${HEADING}
	-@"${EXE}" --INSTALL;\
	perl -pi -e 'our $$s;BEGIN{ $$s=shift@ARGV;$$s=~s/ .*//} s/[{][^}]*[}]/{$$s}/ if m/^our .SHA1 = q/' `cat "${HOME}/.${TOOL_NAME}.sha1"` "${EXE}"

install : update-sha1
	@${HEADING}
	"${EXE}" --INSTALL
	mkdir -p "${INSTALL_DIR}"
	rsync -auvP "${EXE}" "${INSTALL_DIR}/"
	mkdir -p "${MANPAGE_DIR}"
	pod2man "${EXE}" >"${MANPAGE_DIR}/${EXE}"

#TAF!
