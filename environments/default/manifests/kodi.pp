exec { 'pacman-update':
  command => '/usr/bin/pacman -Sy'
}

file { '/etc/profile.d/alias.sh':
  content => "
alias ll='ls -laF'
"
}

package { ['virtualbox-guest-utils-nox']:
  ensure => "absent"
}

package { ['mesa-libgl','virtualbox-guest-utils','vim','xf86-video-vesa','xf86-input-evdev', 'kodi', 'lsb-release', 'xorg-xinit', 'wget', 'curl', 'polkit','xterm','alsa-utils','net-tools','nfs-utils', 'openvpn','unzip','dosfstools','hwinfo']:
  ensure => installed,
}

file { '/etc/X11/Xwrapper.config':
  content => "
allowed_users=anybody
needs_root_rights=yes
"
}

file { '/etc/X11/xorg.conf.d/10-monitor.conf':
  content => '
Section "Monitor"
	Identifier "VGA1"
	Modeline "1920x1080_60.00"  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync
	Option "PreferredMode" "1920x1080_60.00"
EndSection

Section "Screen"
	Identifier "Screen0"
	Monitor "VGA1"
	DefaultDepth 24
	SubSection "Display"
		Modes "1920x1080_60.00"
	EndSubSection
EndSection
'
}

file { '/tmp/install-kodi-standalone-service.sh':
  content => "
#!/bin/bash
cd /tmp
/usr/bin/curl https://aur.archlinux.org/cgit/aur.git/snapshot/kodi-standalone-service.tar.gz | tar xvz
chown vagrant. -R kodi-standalone-service
cd kodi-standalone-service
/usr/bin/sudo su vagrant makepkg
/usr/bin/pacman --noconfirm --needed --noprogressbar -U *.pkg.tar.xz
",
  mode => "0744"
}

exec {'install-pkg':
  command => '/bin/bash -c /tmp/install-kodi-standalone-service.sh',
  unless  => '/usr/bin/pacman -Q kodi-standalone-service'
}

exec {'unmute-audio':
  command => '/usr/bin/amixer sset Master unmute && /usr/bin/amixer sset Master 50%',
  require => Package['alsa-utils']
}


service {'kodi':
 enable => true,
}
