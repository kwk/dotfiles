## See also https://github.com/drduh/yubikey-guide#replace-agents
unset SSH_AGENT_PID
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null