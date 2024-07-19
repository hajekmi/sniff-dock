#!/bin/sh

mkdir -p /etc/ssh/keys
mkdir -p /etc/ssh/sshd_config.d

[ -e "/mnt/ssh/ssh_host_rsa_key" ] && cp /mnt/ssh/ssh_host_rsa_key /etc/ssh/keys/ 
[ -e "/mnt/ssh/ssh_host_ecdsa_key" ] && cp /mnt/ssh/ssh_host_ecdsa_key /etc/ssh/keys
[ -e "/mnt/ssh/ssh_host_ed25519_key" ] && cp /mnt/ssh/ssh_host_ed25519_key /etc/ssh/keys

[ ! -e "/mnt/ssh/ssh_host_ed25519_key" ] && { \
    ssh-keygen -t RSA -f /etc/ssh/keys/ssh_host_rsa_key -N "" -q ; \
    ssh-keygen -t ECDSA -f /etc/ssh/keys/ssh_host_ecdsa_key -N "" -q ; \
    ssh-keygen -t ED25519 -f /etc/ssh/keys/ssh_host_ed25519_key -N "" -q ; }


chmod 0600 /etc/ssh/keys/*

cat <<END > /etc/ssh/sshd_config.d/sniff_dock_sshd.conf
Port 2222
HostKey /etc/ssh/keys/ssh_host_rsa_key
HostKey /etc/ssh/keys/ssh_host_ecdsa_key
HostKey /etc/ssh/keys/ssh_host_ed25519_key

PubkeyAuthentication yes
AuthorizedKeysFile	.ssh/authorized_keys
PasswordAuthentication no

X11Forwarding no
AllowAgentForwarding no
UseDNS no
Subsystem	sftp	internal-sftp
END

cat <<END > /etc/profile.d/sniff_dock_profile
alias ll='ls -l --color=auto'

END

exec /usr/sbin/sshd -D -e -p 2222 "$@"
