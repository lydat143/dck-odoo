#!/bin/bash
# Description: Docker entrypoint for dev env

# SSH keys setup
if [[ -f /usr/local/ssh/id_rsa || -f /usr/local/ssh/id_ed25519 ]]; then
    echo "Copy your personal SSH keys into ${ODOO_USER} user .ssh folder..."
    /bin/mkdir "${ODOO_HOME}"/.ssh -p
    /bin/rm -f "${ODOO_HOME}"/.ssh/{id_rsa,id_rsa.pub,id_ed25519,id_ed25519.pub,authorized_keys}
    /usr/bin/rsync -arzh --ignore-errors --include="*/" --include="id_*" --exclude="*" /usr/local/ssh/ "${ODOO_HOME}"/.ssh/
    cat "${ODOO_HOME}"/.ssh/*.pub > "${ODOO_HOME}"/.ssh/authorized_keys 2>/dev/null
    chown -R "${ODOO_USER}":"${ODOO_USER}" "${ODOO_HOME}"/.ssh
    chmod -rwx,u+rwx -R "${ODOO_HOME}"/.ssh
    echo "SSH configured"
else
    echo "Your personal SSH keys are not mounted on this image"
    echo "Please run this image with your personal SSH keys mounted as a volume on /usr/local/ssh"
    exit
fi

# FakeSMTP
if [[ -n "${ODOO_HOME}"/code ]]; then
  mkdir "${ODOO_HOME}"/code/fakeSMTP
  chown -R "${ODOO_USER}":"${ODOO_USER}" "${ODOO_HOME}"/code
  /usr/bin/wget http://nilhcem.github.com/FakeSMTP/downloads/fakeSMTP-latest.zip /fakeSMTP-latest.zip -P "${ODOO_HOME}"/code/fakeSMTP
  unzip "${ODOO_HOME}"/code/fakeSMTP/fakeSMTP-latest.zip -d 0~"${ODOO_HOME}"/code/fakeSMTP
fi

# PostgreSQL setup
if [[ -n ${PGUSER} && -n ${PGHOST} && -n ${PGPASSWORD} ]]; then
    echo "Setting up PostgreSQL env..."
    /bin/rm -f "${ODOO_HOME}"/.pgpass
    echo "${PGHOST}:5432:*:${PGUSER}:${PGPASSWORD}" > "${ODOO_HOME}"/.pgpass
    chown "${ODOO_USER}":"${ODOO_USER}" "${ODOO_HOME}"/.pgpass
    chmod 0600 "${ODOO_HOME}"/.pgpass

    /bin/rm -f "${ODOO_HOME}"/.pg_env
    {
        echo "export PGHOST=${PGHOST}"
        echo "export PGUSER=${PGUSER}"
        echo "export PGPASSWORD=${PGPASSWORD}"
    } >> "${ODOO_HOME}"/.pg_env
fi


echo "Run supervisord services..."
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
