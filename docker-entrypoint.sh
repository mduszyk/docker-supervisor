#!/bin/sh

if mkdir /opt/supervisor/.initialized; then
    if [ ! -z "$ROOT_PASS" ]; then
        echo "root:$ROOT_PASS" | chpasswd
    fi

    if [ ! -z "$SSHD_PORT" ]; then
        # ubuntu 
        sed -ri "s/Port 22/Port $SSHD_PORT/g" /etc/ssh/sshd_config
        # centos
        sed -ri "s/#Port 22/Port $SSHD_PORT/g" /etc/ssh/sshd_config
    fi

    if [ -z "$SSHD_FORBID_ROOT_PASS" ]; then
        # ubuntu
        sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
        # centos
        sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
    fi

    if [ ! -z "$SSHD" ]; then
        mkdir -p /var/run/sshd
        # SSH login fix. Otherwise user is kicked off after login
        sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
        cp -f /opt/supervisor/supervisord-sshd.conf /etc/supervisor/conf.d/
        /usr/bin/ssh-keygen -A
    fi

    if [ ! -z "$CRON" ]; then
        cp -f /opt/supervisor/supervisord-cron.conf /etc/supervisor/conf.d/
    fi

    # Preprocessing.
    if [ ! -z "$BOOT_SCRIPT" ] && [ -f $BOOT_SCRIPT ]; then
        echo "Executing boot script: $BOOT_SCRIPT"
        source $BOOT_SCRIPT
    elif [ -f "/opt/boot.sh" ]; then
        echo "Executing default boot script at /opt/boot.sh"
        source /opt/boot.sh
    fi
fi

exec "$@"
