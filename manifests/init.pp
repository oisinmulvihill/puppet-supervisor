#
# Install supervisord used to manage processes we can run as daemon.
#
# Oisin Mulvihill
# 2012-09-05
#

class supervisor inherits supervisor::params {

    file {
        "supervisor-dir":
            name => $supervisor_dir,
            ensure => directory;

        "supervisor-conf-dir":
            name => $supervisor_conf_dir,
            ensure => directory,
            require => File["supervisor-dir"];

        "supervisor-conf":
            path => "${supervisor_dir}/supervisord.conf",
            mode => 644,
            content => template("supervisor/supervisord.conf"),
            replace => true,
            ensure => file,
            require => File["supervisor-dir"];
    }

    if ($pkg_required) {
        package {
            $pkg_required: ensure => installed;
        }

        service {
            "supervisor": ensure => true;
        }

        Class["supervisor::params"] ->
        Package[$pkg_required] ->
        File["supervisor-dir"] ->
        File["supervisor-conf-dir"] ->
        File["supervisor-conf"] ~>
        Service["supervisor"]

    } else {
        notice('Performing supervisor from source setup .')

        $req = 'python-setuptools'

        if (!defined(Package[$req])) {
            package {
                $req: ensure => installed;
            }
        }

        exec {'install-supervisord-via-src':
            command => "easy_install supervisor",
            path => "/usr/local/bin:/usr/bin:/bin",
            require => Package[$req],
            unless => "which supervisorctl",
            timeout => 0,
        }

        exec { 'supervisord-log-dir':
            command => "mkdir -p /var/log/supervisor",
            path => "/usr/local/bin:/usr/bin:/bin",
        }

        exec { 'stop-supervisord-ifrunning':
            # simple wait for it to stop as it may not have shutdown:
            command => "supervisorctl -c ${supervisor_dir}/supervisord.conf shutdown ; bash -c 'sleep 3'",
            path => "/usr/local/bin:/usr/bin:/bin",
            onlyif => 'pgrep supervisord',
        }

        service {
            "supervisor":
                ensure => 'running',
                start => "/usr/bin/supervisord -c ${supervisor_dir}/supervisord.conf",
                stop => '/usr/bin/supervisorctl -c ${supervisor_dir}/supervisord.conf shutdown',
                require => Exec['supervisord-log-dir'];
        }

        Class["supervisor::params"] ->
        Exec['stop-supervisord-ifrunning'] ->
        Exec['install-supervisord-via-src'] ->
        File["supervisor-dir"] ->
        File["supervisor-conf-dir"] ->
        File["supervisor-conf"] ~>
        Service["supervisor"]
    }

}

