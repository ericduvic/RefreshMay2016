# We want to configure the servers for separate tasks,
# so we use node definitions.
node 'web' {
  file { '/var/www':
    ensure => 'directory',
  }
  file { '/var/www/coolest_chat':
    ensure => 'link',
    target => '/vagrant/server',
  }
  file { [ '/var/www/coolest_chat/public', '/var/www/coolest_chat/tmp' ]:
    ensure => 'directory',
    require => File['/var/www/coolest_chat'],
  }

  package { [ 'libpq-dev', 'build-essential', 'gcc' ]:
    ensure => 'installed',
    before => Package['bundler'],
  }

  package { 'ruby-dev':
    ensure => 'installed',
  }

  package { 'ruby':
    ensure => 'installed',
    require => Package['ruby-dev'],
  }

  package { 'bundler':
    ensure => 'installed',
    require => Package['ruby'],
  }

  exec { 'bundle install':
    path => '/bin:/usr/bin:/usr/local/bin',
    command => 'bundle install',
    cwd => '/var/www/coolest_chat/',
    require => Package['bundler'],
    user => 'root'
  }

  class { 'apache':
    default_vhost => false,
  }

  apache::vhost { 'coolest_chat':
    docroot => '/var/www/coolest_chat/public',
    port => '80',
  }

  class { 'apache::mod::passenger': }
}

node 'db' {
  class { 'postgresql::globals':
    manage_package_repo => true,
    version => '9.5',
  }

  class { 'postgresql::server':
    listen_addresses => '*',
  }

  postgresql::server::role { 'chatapp':
    password_hash => postgresql_password('chatapp', 'V3ry$3cR37'),
  }

  postgresql::server::database { 'coolest_chat':
    owner => 'chatapp',
    require => Postgresql::Server::Role['chatapp'],
  }
  
  postgresql::server::pg_hba_rule { 'Allow access from web host':
    description => 'Open up access from 192.168.33.0/24',
    type => 'host',
    database => 'coolest_chat',
    user => 'chatapp',
    address => '192.168.33.0/24',
    auth_method => 'md5',
  }

  exec { 'Create database tables':
    command => 'psql -v ON_ERROR_STOP=1 -d coolest_chat -t -f /vagrant/database/db_script.sql',
    path => '/usr/bin',
    require => Postgresql::Server::Database['coolest_chat'],
    user => 'postgres',
    group => 'postgres',
  }
}
