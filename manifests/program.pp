#
# This maintains 'program' entry which supervisord is to managed.
#
# Oisin Mulvihill
# 2013-02-18.
#

define supervisor::program(
        $name = $title,
        $command,
        $directory,
        $autostart,
        $user,
    ) {

    include supervisor::params

    $conf_d = $supervisor::params::supervisor_conf_dir

    $file_name = "${conf_d}/${name}.conf"

    file {
        "program-${name}":
            ensure => file,
            path => $file_name,
            content => template("supervisor/program.conf.erb"),
            mode => 644,
            replace => true,
            require => [
                Class["supervisor::params"],
                File[$supervisor::params::supervisor_conf_dir]
            ];
    }
}
