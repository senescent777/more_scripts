#!/bin/bash

. common.sh

#echo "$0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
#exit 0


[ "$1" = "" ] && exit 1


params_ok=0
MOUNTOPT=""
SOURCEDIR=""
TARGETDIR=""
FSTYPE=""
DUMPTYPE=""
SHOW_DEBUG=0

debug() {
	[ "$SHOW_DEBUG" = "1" ] && echo $1
}

dump_xfs () {
	if [ "$1" != "/" ] ; then
	#   xfsdump $XfSOPTS $1 -f $backupdir$1.dump
	    echo "$XFSDUMP_CMD $XfSOPTS $1 -f $2$1.dump"
	else
	#   xfsdump $XfSOPTS $1 -f $backupdir/root.dump
	   echo "$XFSDUMP_CMD $XfSOPTS $1 -f $2/root.dump"
	fi
}

dump_ext3() {
	echo "tar $EXT3OPTS $2$1.tar.bz2 $1" 
}

check_params() {
	case "$1" in
	     full)
	          XfSOPTS="-l 0"
	          params_ok=1
	     ;;
	     month)
	          XfSOPTS="-l 1"
	          params_ok=1
	     ;;
	     week)
	         XfSOPTS="-l 2"
	         params_ok=1
	     ;;
	     day)
	        XfSOPTS="-l 3"
	        params_ok=1
	     ;;
esac
}

parse_opts() {
	debug "parse_opts $1 $2"
	
	case "$1" in
	     -m)
	          MOUNTOPT="$2"
	     ;;
	     -d)
	          SOURCEDIR="$2"
	     ;;
	     -od)
	          TARGETDIR="$2"
	     ;;
	     -ft)
	          FSTYPE="$2"
	     ;;
esac
}


mount_fs () {
	[ "$2" = "" ] || echo "$VGCHANGE_CMD -a y $vgname"
	[ "$1" = "" ] || echo "$MOUNT_CMD $1"
}

umount_fs () {
	[ "$1" = "" ] || echo "$UMOUNT_CMD $1"
	[ "$2" = "" ] || echo "$VGCHANGE_CMD -a n $vgname"
	
}


#tutkitaan ensin että varmuuskopioinnin tyyppi järkevä
check_params $1
[ "$params_ok" = 1 ] || exit 2
debug "PARAMS_OK"

DUMPTYPE="$1"

#näille main $2...$9 lukeminen joihinkin toisen nimisiin muuttujiin


parse_opts $2 $3
parse_opts $4 $5
parse_opts $6 $7
parse_opts $8 $9

#seuraavaksi "-m" -option käsittely:
#-m 1 mounttaa 
#-m 0 mount:aa vain jos on pakko 
#-m umount umount:taa (ja exitoi?)
#
#TODO:tuntemattoman mount-option tapauksessa exit
#TODO:-m 0 mounttaamaan tarvittaessa tahikka koko mounttaus-paskan siirto autofs:lle
#
case "$MOUNTOPT" in
     0)
          debug "no mount"
     ;;
     1)
          #echo "mount fs"
	mount_fs "$backuppart" "$vgname"
     ;;
     umount)
         #echo "umount fs"
	umount_fs "$backuppart" "$vgname"
	 exit 0
     ;;
     
esac

#ennen "-ft" -vivun käsittelyä kasataan tiedostojärjestelmistä riippuvaiset
#optiot esim. $1:sen erusteella?

#MUUTTUJAN XfSOPTS SIJAITTAVA TÄSSÄ SKRIPTISSÄ, MUUTEN MENEE PIELEEN!!!
XfSOPTS=" -F -d 4G -v trace " #xfsdumpia varten , -v debug:issa ei järkeä, tulee liikaa tauhkaa logiin

#luodaanpa vielä kohdehakemisto ennen sinne dumppaamista
[ -d "$backuppart"/"$TARGETDIR" ] || echo "mkdir -p $backuppart/$TARGETDIR"


#"-ft"- parametrin perusteella päätetään mitä varsmuuskopiointifktiota käytetään
#, arvo ext3 käyttää tar:ia dump_ext3()- fktion kautta(/boot-hakemisto tällä)
#  arvo xfs käyttää xfsdump:ia dump_xfs() - fktion kautta
#TODO:$XfSOPTS:ista 3. parametri fktiolle dump_xfs , samaan tapaan $EXT3OPTS parametriksi dump_ext3-fktiolle
case "$FSTYPE" in
     ext3)
         #echo "dump_ext3();"
	dump_ext3 "$SOURCEDIR" "$backuppart"/"$TARGETDIR"
     ;;
     xfs)
         #echo "dump_xfs();"
	dump_xfs "$SOURCEDIR" "$backuppart"/"$TARGETDIR"
     ;;
esac

#näille main jotain "hakemiston linkitys"-kikkailua
#kikkailun tarkoituksena on päästä helposti selville minkä tyyppisiä backup:eja tehtiin
# minäkin päivänä

[ -d "$backuppart/BY-DATE/$datestr/$DUMPTYPE" ] || echo "mkdir -p $backuppart/BY-DATE/$datestr/$DUMPTYPE"
echo "ln -s $backuppart/$TARGETDIR $backuppart/BY-DATE/$datestr/$DUMPTYPE"

#2 seuraavaa tulostusta on tarkoitus mennä logiin jatkossa
echo "ls -las $backuppart/$TARGETDIR >> $HOME/backup.log"
echo "echo $datestr >> $HOME/backup.log"

#echo $datestr >> $HOME/backup.log
#
#
#mount_fs $backuppart
#[ "$?" = 0 ] || exit 3
#
#[ -d $backupdir ] || mkdir -p $backupdir
#
#if [ -d $backupdir ] ; then
#   XfSOPTS="$XfSOPTS -F -d 4G"
#   tar --exclude lost+found -jcvpf $backupdir/boot.tar.bz2 /boot
#
#   for  dir in $(mount | grep xfs | grep -v tmp | awk '{print $3}') ; do 
#   
#	dump_xfs $dir  
#  done
#
#fi
#
#umount_fs $backuppart
#