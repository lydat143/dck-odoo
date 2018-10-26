FROM buildpack-deps:bionic

MAINTAINER DAT LY <lydat143@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV PGVER 10

ENV WK2PDF_VER 0.12.4
ENV WK2PDF_URL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/${WK2PDF_VER}/wkhtmltox-${WK2PDF_VER}_linux-generic-amd64.tar.xz

ENV ODOO_USER  odoo
ENV ODOO_PASS  odoo@air-t
ENV ODOO_HOME  /opt/odoo
ENV ODOO_SHELL /usr/bin/zsh

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Configure timezone and locale
RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends locales tzdata && \
    echo "Asia/Ho_Chi_Minh" > /etc/timezone && \
    # Bug: https://bugs.launchpad.net/ubuntu/+source/tzdata/+bug/1554806
    ln -fs /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8 \
                            LANGUAGE=en_US.UTF-8 \
                            LC_ALL=en_US.UTF-8 \
                            LC_CTYPE=en_US.UTF-8 \
                            LC_NUMERIC=en_US.UTF-8 \
                            LC_TIME=en_US.UTF-8 \
                            LC_COLLATE=en_US.UTF-8 \
                            LC_MONETARY=en_US.UTF-8 \
                            LC_MESSAGES=en_US.UTF-8 \
                            LC_PAPER=en_US.UTF-8 \
                            LC_NAME=en_US.UTF-8 \
                            LC_ADDRESS=en_US.UTF-8 \
                            LC_TELEPHONE=en_US.UTF-8 \
                            LC_MEASUREMENT=en_US.UTF-8 \
                            LC_IDENTIFICATION=en_US.UTF-8


# Install Linux common tools
RUN apt-get install -qq -y --no-install-recommends \
        dialog less apt-utils apt-transport-https python-dev python3-dev \
        telnet iproute2 iputils-ping traceroute netstat-nat dnsutils net-tools mtr-tiny \
        rsync zsh htop ncdu localepurge vim-nox screen tmux tig lftp keychain \
        apg man sudo openssh-server supervisor \
        build-essential libldap2-dev libsasl2-dev libssl-dev \
        default-jdk unzip thunderbird && \
    mkdir -p /var/run/supervisor /var/log/supervisor /var/run/sshd && \
    chmod 0755 /var/run/sshd /var/run/screen

# Adding config files
COPY config /etc/
COPY install_ripgrep.sh /root/install_ripgrep.sh
COPY entrypoint.sh /entrypoint.sh

# Setup Odoo system environment: PostgreSQL client, Nodejs, Python, wkhtmltopdf
RUN wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    apt-get -qq update && apt-get -y dist-upgrade && \
    apt-get install -qq -y --no-install-recommends libxrender1 fontconfig xvfb meld \
        nodejs postgresql-client-"${PGVER}" &&  \
    npm install -g eslint less less-plugin-clean-css && \
    # Python setup: pip and requirements
    curl -sL https://bootstrap.pypa.io/get-pip.py | python && \
    pip install -r /etc/requirements.txt && \
    # Install wkhtmltopdf binaries
    wget -q ${WK2PDF_URL} -O /tmp/wkhtmltopdf.tar.xz && \
    tar -C /usr/local --strip-components=1 -xvJf /tmp/wkhtmltopdf.tar.xz && \
    # fix permission
    chmod 0755 /etc/sudoers.d && chmod 0640 /etc/sudoers.d/99-airt && \
    # cleanup temporary files
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/pip

RUN /root/install_ripgrep.sh

# Odoo user setup
RUN useradd -m -d "${ODOO_HOME}" -s "${ODOO_SHELL}" "${ODOO_USER}" && \
    echo "$ODOO_USER:$ODOO_PASS" | chpasswd && \
    git clone git://github.com/robbyrussell/oh-my-zsh.git "${ODOO_HOME}"/.oh-my-zsh && \
    mkdir -p "${ODOO_HOME}"/.local/share/virtualenvs && \
    chown -R "${ODOO_USER}":"${ODOO_USER}" "${ODOO_HOME}"/.local/share "${ODOO_HOME}"/.oh-my-zsh "${ODOO_HOME}"/.local/share/virtualenvs && \
    echo 'debconf debconf/frontend select Dialog' | debconf-set-selections


# SSH: 22
# Odoo: 8069, 8072, 8072, 8073
EXPOSE 22 8069 8071 8072 8073 8074 8075 8076

ENTRYPOINT ["/entrypoint.sh"]

