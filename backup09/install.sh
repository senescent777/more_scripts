#!/bin/bash
sudo /usr/sbin/userdel backupuser
sudo adduser --system backupuser

#TODO:jobs'in parsetuksen kanssa jotain jatkokeh
mount | grep /dev | grep -v tmp | grep -v pts | awk '{print $3,$5}' > jobs
#TODO:josko for-looppi missä yo. rivi pohjana

nano jobs
#TODO:jobs kenties /h/backupuser alle

#TODO:tähän väliin se sha256-jekku tdstoon backupo-sudoers
#mangle_s, pre_enforce mallina
[ -f ./backup-sudoers ] && sudo cp ./backup-sudoers /etc/sudoers.d

sudo cp -a ./bin /home/backupuser
#TODO:cron-jutut