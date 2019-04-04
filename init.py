#! /usr/bin/env python3

from subprocess import call
from pathlib import Path
import os
import sys


SRC_DIR=Path(os.path.abspath(os.path.dirname(__file__)) + '/data')
DEST_DIR=Path(os.environ['HOME'])

DRY_RUN = '--dry' in sys.argv[1:]
if DRY_RUN:
    sys.argv = [x for x in sys.argv if x != '--dry']


def is_installed(to_check):
    if DRY_RUN:
        return False

    else:
        return runcmd('which %s > /dev/null' % to_check) == 0


def install_package(package, to_check=None):
    if is_installed(to_check or package):
        return
    if isinstance(package, (list, tuple)):
        package = ' '.join(package)
    cmd = 'sudo apt install -y %s' % package
    if not DRY_RUN:
        print('=> install %s' % package)
    ret = runcmd(cmd)
    assert ret == 0, 'Cannot install %s' % package


def runcmd(cmd):
    if DRY_RUN:
        print(cmd)
        return 0
    else:
        return call(cmd, shell=True)


def install_conf(conf):
    p = Path(conf)
    source = SRC_DIR.joinpath(p)
    assert source.exists(), '%s is not a valid path' % source
    dest = DEST_DIR.joinpath(p)

    if DRY_RUN:
        print('ln -s %s %s' % (source, dest))
        return 0

    if dest.exists():
        # Make sure the existing dir has is what we wanted to install
        assert dest.is_symlink() and dest.resolve() == source, '%s already exists but is not a symlink on %s' % (dest, source)
    else:
        dest.symlink_to(source)


def manual_install(name, site, to_check=None):
    if to_check and is_installed(to_check):
        return
    runcmd('xdg-open %s && echo "Install %s and type ENTER to continue" && read _' % (site, name))


def main():
    cmds = {x.__name__: x for x in [all, base, scripts, fish, fisherman, pyenv, sublime_text]}
    usage = "%s [%s] [--dry]" % (sys.argv[0], '|'.join(cmds.keys()))
    if len(sys.argv) == 1:
        raise SystemExit(usage)

    cmd_name = sys.argv[1]
    try:
        cmd = cmds[cmd_name]
    except KeyError:
        raise SystemExit(usage)
    cmd()


def all():
    base()
    scripts()
    fish()
    fisherman()
    sublime_text()


def base():
    if not DRY_RUN:
        print(' * basics', end='', flush=True)
    install_package('curl')
    install_package('fish')
    install_package('python3')
    if not DRY_RUN:
        print(' ✓')


def pyenv():
    if not DRY_RUN:
        print(' * pyenv', end='', flush=True)
    if not is_installed('pyenv'):
        runcmd("curl https://pyenv.run | bash")
    if not DRY_RUN:
        print(' ✓')


def scripts():
    if not DRY_RUN:
        print(' * scripts dir', end='', flush=True)
    install_conf('.scripts')
    if not DRY_RUN:
        print(' ✓')


def sublime_text():
    if not DRY_RUN:
        print(' * sublime text', end='', flush=True)
    manual_install('sublime text', 'https://www.sublimetext.com/3', 'subl')
    runcmd('mkdir -p %s/.config/sublime-text-3/Packages/' % DEST_DIR)
    install_conf('.config/sublime-text-3/Packages/User')
    runcmd('wget https://packagecontrol.io/Package%%20Control.sublime-package -O %s/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package' % DEST_DIR)
    if not DRY_RUN:
        print(' ✓')


def fish():
    if not DRY_RUN:
        print(' * fish', end='', flush=True)
    install_conf('.config/fish/config.fish')
    if not DRY_RUN:
        print(' ✓')


def fisherman():
    if not DRY_RUN:
        print(' * fisherman plugins', end='', flush=True)
    runcmd('fish -c "fisher add vibrant git_porcelain bass"')
    if not DRY_RUN:
        print(' ✓')


if __name__ == '__main__':
    main()
