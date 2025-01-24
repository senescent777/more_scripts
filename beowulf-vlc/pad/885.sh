#!/bin/sh
src=/run/live/medium/pad

case $1 in
	0)
		sudo /sbin/ifdown eth0
		sudo iptables-restore $src/100724
		sudo /sbin/iptables -L

		cd /;sudo tar -jxvpf $src/70621.tar.bz2
		sudo dpkg -i /var/cache/apt/archives/*.deb
		sudo rm -rf /var/cache/apt/archives/*.deb
		cd /;sudo rm $src/70621.tar.bz2

		cd /;sudo tar -jxpf $src/lu.tar.bz2
		cd /;sudo tar -jxpf $src/apt-120521.tar.bz2
		sudo dpkg -i /var/cache/apt/archives/debian-keyring_2019.02.25_all.deb
		sudo rm -rf /var/cache/apt/archives/*.deb
		cd /;sudo rm $src/apt-120521.tar.bz2

		sudo apt --fix-broken install
		sudo apt-get remove --purge xfburn
		sudo apt autoremove

		cd /home/devuan;tar -jxpf $src/xfce090621.tar.bz2;sudo rm $src/xfce090621.tar.bz2
	break
	;;
	1)
		cd /opt;sudo tar -jxpf $src/firefox*.bz2;sudo rm $src/firefox*.bz2
		cd;sudo tar -jxpf $src/sirje.tar.bz2;sudo rm $src/sirje.tar.bz2 
		/opt/firefox/firefox 
		cd /home/devuan
		target=$(ls .mozilla/firefox | grep release | tail -n 1)
		sudo mv tmp/* .mozilla/firefox/$target
		/opt/firefox/firefox
	break
	;;
	3)
		cd /;sudo tar -xf $src/ac.tar 
		sudo dpkg -i ~/Desktop/anal/*.deb
		sudo mv /etc/apt/sources.list /etc/apt/sources-list.old
		sudo cp $src/sources.list.1 /etc/apt/sources.list
		sudo rm -rf /home/devuan/Desktop/anal/*
		sudo rm -rf /home/devuan/Desktop/cunt/*
		sudo apt-get update
	break
	;;
	4) 
		cd /;sudo tar -xf $src/ac.tar 
		sudo dpkg -i ~/Desktop/anal/*.deb
		sudo mv /etc/apt/sources.list /etc/apt/sources-list.old
		sudo cp $src/sources.list.2 /etc/apt/sources.list
		sudo rm -rf /home/devuan/Desktop/anal/*
		sudo rm -rf /home/devuan/Desktop/cunt/*
		sudo apt-get update
	break
	;;
	v)
		cd /
		sudo tar -jxpf $src/tlv1.tar.bz2
		sudo tar -jxpf $src/tlv2.tar.bz2
		cd /var/cache/apt/archives

		sudo dpkg -i libi* libv* libu* libasan* liblsan*
		sudo dpkg -i libe* libo* libp* libr* libx*
		sudo rm libi* libv* libu* libe* libo* libp* libr* libx* libasan* liblsan*

		sudo dpkg -i libc-dev-bin* linux-libc-dev* libcc1* libcd*
		sudo rm libc-dev-bin* linux-libc-dev* libcc1* libcd*

		sudo dpkg -i libs* libts* libgcc-* libc6-* libm*
		sudo rm libs* libts* libgcc-* libc6-* libm*

		sudo dpkg -i liblive* libgroup* libbasic* libq* q*
		sudo rm libgroup* libbasic* libq* q* liblive*

		sudo dpkg -i libar* libfile* libgles*
		sudo rm libar* libfile* libgles* 

		sudo dpkg -i libg* liba*  
		sudo rm libg* liba* 

		sudo dpkg -i d* libt* libdpkg* libl* auto* po-debconf* libb* binutils* make* intltool* m4* g*
		sudo rm libb* binutils* make* intltool* m4* g*
		sudo rm libdpkg* d* libfile* auto* po-debconf* libt* libl* libdpkg*

		sudo dpkg -i build-essential*
		sudo rm build-essential*

		sudo dpkg -i libd* /usr/src/libdvd-pkg/*.deb
		sudo dpkg-reconfigure libdvd-pkg
		sudo rm libd*

		sudo dpkg -i vlc-data* vlc-bin* vlc-plugin-base* vlc-plugin-qt* vlc-plugin-video-output*
		sudo dpkg -i vlc_3*

		sudo rm  vlc-data* vlc-bin* vlc-plugin-base* vlc-plugin-qt* vlc-plugin-video*
		sudo rm -rf /usr/src/libdvd-pkg/build
		sudo rm $src/tlv*
		sudo chmod o+rx /dev/sr0
	break
	;;
	*)
		echo "mee vittuun"
	break
	;;
esac
