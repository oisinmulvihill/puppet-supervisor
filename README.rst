puppet-supervisor
=================

A puppet module to mange supervisor which provides functions to easily add new
services to it.

Contributions are welcome!

 * https://github.com/oisinmulvihill/puppet-supervisor


Usage
-----

To install and use supervisor you just need to include it:

.. code-block:: puppet

    include supervisor

If you want more control over supervisor you can use a class instead:


.. code-block:: puppet

    class {'supervisor':
        # Optional extras:

        # false indicate an install from pypi. 'supervisor' is the default on
        # Debian and Ubuntu. On other platforms an install from pypi is
        # performed instead.
        $pkg_required = 'supervisor' | false

        # Where config directory is location, default:
        $supervisor_dir = '/etc/supervisor'

        # The web service frontend default details:
        $supervisor_webport = "9001"
        $supervisor_username = "dev"
        $supervisor_password = "dev"
    }


If you then want to add a service to it you can then use program():

.. code-block:: puppet

    include supervisor

    supervisor::program {'some-service-install':
        name => 'name-in-supervisor',
        command => 'command-line-for-service',
        directory => 'directory-to-run-service-from',
        # default (true)
        autostart => 'false' | 'true',
        user => 'username-to-run-the-service-command-line-as',
    }


The supervisord will need to be reloaded to pickup new programs.


License
-------

Copyright (c) 2013, Oisin Mulvihill
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

  Redistributions in binary form must reproduce the above copyright notice, this
  list of conditions and the following disclaimer in the documentation and/or
  other materials provided with the distribution.

  Neither the name of the {organization} nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
