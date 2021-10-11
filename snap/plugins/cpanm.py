import snapcraft
import logging

import os
import shutil
import urllib.request

logger = logging.getLogger(__name__)


class CpanmPlugin(snapcraft.BasePlugin):

    @classmethod
    def schema(cls):
        schema = super().schema()

        schema['properties']['cpanm-packages'] = {
            'type': 'array',
        }
        schema['properties']['run-test'] = {
            'type': 'boolean',
            'default': False
        }

        schema['properties']['verbose'] = {
            'type': 'boolean',
            'default': False
        }

        schema['required'] = ['cpanm-packages']

        return schema

    def __init__(self, name, options, project):
        super().__init__(name, options, project)

        self.stage_packages.extend(['perl', 'perl-base'])
        self.build_packages.extend(['perl', 'build-essential'])

        self._install_cmd = ['cpanm']

        if self.options.verbose:
            self._install_cmd.append('--verbose')

        if not self.options.run_test:
            self._install_cmd.append('--notest')

    def pull(self):
        super().pull()
        cpanm_pl = os.path.join(self.sourcedir, 'cpanminus.pl')
        urllib.request.urlretrieve('http://cpanmin.us', cpanm_pl)

        self.run(['perl', '--', cpanm_pl, 'App::cpanminus'])

    def build(self):
        super().build()

        for module in self.options.cpanm_packages:
            self.run(self._install_cmd[:] + [module])

        perl_inc = self.run_output(['perl', '-e', 'print "@INC"'])
        perl_snap_inc = []
        for inc_path in perl_inc.split():
            if inc_path != ".":
                perl_snap_inc.append('$SNAP' + inc_path)

        perl5lib_sh = os.path.join(self.installdir,
                                   'usr', 'bin', 'perl5lib.sh')
        with open(perl5lib_sh, "w") as text_file:
            text_file.write(
                "env PERL5LIB={} env PATH=$SNAP/usr/local/bin:$PATH $@"
                .format(':'.join(perl_snap_inc)))

        # cpanm install modules to `/usr/local` by default
        # unfortunatelly no best solution was found
        shutil.copytree('/usr/local',
                        os.path.join(self.installdir, 'usr', 'local'))
