backuppart=/media/backup #osio mille tallennetaan varmuskopiot ja mik� t�ytyy mountata sit� varten
datestr=$(date +%F)
vgname=vg1 #volume group:in nimi mik�li $backuppart on LVM:n takana
XFSDUMP_CMD="sudo /usr/sbin/xfsdump" # $(which xfsdump)
VGCHANGE_CMD="sudo /sbin/vgchange" # $(which vgchange)
MOUNT_CMD=$(which mount) #t�m� ja seuraava sit� varten jos mount:ailu vaadi sudon
UMOUNT_CMD=$(which umount)
EXT3OPTS=" --exclude lost+found -jcvpf " #taria varten(ext3 toistaiseksi tar:illa)
