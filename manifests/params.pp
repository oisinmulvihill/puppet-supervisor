#
#
# Oisin Mulvihill
# 2013-02-18
#

class supervisor::params (
        $supervisor_dir = '/etc/supervisor',
        $supervisor_conf_dir = "${supervisor_dir}/conf.d",
        $supervisor_webport = 9001,
        $supervisor_username = 'dev',
        $supervisor_password = 'dev'
    ) {

    case $operatingsystem {

        /(?i)(ubuntu|debian)/: {
            notice('Using Ubuntu/Debian supervisor package.')
            $pkg_required = 'supervisor'
        }

        default: {
            notice('Flagging supervisor needs to be install from easy_install.')
            $pkg_required = false
        }
    }

}

