#tdsto mennyt jo uudestaan wtuiksi vai ei?

function oldprof() {
	dqb "olfprof ${1} ${2}"
	csleep 3
	[ -z "${1}" ] && exit 99
	dqb "pars ok"
	csleep 1

	local tmp=$(grep ${1} /etc/passwd | wc -l) #ÄLÄ PERKELEEN TONTTU KÄYTÄ "grep -c" MISSÄÄN	

	if [ ${tmp} -gt 0 ] ; then 
		if [ -d ${1}/.mozilla ] ; then
			${NKVD} ${1}/.mozilla/*
			${smr} -rf ${1}/.mozilla 
		fi
	
		${odio} mkdir -p ${1}/.mozilla/firefox
	fi

	if [ ${debug} -eq 1 ] ; then
		echo "AFTER MKDIR";sleep 3
		ls -las ${1}/.mozilla/firefox;sleep 3
		echo "eEXIT oldprof($1)"
	fi

	dqb "olfprof ${1} ${2} DONE"
	csleep 3
}

function createnew() {
	dqb "createnwet ${1} , ${2}"

	[ -z "${1}" ] && exit 99
	#[ -z "${2}" ] && exit 98 #oliko tämä jo poistettu?

	dqb "pars ok"
	csleep 1

	local tmp=$(grep ${1} /etc/passwd | wc -l)
	local fox=$(${odio} which firefox)

	if [ ${tmp} -gt 0 ] ; then 
		if [ -x ${fox} ] ; then
			${fox}&
	
			if [ $? -eq 0 ] ; then
				sleep 3
				${whack} firefox-esr 
				${whack} firefox 
			fi
		else
			echo "https://www.youtube.com/watch?v=PjotFePip2M" 
		fi
	fi

	csleep 3
	dqb "createnwet ${1} , ${2} DONE"
}

function findprof() {
	result=$(find ${1} -type d  | grep -v '+' | grep ${2}  | head -n 1 )
}

function copy_to() {
	debug=1 #pois josqs?
	dqb "copy_to ${1} ; ${2} ; ${3}"
	csleep 1
	
	[ -z "${1}" ] && exit 99
	[ -d ${2} ] || exit 68
	[ -z "${3}" ] && exit 69
	[ -d ${3} ] || exit 70

	dqb "pars.ok"
	csleep 1

	local tget
	findprof ${2} ${1}
	tget=${result}

	dqb "IN 3 SECONDS: sudo mv ${3}/ * . js ${tget}"
	csleep 3

	local f
	for f in $(find ${3} -type f -name "*.js*" ) ; do mv ${f} ${tget} ; done		
	
	if [ ${debug} -eq 1 ] ; then
		echo "AFT3R MV";sleep 2
		ls -las ${tget}
		sleep 2
	fi	

	csleep 1
	dqb "copy_to D0N3"
}

function access() {
	dqb "access ${1} , ${2}"
	csleep 1

	[ -z "${1}" ] && exit 99
	[ -z "${2}" ] && exit 98

	dqb "pars ok"
	csleep 1

		dqb "shdgfsdhgfsdhgf"
		csleep 2

		if [ -d ${2}/.mozilla ] ; then 
			${sco} -R ${1}:${1} ${2}/.mozilla
			${scm} -R 0700 ${2}/.mozilla 	
		fi

		[ -d ${2}/Downloads ] || ${odio} mkdir ${2}/Downloads

		${sco} -R ${1}:${1} ${2}/Downloads
		${scm} u+wx ${2}/Downloads
		${scm} o+w /tmp 

	dqb "access d0n3"
	csleep 1
}

function imp_prof() {
	dqb "imp_prof ${1} ${2} ${3}"
	csleep 1

	#riittäisikö tämmöiset tark?
	[ -z "${1}" ] && exit 99
	[ -z "${2}" ] && exit 98
	[ -z "${3}" ] && exit 97
	[ -d /home/${2} ] || exit 96

	dqb "pars_ok"
	csleep 1

			${scm} 0700 /home/${2}

			oldprof /home/${2}
			${sco} -R ${2}:${2} /home/${2}/.mozilla/firefox
			createnew ${2}
			copy_to ${1} /home/${2}/.mozilla/firefox ${3}
			access ${2} /home/${2}

	dqb "imp_prof done dnoe"
	csleep 1
}

function exp_prof() {
	dqb "exp_pros ${1} ${2}"
	csleep 1

	#riittäisikö tämmöiset tark?
	[ -z "${1}" ] && exit 99
	[ -z "${2}" ] && exit 98

	dqb "oars_ok"
	local tget
	local oldd
	local f
	csleep 1
	
	findprof ~/.mozilla/firefox ${2}
	tget=${result}
	dqb "TG3T=${tget}"
	csleep 5
	oldd=$(pwd)

	cd ${tget}

	#240626:rnd-kikkailu edelleen tarpeellinen?
	${odio} touch ./rnd
	${sco} ${n}:${n} ./rnd
	${scm} 0644 ./rnd
	dd if=/dev/random bs=6 count=1 > ./rnd

	${srat} -cvf ${1} ./rnd
	for f in $(find . -name "*.js" ) ; do ${srat} -rf ${1} ${f} ; done

	cd ${oldd}

	csleep 1
	dqb "eprof.D03N"
}
