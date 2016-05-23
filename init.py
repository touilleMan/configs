#! /usr/bin/env python3

from subprocess import call
from pathlib import Path
import os

SRC_DIR=Path(os.path.abspath(os.path.dirname(__file__) + '/data'))
DEST_DIR=Path(os.environ['HOME'])


def install_package(package):
    if hasattr(package, '__iter__'):
        package = ' '.join(package)
    cmd = 'sudo apt-get install %s' % package
    print('=> install %s' % package)
    ret = runcmd(cmd)
    assert ret == 0, 'Cannot install %s' % package


def runcmd(cmd):
    return call(cmd, shell=True)


def install_conf(conf):
    p = Path(conf)
    source = SRC_DIR.joinpath(p)
    assert source.exists(), '%s is not a valid path' % source
    dest = DEST_DIR.joinpath(p)
    if dest.exists():
        # Make sure the existing dir has is what we wanted to install
        assert dest.is_symlink() and dest.resolve() == source, '%s already exists but is not a symlink on %s' % (dest, source)
    else:
        dest.symlink_to(source)


def desktop_enable_app(appname):
    app = '/etc/xdg/autostart/%s.desktop' % appname
    if runcmd("grep '^OnlyShowIn=.*Awesome;$' %s" % app) != 0:
        runcmd("sudo sed  -is 's/OnlyShowIn=Awesome;/OnlyShowIn=/' %s" % app)


# install good stuff

print(' * zsh', end='', flush=True)
if runcmd('which zsh > /dev/null') != 0:
    install_package('zsh')
if not DEST_DIR.joinpath('.oh-my-zsh').exists():
    runcmd('sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"')
install_conf('.oh-my-zsh/custom/perso.zsh')
print(' ✓')

print(' * awesome', end='', flush=True)
if runcmd('which awesome > /dev/null') != 0:
    install_package('awesome')
desktop_enable_app('gnome-keyring-*')
desktop_enable_app('gnome-sound-panel')
desktop_enable_app('gnome-power-panel')
install_conf('.config/awesome')
print(' ✓')

print(' * python shell conf', end='', flush=True)
install_conf('.config/python_shell_conf.py')
print(' ✓')

print(' * scripts dir', end='', flush=True)
install_conf('.scripts')
print(' ✓')

print("""
*** TODO ***
 * Dropbox https://www.dropbox.com/install
 * what else ? ;-)
""")
