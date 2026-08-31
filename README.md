# dotfiles

My config files.

This project uses [GNU Stow](https://www.gnu.org/software/stow/) and [GNU
Make](https://www.gnu.org/software/make/), so you need to install them.

In Fedora:

```bash
sudo dnf install -y make
```

Then, run `make`. If a file already exists (usually Bash files on new
installations), you need to adopt it or remove the target.

After installing, reboot. This is necessary for the Yubikey GPG to work, seriously!

## About the structure

Each program has its own folder. Inside, you will find files and directories
that start with `dot-`. Stow will replace that part with a `.`, making them
hidden.

## Legal stuff

This repository is licensed under the GNU General Public License v3.0 or later.
See [LICENSE](LICENSE) for details.
