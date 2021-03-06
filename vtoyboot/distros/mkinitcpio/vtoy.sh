#!/bin/sh
#************************************************************************************
# Copyright (c) 2020, longpanda <admin@ventoy.net>
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 3 of the
# License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.
# 
#************************************************************************************

rm -f /etc/mkinitcpio.conf.bk
rm -f /sbin/vtoydump  /sbin/vtoypartx  
rm -f /usr/lib/initcpio/hooks/ventoy
rm -f /usr/lib/initcpio/install/ventoy

cp -a $vtdumpcmd /sbin/vtoydump
cp -a $partxcmd  /sbin/vtoypartx
cp -a ./distros/$initrdtool/ventoy-install.sh  /usr/lib/initcpio/install/ventoy
cp -a ./distros/$initrdtool/ventoy-hook.sh  /usr/lib/initcpio/hooks/ventoy

echo "updating the initramfs, please wait ..."
cp -a /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bk

if grep -q '^HOOKS=.*lvm' /etc/mkinitcpio.conf; then
	exthook='ventoy'
else
	exthook='lvm2 ventoy'
fi

sed "s/^HOOKS=\"\(.*\)\"/HOOKS=\"\1 $exthook\"/" -i /etc/mkinitcpio.conf

mkinitcpio -P

rm -f /etc/mkinitcpio.conf
mv /etc/mkinitcpio.conf.bk /etc/mkinitcpio.conf


