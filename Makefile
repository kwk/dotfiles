os=$(shell cat /etc/os-release | grep ID=fedora -q && echo fedora || echo unknown)
fedora_packages=git gdb stow vim-enhanced tmux bat tree python3-pyfzf gnupg2 yubikey-manager

START = @echo -e "\n>> BEGIN $@"
END = @echo -e "<< END $@\n"

.PHONY: all
all: install-fedora
	@echo -e "\nIMPORTANT: Now run: source ~/.bashrc\n"

.PHONY: install-fedora
install-fedora: install-fedora-packages install-dotfiles install-python-packages fix-permissions

.PHONY: fix-permissions
fix-permissions:
	$(START)
	@echo "Mitigate this error: It is required that your private key files are NOT accessible by others."
	@chmod 600 ~/.ssh/id_gpg.pub
	# Other
	#chown -v $(shell whoami) ~/.gnupg/*
	#chmod -v 600 ~/.gnupg/*
	#chmod -v 700 ~/.gnupg
	$(END)

.PHONY: install-dotfiles
install-dotfiles:
	$(START)
	@rm -rf dot-config/vim/colors
	@stow . --verbose
	$(END)
	
.PHONY: install-python-packages
install-python-packages:
	$(START)
	@echo "Install pygments for gdb dashboard to hightlight source code"
	@pip install pygments
	$(END)

.PHONY: install-fedora-packages
install-fedora-packages:
	$(START)
	@echo "Check for required packages: $(fedora_packages)"
	@rpm -q $(fedora_packages) || sudo dnf install -y $(fedora_packages) --setopt=install_weak_deps=False
	@echo "Ensure that opensc is not installed"
	@rpm -q opensc \
		&& echo "ERROR: opensc is known to cause problems with yubikey. Please deinstall it with: sudo dnf remove opensc" 1>&2 \
		&& exit 333 \
		|| true
	$(END)

