class webserver($usaNginx = false) {
	if $usaNginx {
		$port = 8080
		package { 'nginx': ensure => installed, }
		service { 'nginx':
			ensure => running,
			enable => true,
			require => Package['nginx'],
		}
	} else {
		$port = 80
		service { 'nginx':
			ensure => stopped,
			enable => false,
		}
	}

	package { 'apache2':
		ensure => installed,
	}

	service { 'apache2':
		ensure => running,
		enable => true,
		require => Package['apache2'],
	}

	file { '/etc/security/limits.d/nofile.conf':
		ensure => present,
		owner => 'root',
		mode => 644,
		source => '/root/demo/nofile.conf',
	}

	file { '/etc/apache2/ports.conf':
		ensure => present,
		content => template('/root/demo/ports.conf.erb'),
		notify => Service['apache2'],
		require => Package['apache2'],
	}

	# TODO: php5 package, enable mod-rewrite, mod-deflate
}

node 'dcds-virtualbox' {
	class { 'webserver':
	#	usaNginx => true,
	}
}
