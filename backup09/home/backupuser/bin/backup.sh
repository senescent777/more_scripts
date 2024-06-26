#!/bin/bash

dump_xfs () {
if [ "$1" != "/" ] ; then
#   xfsdump $XfSOPTS $1 -f $backupdir$1.dump
    $XFSDUMP_CMD $XfSOPTS $1 -f $backupdir$1.dump
else
#   xfsdump $XfSOPTS $1 -f $backupdir/root.dump
   $XFSDUMP_CMD $XfSOPTS $1 -f $backupdir/root.dump
fi

ls -las $backupdir
}


backuppart=/media/backup
params_ok=0
vgname=vg1
XFSDUMP_CMD="sudo /usr/sbin/xfsdump" # $(which xfsdump)
VGCHANGE_CMD="sudo /sbin/vgchange" # $(which vgchange)

[ "$1" != "" ] || exit 1


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

mount_fs () {
##vgchange -a y $vgname
$VGCHANGE_CMD -a y $vgname
mount $1
}

umount_fs () {
umount $1
##vgchange -a n $vgname
$VGCHANGE_CMD -a n $vgname
}

check_params $1
[ "$params_ok" = 1 ] || exit 2


datestr=$(date +%F)
backupdir="$backuppart"/"$1"/"$datestr"
#backupdir=/tmp/bakkupp/"$1"/"$datestr"

echo $datestr >> $HOME/backup.log


mount_fs $backuppart
[ "$?" = 0 ] || exit 3

[ -d $backupdir ] || mkdir -p $backupdir

if [ -d $backupdir ] ; then
   XfSOPTS="$XfSOPTS -F -d 4G " #ei -v:t� , menee helposti ns. yli
   tar --exclude lost+found -jcvpf $backupdir/boot.tar.bz2 /boot

   for  dir in $(mount | grep xfs | grep -v tmp | awk '{print $3}') ; do 
   
	dump_xfs $dir  
  done

fi

umount_fs $backuppart
