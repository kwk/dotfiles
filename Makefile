# Determine what OS this runs on
os=$(shell cat /etc/os-release | grep ID=fedora -q && echo fedora || echo unknown)

# Packages that need to be installed on a Fedora system
fedora_packages=git gdb stow vim-enhanced tmux bat tree python3-pyfzf gnupg2 yubikey-manager python3-pip yubikey-personalization-gui fedpkg pipx krb5-config gcc python3-devel centpkg rhpkg python3-psycopg2 inotify-tools fedora-packager-kerberos task

# Increase verbosity, from 0 to 5
STOW_VERBOSE_LEVEL := 2

START = @echo -e "\n>> BEGIN $@"
END = @echo -e "<< END $@\n"

# If at some point I need to filter out folders, I can do something like:
# STOW_PACKAGES := $(filter-out folder_A/ folder_B/,$(wildcard */))
STOW_PACKAGES := $(filter-out user-installed-rpms.txt,$(wildcard */))

.DEFAULT_GOAL: all


.PHONY: all
all: install-fedora
	@echo -e "\nIMPORTANT: Now reboot for Yubiky and GPG to work properly!!! Seriously, all else is no fun!\n"

.PHONY: show-packages
show-packages:
	@echo $(STOW_PACKAGES)

.PHONY: install-fedora
install-fedora: install-fedora-packages install-dotfiles install-python-packages fix-permissions

.PHONY: fix-permissions
fix-permissions:
	$(START)
	@echo "Mitigate this error: It is required that your private key files are NOT accessible by others."
	@chmod 600 ~/.ssh/id_gpg.pub
	# Other
	chown -v $(shell whoami) ~/.gnupg/* && chmod 600 ~/.gnupg/* && chmod 700 ~/.gnupg
	$(END)

.PHONY: install-dotfiles
install-dotfiles:
	$(START)
	@rm -rf dot-config/vim/colors
	@stow --target=${HOME} --verbose=$(STOW_VERBOSE_LEVEL) --dotfiles $(STOW_PACKAGES)
	$(END)

.PHONY: install-yum-repos
install-yum-repos:
	$(START)
	sudo stow --target=/etc/yum.repos.d/ --verbose=$(STOW_VERBOSE_LEVEL) --dotfiles yum/
	$(END)
	
.PHONY: install-python-packages
install-python-packages:
	$(START)
	@echo "Install pygments for gdb dashboard to hightlight source code"
	@pip install pygments
	@echo "Install did package"
	@pip install did[all]
	$(END)

.PHONY: install-fedora-packages
install-fedora-packages: install-yum-repos
	$(START)
	@echo "Check for required packages: $(fedora_packages)"
	rpm -q $(fedora_packages) || sudo dnf install $(fedora_packages) --setopt=install_weak_deps=False
	@echo "Ensure that opensc is not installed"
	@rpm -q opensc \
		&& echo "ERROR: opensc is known to cause problems with yubikey. Please deinstall it with: sudo dnf remove opensc" 1>&2 \
		&& exit 333 \
		|| true
	$(END)

