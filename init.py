#! /usr/bin/env python3

from subprocess import call
from pathlib import Path
import os


SRC_DIR=Path(os.path.abspath(os.path.dirname(__file__) + '/data'))
DEST_DIR=Path(os.environ['HOME'])


def is_installed(to_check):
    return runcmd('which %s > /dev/null' % to_check) == 0


def install_package(package, to_check=None):
    if is_installed(to_check or package):
        return
    if isinstance(package, (list, tuple)):
        package = ' '.join(package)
    cmd = 'sudo apt install -y %s' % package
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


def manual_install(name, site, to_check=None):
    if to_check and is_installed(to_check):
        return
    runcmd('xdg-open %s && echo "Install %s and type ENTER to continue" && read _' % (site, name))


# install good stuff

print(' * basics', end='', flush=True)
install_package('curl')
install_package('python-pip', to_check='pip')
install_package('python3-pip', to_check='pip3')
runcmd("sudo pip install -U pip")
runcmd("sudo pip3 install -U pip3")
runcmd("sudo pip3 install virtualenv tox flake8 pylint")
install_package('curl')
print(' ✓')

print(' * zsh', end='', flush=True)
install_package('zsh')
if not DEST_DIR.joinpath('.oh-my-zsh').exists():
    runcmd('sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"')

install_conf('.oh-my-zsh/custom/perso.zsh')
print(' ✓')

print(' * awesome', end='', flush=True)
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

runcmd('git config --global user.email "emmanuel.leblond@gmail.com"')
runcmd('git config --global user.name "Emmanuel Leblond"')

print(' * sublime text', end='', flush=True)
manual_install('sublime text', 'https://www.sublimetext.com/3', 'subl')
runcmd('mkdir -p %s/.config/sublime-text-3/Packages/' % DEST_DIR)
install_conf('.config/sublime-text-3/Packages/User')
runcmd('wget https://packagecontrol.io/Package%%20Control.sublime-package -O %s/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package' % DEST_DIR)
print(' ✓')

manual_install('Dropbox', 'https://www.dropbox.com/install', 'dropbox')
