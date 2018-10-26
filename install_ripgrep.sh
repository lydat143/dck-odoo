#!/bin/bash

set -euxo pipefail

cd /tmp || exit

# cleanup old installation
/bin/rm -rf /tmp/ripgrep.tar.gz /tmp/rg
/bin/mkdir /tmp/rg

# Get latest releases
repos_api="https://api.github.com/repos/BurntSushi/ripgrep/releases/latest"
#version=$(curl -sSL $repos_api | jq -r '. | .tag_name')
version=0.6.0
repos_dl="https://github.com/BurntSushi/ripgrep/releases/download/${version}/ripgrep-${version}-x86_64-unknown-linux-musl.tar.gz"
curl -sSL "$repos_dl" -o /tmp/ripgrep.tar.gz

# install ripgrep
tar -C /tmp/rg --strip-components=1 -xvzf /tmp/ripgrep.tar.gz
mv /tmp/rg/rg /usr/local/bin/rg
mv /tmp/rg/complete/_rg /usr/share/zsh/vendor-completions/_rg
mv /tmp/rg/complete/rg.bash-completion /etc/bash_completion.d/rg

# ensure all files has correct permission
chown root: /usr/local/bin/rg /usr/share/zsh/vendor-completions/_rg /etc/bash_completion.d/rg

# cleanup
/bin/rm -rf /tmp/ripgrep.tar.gz /tmp/rg
