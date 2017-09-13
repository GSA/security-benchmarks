#!/bin/bash
# Init
# Ubuntu-Hardening.sh
# Created by ISE on 09/30s/15
# Hardening scripts originally created on https://github.com/fcaviggia/hardening-script-el6/tree/master/scripts and modified for GSA use
# Run script with root priviledges to harden system according to the GSA Ubuntu 6 Benchmark

####### Paths #######
FILE="/tmp/out.$$"
GREP="/bin/grep"

####### Checks #######
# Make sure only root can run our script
echo "Checking if you are root"
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" 1>&2
        exit 1
    else
####### Hardening #######

## CIS ID: 9.3.12 Set idle timeout interval for User Login
echo '=============================================================='
echo ' Checking CIS 9.3.12: Set idle timeout interval for User Login'
echo '=============================================================='
    if grep -q "^ClientAliveInterval 900" /etc/ssh/sshd_config; then
        echo "Already Patched"
    else
        echo "Not Found, Patching"
        echo "ClientAliveInterval 900" >> /etc/ssh/sshd_config
    fi

echo '====================================================================='
echo ' Checking CIS 9.3.12: Set inactive shell timeout ClientAliveMax     '
echo '====================================================================='
    if grep -q "^ClientAliveCountMax 3" /etc/ssh/sshd_config; then
        echo "Already Patched"
    else
        echo "Not Found, Patching"
        echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config
    fi

## CIS ID: 2.18 Verify and Modify the modprobe CIS file
echo '====================================================================='
echo ' Checking CIS 2.18: Make changes to the modprobe CIS file '
echo '====================================================================='
echo 'Checking for CIS File'
    if [ ! -f /etc/modprobe.d/CIS.conf ]; then
        echo "File Not There, Creating it"
        echo "#CIS.conf file created by RHEL Hardening Script on $(date)" >> /etc/modprobe.d/CIS.conf
    else
        echo "File Exists"
    fi
#Checking for cramfs
    echo 'Checking for cramfs'
    if grep -q "install cramfs /bin/true" /etc/modprobe.d/CIS.conf; then
        echo "It's Set"
    else
        echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
    fi

## CIS ID: 2.19 Verify and Modify the modprobe CIS file
echo '====================================================================='
echo ' Checking CIS 2.19: Make changes to the modprobe CIS file '
echo '====================================================================='
echo 'Checking for freevxfs'
    if grep -q "install freevxfs /bin/true" /etc/modprobe.d/CIS.conf; then
        echo "It's Set"
    else
        echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf
    fi

## CIS ID: 2.20 Verify and Modify the modprobe CIS file
echo '====================================================================='
echo ' Checking CIS 2.20: Make changes to the modprobe CIS file '
echo '====================================================================='
echo 'Checking for jffs2'
    if grep -q "install jffs2 /bin/true" /etc/modprobe.d/CIS.conf; then
        echo "It's Set"
    else
        echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf
    fi

## CIS ID: 2.21 Verify and Modify the modprobe CIS file
echo '====================================================================='
echo ' Checking CIS 2.21: Make changes to the modprobe CIS file '
echo '====================================================================='
    echo 'Checking for hfs'
    if grep -q "install hfs /bin/true" /etc/modprobe.d/CIS.conf; then
        echo "It's Set"
    else
        echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf
    fi

## CIS ID: 2.22 Verify and Modify the modprobe CIS file
echo '====================================================================='
echo ' Checking CIS 2.22: Make changes to the modprobe CIS file '
echo '====================================================================='
    echo 'Checking for hfsplus'
    if grep -q "install hfsplus /bin/true" /etc/modprobe.d/CIS.conf; then
        echo "It's Set"
    else
        echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf
    fi

## CIS ID: 2.23 Verify and Modify the modprobe CIS file
echo '====================================================================='
echo ' Checking CIS 2.23: Make changes to the modprobe CIS file '
echo '====================================================================='
    echo 'Checking for squashfs'
    if grep -q "install squashfs /bin/true" /etc/modprobe.d/CIS.conf; then
        echo "It's Set"
    else
        echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf
    fi

## CIS ID: 2.24 Verify and Modify the modprobe CIS file
echo '====================================================================='
echo ' Checking CIS 2.24: Make changes to the modprobe CIS file '
echo '====================================================================='
    echo 'Checking for udf'
    if grep -q "install udf /bin/true" /etc/modprobe.d/CIS.conf; then
        echo "It's Set"
    else
        echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf
    fi


l

## CIS ID: 3.2a Verify the owner of the grub configuration file
echo '============================================================'
echo ' Checking CIS 3.2a: Verify the Owner of the grub conf file'
echo '============================================================'
    uname="$(ls -ld /boot/grub/grub.cfg | awk '{print $3}')"
    if [ "$uname" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root /etc/grub.cfg
    fi

## CIS ID: 3.2b Verify the owner of the grub configuration file
echo '============================================================'
echo ' Checking CIS 3.2b: Verify the Group of the grub conf file'
echo '============================================================'
    ugroup="$(ls -ld /boot/grub/grub.cfg | awk '{print $4}')"
    if [ "$ugroup" = "root" ]; then
        echo "Group is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /boot/grub/grub.cfg
    fi

## CIS ID: 1.5.2 Verify the dss of the grub configuration file
echo '============================================================'
echo ' Checking CIS 1.5.1b: Verify the Group of the grub conf file'
echo '============================================================'
    perms="$(stat -L -c "%a" /boot/grub/grub.cfg | egrep ".00")"
    if [ "$perms" = "600" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 600 /boot/grub/grub.cfg
    fi


## CIS ID: 4.1 Disable core dumps for all uers
echo '==================================================================='
echo ' Checking CIS 1.6.1: Make changes to the security limits conf file '
echo '==================================================================='
    if grep -q "* hard core 0" /etc/security/limits.conf; then
        echo "Already Patched"
    else
        echo "Patching"
        echo "* hard core 0" >> /etc/security/limits.conf
    fi

## CIS ID: 4.3 Configure the kernel.randomize settings
echo '======================================================================'
echo ' Checking CIS 1.6.3: Configure the kernel.randomize settings '
echo '======================================================================'
    if grep -q "kernel.randomize_va_space = 2" /etc/sysctl.conf; then
        echo "Already Patched"
    else
        echo "Patching"
        echo "" >> /etc/sysctl.conf
        echo "#Kernel Randomize VA setting per CIS 1.6.3" >> /etc/sysctl.conf
        echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
    fi

## CIS ID: 5.1.6 Verify the telnet-server package is not installed
echo '============================================================='
echo ' Checking CIS 5.1.6: Checking to see if telnet-server exists.'
echo '============================================================='
    if ! dpkg -s telnet-server > /dev/null; then
        echo "Already Patched"
    else
        echo "Removing Package"
        apt-get -q -y remove telnet-server
    fi

## CIS ID: 5.1.4 Verify the talk-server package is not installed
echo '============================================================'
echo ' Checking CIS 5.1.4: Checking to see if talk-server exists.'
echo '============================================================'
    if ! dpkg -s talk-server > /dev/null; then
        echo "Already Patched"
    else
        echo "Removing Package"
        apt-get -q -y remove talk-server
    fi

## CIS ID: 5.1.8 Verify the xinetd service and package are not running or installed
echo '====================================================================='
echo ' Checking CIS 5.1.8 Checking to see if the xinetd service is running'
echo '====================================================================='
    SERVICE=xinetd;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

echo '======================================================================='
echo ' Checking CIS 5.1.8 Checking to see if the xinetd package is installed'
echo '======================================================================='
    if ! dpkg -s xinetd > /dev/null; then
        echo "Already Patched"
    else
        echo "Removing Package"
        apt-get -q -y removexinetd
    fi

## CIS ID: 2.1.12 Verify the chargen-dgram service is not running
echo '============================================================================'
echo ' Checking CIS 5.2 Checking to see if the chargen-dgram service is running'
echo '============================================================================'
    SERVICE=chargen-dgram;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

## CIS ID: 5.20 Verify the chargen-stream service is not running
echo '============================================================================='
echo ' Checking CIS 5.20 Checking to see if the chargen-stream service is running'
echo '============================================================================='
    SERVICE=chargen-stream;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

## CIS ID: 5.6 Verify the daytime-dgram service is not running
echo '============================================================================='
echo ' Checking CIS 2.1.14 Checking to see if the daytime-dgram service is running '
echo '============================================================================='
    SERVICE=daytime-dgram;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

## CIS ID: 5.30 Verify the daytime-stream service is not running
echo '============================================================================='
echo ' Checking CIS 5.30 Checking to see if the daytime-stream service is running'
echo '============================================================================='
    SERVICE=daytime-stream;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

## CIS ID: 5.4 Verify the echo-dgram service is not running
echo '============================================================================='
echo ' Checking CIS 2.1.16 Checking to see if the echo-dgram service is running    '
echo '============================================================================='
    SERVICE=echo-dgram;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

## CIS ID: 5.40 Verify the echo-stream service is not running
echo '============================================================================='
echo ' Checking CIS 5.40 Checking to see if the echo-stream service is running '
echo '============================================================================='
    SERVICE=echo-stream;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi


## CIS ID: 5.1.3 Verify the rsh package is not installed
echo '==================================================================='
echo ' Checking CIS 5.1.3 Checking to see if the rsh package is installed'
echo '==================================================================='
PACKAGE=rsh
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Already Patched"
    else
        echo "Removing Package"
        apt-get -q -y remove $PACKAGE
    fi

## CIS ID: 5.1.7 Verify the tftp package is not installed
echo '===================================================================='
echo ' Checking CIS 5.1.7 Checking to see if the tftp package is installed'
echo '===================================================================='
    PACKAGE=tftp
    if ! dpkg -s $PACKAGE > /dev/null; then
    echo "Already Patched"
    else
    echo "Removing Package"
    apt-get -q -y remove $PACKAGE
    fi

## CIS ID: 5.1.7 Verify the telnet package is not installed
echo '===================================================================================='
echo ' Checking CIS 5.1.7 Checking to see if the tftp-server package is installed         '
echo '===================================================================================='
    PACKAGE=tftp-server
    if ! dpkg -s $PACKAGE > /dev/null; then
    echo "Already Patched"
    else
    echo "Removing Package"
    apt-get -q -y remove $PACKAGE
    fi

## CIS ID: 5.1.5 Verify the talk package is not installed
echo '===================================================================================='
echo ' Checking CIS 5.1.7 Checking to see if the talk package is installed                '
echo '===================================================================================='
    PACKAGE=talk
    if ! dpkg -s $PACKAGE > /dev/null; then
    echo "Already Patched"
    else
    echo "Removing Package"
    apt-get -q -y remove $PACKAGE
    fi

## CIS ID: 3.11 Verify the http server package is not installed
echo '===================================================================================='
echo ' Checking CIS 3.11 Checking to see if the httpd package is installed                '
echo '===================================================================================='
    PACKAGE=httpd
    if ! dpkg -s $PACKAGE > /dev/null; then
    echo "Already Patched"
    else
    echo "Removing Package"
#apt-get -q -y remove $PACKAGE
    fi

## CIS ID: 6.11 Verify the Dovecot package is not installed
echo '===================================================================================='
echo ' Checking CIS 3.12 Checking to see if the Dovecot package is installed                '
echo '===================================================================================='
    PACKAGE=dovecot
    if ! dpkg -s $PACKAGE > /dev/null; then
    echo "Already Patched"
    else
    echo "Removing Package"
    apt-get -q -y remove $PACKAGE
    fi

## CIS ID: 6.12 Verify the Samba package is not installed
echo '===================================================================================='
echo ' Checking CIS 3.13 Checking to see if the Samba package is installed                '
echo '===================================================================================='
    PACKAGE=samba.x86_64
    if ! dpkg -s $PACKAGE > /dev/null; then
    echo "Already Patched"
    else
    echo "Removing Package"
    apt-get -q -y remove $PACKAGE
    fi

## CIS ID: 6.13 Verify the Samba package is not installed
echo '===================================================================================='
echo ' Checking CIS 6.13 Checking to see if the Squid package is installed                '
echo '===================================================================================='
    PACKAGE=squid
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Already Patched"
    else
        echo "Removing Package"
        apt-get -q -y remove $PACKAGE
    fi

## CIS ID: 6.14 Verify the net-snmp package is not installed
echo '===================================================================================='
echo ' Checking CIS 6.14 Checking to see if the net-snmp package is installed                '
echo '===================================================================================='
    PACKAGE=net-snmp
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Already Patched"
    else
        echo "Removing Package"
        apt-get -q -y remove $PACKAGE
    fi


## CIS ID: 6.2 Verify the service Avahi is not running
echo '================================================================='
echo ' Checking CIS 6.2 Checking to see if the Avahi service is running'
echo '================================================================='

SERVICE=avahi-daemon;
    if ps ax | grep -v grep | grep avahi-daemon > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        chkconfig avahi-daemon off
    else
        echo "$SERVICE is not running"
    fi
uservice="$(grep "start on" /etc/init/avahi-daemon.conf | awk '{print $3}')"
if  [ "$uservice" = "(filesystem" ]; then
echo "Already Patched"
else
echo "Patching"
sed -i "/start on/ c\start on (filesystem" /etc/init/avahi-daemon.conf
fi


## CIS ID: 6.3 Verify the service CUPS is not running
echo '================================================================'
echo ' Checking CIS 6.3 Checking to see if the Cups service is running'
echo '================================================================'
    SERVICE=cups;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

## CIS ID: 6.5 Verify the printer server NTPD is  running
echo '================================================================'
echo ' Checking CIS 6.5 Checking to see if the ntpd service is running'
echo '================================================================'
    SERVICE=ntpd;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE start
        update-rc.d $SERVICE enable
    else
        echo "$SERVICE is not running"

    fi

## CIS ID: 6.8 Verify the DNS Server package is not installed
echo '===================================================================================='
echo ' Checking CIS 6.8 Checking to see if the Bind package is installed                 '
echo '===================================================================================='
    PACKAGE=bind.x86_64
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Already Patched"
    else
        echo "Removing Package"
        apt-get -q -y remove $PACKAGE
    fi

## CIS ID: 4.1.1 Configure the execshield settings
echo '========================================================================='
echo ' Checking CIS 4.1.1: Configure the net.ipv4.ip_forward settings '
echo '========================================================================='
    if grep -q "net.ipv4.ip_forward = 0" /etc/sysctl.conf; then
        echo "Already Patched"
    else
        echo "Patching"
       sed -i "/net.ipv4.ip_forward =/ c\net.ipv4.ip_forward = 0" /etc/sysctl.conf
    fi

## CIS ID: 7.2.1 Configure the execshield settings
echo '========================================================================================'
echo ' Checking CIS 7.2.1: Configure the net.ipv4.ip_default.send_redirects settings '
echo '========================================================================================'
    if grep -q 'net.ipv4.conf.default.send_redirects = 0' /etc/sysctl.conf; then
        echo "Already Patched"
    else
        echo "Patching"
        echo "" >> /etc/sysctl.conf
        echo "#net.ipv4.ip_default.send_redirects setting perscribed by CIS 4.1.2" >> /etc/sysctl.conf
        echo 'net.ipv4.conf.default.send_redirects = 0' >> /etc/sysctl.conf
    fi

## CIS ID: CIS and DISA Sysctl configs
echo '============================================================'
echo ' Sysctl Configs'
echo '============================================================'
# Backup Existing Sysctl File
    cp /etc/sysctl.conf /etc/sysctl.conf.$(date +"%Y%m%d")

# Writing New File
cat <<EOF > /etc/sysctl.conf
# Controls source route verification
net.ipv4.conf.default.rp_filter = 1

# Do not accept source routing
net.ipv4.conf.default.accept_source_route = 0

# Controls the System Request debugging functionality of the kernel
kernel.sysrq = 0

# Controls whether core dumps will append the PID to the core filename.
# Useful for debugging multi-threaded applications.
kernel.core_uses_pid = 1

# Controls the use of TCP syncookies
net.ipv4.tcp_syncookies = 1

# Controls the default maxmimum size of a mesage queue
kernel.msgmnb = 65536

# Controls the maximum size of a message, in bytes
kernel.msgmax = 65536

# Controls the maximum shared segment size, in bytes
kernel.shmmax = 68719476736

# Controls the maximum number of shared memory segments, in pages
kernel.shmall = 4294967296

#Kernel Randomize VA setting per CIS 1.6.3
kernel.randomize_va_space = 2

#net.ipv4.ip_default.send_redirects setting perscribed by CIS 4.4.2
net.ipv4.conf.default.send_redirects = 0

#Controls Added for GSA Bencharmk
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
net.ipv4.route.flush = 1
net.ipv4.ip_forward = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.tcp_syncookies = 1
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
EOF

## CIS ID: 7.4.1 Verify the tcp_wrappers package is not installed
echo '============================================================================'
echo ' Checking CIS 4.5.1 Checking to see if the Tcp_wrappers package is installed'
echo '============================================================================'
    PACKAGE=tcpd
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Patching"
        apt-get -q -y install $PACKAGE
    else
        echo "Already Patched"
    fi

## CIS ID: 8.3.1 Verify the aide package is not installed
echo '============================================================='
echo ' Checking CIS: 8.3.1 Verify the aide package is not installed'
echo '============================================================='
    PACKAGE=aide
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Patching"
        apt-get -q -y install $PACKAGE
    else
        echo "Already Patched"
    fi

## CIS ID: 7.4.3 Verify the permissions of the /etc/hosts.allow configuration file
echo '==============================================================================='
echo ' Checking CIS 7.4.3 Verify the permissions of the hosts.allow file    '
echo '==============================================================================='
    perms="$(stat -L -c "%a" /etc/hosts.allow | egrep ".44")"
        if [ "$perms" = "644" ]; then
    echo "Already Patched"
    else
    echo "Patching"
    chmod 644 /etc/hosts.allow
    fi

## CIS ID: 7.4.5 Verify the permissions of the hosts.deny file
echo '====================================================================='
echo ' Checking CIS 7.4.5: Verify the perms of the hosts.deny file'
echo '====================================================================='
    perms="$(stat -L -c "%a" /etc/hosts.deny | egrep ".44")"
    if [ "$perms" = "644" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 644 /etc/hosts.deny
    fi

## CIS ID: 7.5.1 Verify and Modify the modprobe CIS file
echo '====================================================================='
echo ' Checking CIS 7.5.1: Make changes to the modprobe CIS file  '
echo '====================================================================='
    echo 'Checking for CIS File'
    if [ ! -f /etc/modprobe.d/CIS.conf ]; then
        echo "File Not There, Creating it"
        echo "#CIS.conf file created by RHEL Hardening Script on $(date)" >> /etc/modprobe.d/CIS.conf
    else
        echo "File Exists"
    fi
    #Checking for DCCP
        echo 'Checking for DCCP'
    if grep -q "install dccp /bin/true" /etc/modprobe.d/CIS.conf; then
        echo "It's Set"
    else
        echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
    fi
## CIS ID: 4.6.2 Verify and Modify the modprobe CIS file
echo '====================================================================='
echo ' Checking CIS 4.6.2: Make changes to the modprobe CIS file  '
echo '====================================================================='
        echo 'Checking for SCTP'
    if grep -q "install sctp /bin/true" /etc/modprobe.d/CIS.conf; then
        echo "It's Set"
    else
        echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
    fi
## CIS ID: 4.6.3 Verify and Modify the modprobe CIS file
echo '====================================================================='
echo ' Checking CIS 4.6.3: Make changes to the modprobe CIS file  '
echo '====================================================================='
        echo 'Checking for RDS'
    if grep -q "install rds /bin/true" /etc/modprobe.d/CIS.conf; then
        echo "It's Set"
    else
        echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
    fi
## CIS ID: 4.6.4 Verify and Modify the modprobe CIS file
echo '====================================================================='
echo ' Checking CIS 4.6.4: Make changes to the modprobe CIS file  '
echo '====================================================================='
echo 'Checking for tipc'
    if grep -q "install tipc /bin/true" /etc/modprobe.d/CIS.conf; then
        echo "It's Set"
    else
        echo "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf
    fi


## CIS ID: 8.2.4 Verify the owner of the audit files
echo '======================================================='
echo ' Checking CIS 8.2.4 Verify the owner of the audit files'
echo '======================================================='
    uname="$(ls -ld /var/log/auth.log | awk '{print $3}')"
    ugroup="$(ls -ld /var/log/auth.log | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /var/log/auth.log;
    fi
    uname="$(ls -ld /var/log/boot.log | awk '{print $3}')"
    ugroup="$(ls -ld /var/log/boot.log | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /var/log/boot.log;
    fi
    uname="$(ls -ld /var/log/mail.log | awk '{print $3}')"
    ugroup="$(ls -ld /var/log/mail.log | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /var/log/mail.log;
    fi
    uname="$(ls -ld /var/log/dpkg.log | awk '{print $3}')"
    ugroup="$(ls -ld /var/log/dpkg.log | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /var/log/dpkg.log;
    fi
    uname="$(ls -ld /var/log/syslog | awk '{print $3}')"
    ugroup="$(ls -ld /var/log/syslog | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /var/log/syslog;
    fi
## CIS ID: 5.2.1.1 Verify the number of logs kept
echo '================================================'
echo ' Checking 5.2.1.1 Verify the number of logs kept'
echo '================================================'
    if grep -q "num_logs = 5" /etc/audit/auditd.conf; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i "/num_logs/ c\num_logs = 5" /etc/audit/auditd.conf
    fi

## CIS ID: 8.1.2 Verify the auditd service is running
echo '==================================================='
echo ' CIS ID: 8.1.2 Verify the auditd service is running'
echo '==================================================='
    Status="$(update-rc.d --list auditd | awk '{print $5}')"
    if [ "$Status" = "3:on" ]; then
            echo "Service is set to run"
    else
            echo "Service is not set"
            chkconfig auditd on
            service auditd restart
    fi

## CIS ID: 6.5 Verify the ntp package is not installed
echo '============================================================='
echo ' Checking CIS: 6.5 Verify the ntp package is not installed'
echo '============================================================='
PACKAGE=ntp
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Patching"
        apt-get -q -y install $PACKAGE
    else
        echo "Already Patched"
    fi

## CIS ID: 6.5 Verify the ntp package is not installed
echo '============================================================='
echo ' Checking CIS: 6.5 Verify the ntp package is not installed'
echo '============================================================='
PACKAGE=auditd
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Patching"
        apt-get -q -y install $PACKAGE
    else
    echo "Already Patched"
        fi

## CIS ID: 5.2.4-5.2.18 Configuring Audit Settings in the Audit.file
echo '============================================================'
echo ' 5.2.1.1-5.2.18 Configuring Audit Settings in the Audit.file'
echo '============================================================'
#Checking if /etc/audit exists
    if [ ! -d /etc/audit ]; then
        echo "Not Found, Creating"
        mkdir /etc/audit
    else
        echo "Directory Exists"
    fi
    # Backup Existing Audit File
    if [ ! -f /etc/audit.rules ]; then
        echo "File does not exist"
    else
        echo "File exists, backing up"
        cp /etc/audit/audit.rules /etc/audit/audit.rules.$(date +"%Y%m%d")
    fi

# Writing New File
cat <<EOF > /etc/audit/audit.rules
# This file contains the auditctl rules that are loaded
# whenever the audit daemon is started via the initscripts.
# The rules are simply the parameters that would be passed
# to auditctl.

# First rule - delete all
-D

# Increase the buffers to survive stress events.
# Make this bigger for busy systems
-b 320

# Feel free to add below this line. See auditctl man page


# 8.1.4 Record Events That Modify Date and Time Information
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change
-a always,exit -F arch=b64 -S clock_settime -k time-change
-a always,exit -F arch=b32 -S clock_settime -k time-change
-w /etc/localtime -p wa -k time-change

# 8.1.5 Record Events That Modify User/Group Information
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity

# 8.1.6 Record Events That Modify the System's Network Environment
-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale

# 8.1.7 Record Events That Modify the System's Mandatory Access Controls
-w /etc/selinux/ -p wa -k MAC-policy

# 8.1.8 Collect Login and Logout Events
-w /var/log/faillog -p wa -k logins
-w /var/log/lastlog -p wa -k logins
-w /var/log/tallylog -p wa -k logins

# 8.1.9 Collect Session Initiation Information
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k session
-w /var/log/btmp -p wa -k session

# 8.1.10 Collect Discretionary Access Control Permission Modification Events
-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod

# 8.1.11 Collect Unsuccessful Unauthorized Access Attempts to Files
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate \-F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate \-F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate \-F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate \-F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access

# 8.1.13 Collect Successful File System Mounts
-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts
-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts

# 8.1.14 Collect File Deletion Events by User
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-a always,exit -F arch=ARCH -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-a always,exit -F arch=ARCH -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid=0 -k delete

# 8.1.15 Collect Changes to System Administration Scope
-w /etc/sudoers -p wa -k scope

# 8.1.16 Collect System Administrator Actions
-w /var/log/sudo.log -p wa -k actions

# 8.1.17 Collect Kernel Module Loading and Unloading
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
-a always,exit -F arch=b64 -S init_module -S delete_module -k modules

# 8.1.18 Make the Audit Configuration Immutable
-e 2
EOF

## CIS ID: 8.4 Verify the Logrotate is configured
echo '===================================================='
echo ' Checking CIS 8.4 Verify the Logrotate is configured'
echo '===================================================='
# Var/messages
    if grep -q "/var/log/messages" /etc/logrotate.d/syslog; then
        echo "Messages is configured"
    else
        echo "Patching Messages"
        echo "/var/log/messasges" >> /etc/logrotate.d/syslog
    fi
# Var/security
    if grep -q "/var/log/security" /etc/logrotate.d/syslog; then
        echo "Security is configured"
    else
        echo "Patching Security"
        echo "/var/log/security" >> /etc/logrotate.d/syslog
    fi
# Var/maillog
    if grep -q "/var/log/maillog" /etc/logrotate.d/syslog; then
        echo "Maillog is configured"
    else
        echo "Patching maillog"
        echo "/var/log/maillog" >> /etc/logrotate.d/syslog
    fi
# Var/spooler
    if grep -q "/var/log/spooler" /etc/logrotate.d/syslog; then
        echo "Spooler is configured"
    else
        echo "Patching spooler"
        echo "/var/log/spooler" >> /etc/logrotate.d/syslog
    fi
# Var/boot.log
    if grep -q "/var/log/boot.log" /etc/logrotate.d/syslog; then
        echo "Boot Lob is configured"
    else
        echo "Patching boot.log"
        echo "/var/log/boot.log" >> /etc/logrotate.d/syslog
    fi
# Var/cron
    if grep -q "/var/log/cron" /etc/logrotate.d/syslog; then
        echo "Cron is configured"
    else
        echo "Patching Cron"
        echo "/var/log/cron" >> /etc/logrotate.d/syslog
    fi


## CIS ID: 9.1.1 Verify the cron service is running
echo '============================================================================='
echo ' Checking CIS 9.1.1 Checking to see if the cron service is running        '
echo '============================================================================='
    uservice="$(grep "start on runlevel" /etc/init/cron.conf | awk '{print $4}')"
    if  [ "$uservice" = "[2345]" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i "/start on runlevel/ c\start on runlevel [2345]" /etc/init/cron.conf
    fi

## CIS ID: 6.1.3b Verify the permissions of the crontab configuration file
echo '==========================================================================='
echo ' Checking CIS 6.1.3 Verify the permissions of the anacrontab file '
echo '==========================================================================='
    perms="$(stat -L -c "%a" /etc/anacrontab | egrep ".00")"
        if [ "$perms" = "600" ]; then
    echo "Already Patched"
    else
    echo "Patching"
    chmod 600 /etc/anacrontab
    fi
## CIS ID: 9.1.2a Verify the owner of the crontab configuration file
echo '====================================================================='
echo ' Checking CIS 9.1.2 Verify the owner of the crontab file    '
echo '====================================================================='
    uname="$(ls -ld /etc/crontab | awk '{print $3}')"
    ugroup="$(ls -ld /etc/crontab | awk '{print $4}')"
if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/crontab;
    fi
## CIS ID: 9.1.2b Verify the permissions of the crontab configuration file
echo '======================================================================='
echo ' Checking CIS 9.1.2 Verify the permissions of the crontab file '
echo '======================================================================='
    perms="$(stat -L -c "%a" /etc/crontab | egrep ".00")"
        if [ "$perms" = "600" ]; then
    echo "Already Patched"
    else
    echo "Patching"
    chmod 600 /etc/crontab
    fi

## CIS ID: 9.1.3a Verify the owner of the crontab.hourly configuration file
echo '============================================================================'
echo ' Checking CIS 9.1.3 Verify the owner of the cron.hourly file       '
echo '============================================================================'
    uname="$(ls -ld /etc/cron.hourly | awk '{print $3}')"
    ugroup="$(ls -ld /etc/cron.hourly | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/cron.hourly;
    fi
## CIS ID: 9.1.3b Verify the permissions of the crontab.hourly configuration file
echo '=============================================================================='
echo ' Checking CIS 9.1.3 Verify the permissions of the cron.hourly file    '
echo '=============================================================================='
    perms="$(stat -L -c "%a" /etc/cron.hourly | egrep ".00")"
        if [ "$perms" = "600" ]; then
    echo "Already Patched"
    else
    echo "Patching"
    chmod 600 /etc/cron.hourly
    fi

## CIS ID: 9.1.4a Verify the owner of the crontab.daily configuration file
echo '============================================================================'
echo ' Checking CIS 9.1.4 Verify the owner of the cron.daily file        '
echo '============================================================================'
    uname="$(ls -ld /etc/cron.daily | awk '{print $3}')"
    ugroup="$(ls -ld /etc/cron.daily | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/cron.daily;
    fi
## CIS ID: 9.1.4b Verify the permissions of the crontab.daily configuration file
echo '============================================================================='
echo ' Checking CIS 9.1.4 Verify the permissions of the cron.daily file    '
echo '============================================================================='
    perms="$(stat -L -c "%a" /etc/cron.daily | egrep ".00")"
        if [ "$perms" = "600" ]; then
    echo "Already Patched"
    else
    echo "Patching"
    chmod 600 /etc/cron.daily
    fi

## CIS ID: 9.1.5a Verify the owner of the crontab.weekly configuration file
echo '============================================================================'
echo ' Checking CIS 9.1.5 Verify the owner of the cron.weekly file    '
echo '============================================================================'
    uname="$(ls -ld /etc/cron.weekly | awk '{print $3}')"
    ugroup="$(ls -ld /etc/cron.weekly | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/cron.weekly;
    fi
## CIS ID: 9.1.5b Verify the permissions of the crontab.weekly configuration file
echo '============================================================================'
echo ' Checking CIS 9.1.5 Verify the permissions of the cron.weekly   '
echo '============================================================================'
    perms="$(stat -L -c "%a" /etc/cron.weekly | egrep ".00")"
        if [ "$perms" = "600" ]; then
    echo "Already Patched"
    else
    echo "Patching"
    chmod 600 /etc/cron.weekly
    fi

## CIS ID: 9.1.6a Verify the owner of the cron.monthly configuration file
echo '============================================================================'
echo ' Checking CIS 9.1.6 Verify the owner of the cron.monthly file      '
echo '============================================================================'
    uname="$(ls -ld /etc/cron.monthly | awk '{print $3}')"
    ugroup="$(ls -ld /etc/cron.monthly | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/cron.monthly;
    fi
## CIS ID: 9.1.6b Verify the permissions of the cron.monthly configuration file
echo '============================================================================'
echo ' Checking CIS 9.1.6 Verify the permissions of the cron.monthly      '
echo '============================================================================'
    perms="$(stat -L -c "%a" /etc/cron.monthly | egrep ".00")"
        if [ "$perms" = "600" ]; then
    echo "Already Patched"
    else
    echo "Patching"
    chmod 600 /etc/cron.monthly
    fi


## CIS ID: 6.1.9a Verify the owner of the cron.d configuration file
echo '============================================================================'
echo ' Checking CIS 6.1.9 Verify the owner of the cron.d file            '
echo '============================================================================'
    uname="$(ls -ld /etc/cron.d | awk '{print $3}')"
    ugroup="$(ls -ld /etc/cron.d | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/cron.d;
    fi
## CIS ID: 6.1.9b Verify the permissions of the cron.d configuration file
echo '============================================================================'
echo ' Checking CIS 6.1.9 Verify the permissions of the cron.d            '
echo '============================================================================'
    perms="$(stat -L -c "%a" /etc/cron.d | egrep ".00")"
    if [ "$perms" = "600" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 600 /etc/cron.d
    fi

## CIS ID: 9.1.8 Restrict at/cron to Authorized Users
echo '============================================================================'
echo ' Checking CIS 9.1.8 Verify the permissions of the cron.d            '
echo '============================================================================'
# Remove at.deny file
    if [ ! -f /etc/at.deny ]; then
        echo "File Not Found, Patched"
    else
        echo "File Found, Removing!"
        rm -f /etc/at.deny
    fi
# Remove cron.deny file
    if [ ! -f /etc/cron.deny ]; then
        echo "File Not Found, Patched"
    else
        echo "File Found, Removing!"
        rm -f /etc/cron.deny
    fi
# Creating at.allow
    if [ ! -f /etc/at.allow ]; then
        echo "File Not Found, Patching"
        echo "#at.allow file created by RHEL Hardening Script on $(date)" >> /etc/at.allow
    else
        echo "File Found, Patched"
    fi
# Creating cron.allow
    if [ ! -f /etc/cron.allow ]; then
        echo "File Not Found, Patching"
        echo "#cron.allow file created by RHEL Hardening Script on $(date)" >> /etc/cron.allow
    else
        echo "File Found, Patched"
    fi
# Check ownership of at.allow
    uname="$(ls -ld /etc/at.allow | awk '{print $3}')"
    ugroup="$(ls -ld /etc/at.allow | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/at.allow;
    fi
# Check ownership of at.cron
    uname="$(ls -ld /etc/cron.allow | awk '{print $3}')"
    ugroup="$(ls -ld /etc/cron.allow | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/cron.allow;
    fi
# Check permissions of at.allow
    perms="$(stat -L -c "%a" /etc/at.allow | egrep ".00")"
    if [ "$perms" = "600" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 600 /etc/at.allow
    fi
# Check permissions of cron.allow
    perms="$(stat -L -c "%a" /etc/cron.allow | egrep ".00")"
    if [ "$perms" = "600" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 600 /etc/cron.allow
    fi

## CIS ID: 9.2.1 Set password creation requirements parameters using pam_craklib
echo '==================================================================================='
echo ' Checking CIS 9.2.1 Set password creation requirements parameters using pam_craklib'
echo '==================================================================================='
# Backing Up File
cp /etc/pam.d/common-password /etc/pam.d/common-password.$(date +"%Y%m%d")
echo "Creating common password file"
cat <<EOF > /etc/pam.d/common-password
#
# /etc/pam.d/common-password - password-related modules common to all services
#
# This file is included from other service-specific PAM config files,
# and should contain a list of modules that define the services to be
# used to change user passwords.  The default is pam_unix.

# Explanation of pam_unix options:
#
# The "sha512" option enables salted SHA512 passwords.  Without this option,
# the default is Unix crypt.  Prior releases used the option "md5".
#
# The "obscure" option replaces the old 'OBSCURE_CHECKS_ENAB' option in
# login.defs.
#
# See the pam_unix manpage for other options.

# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.
# To take advantage of this, it is recommended that you configure any
# local modules either before or after the default block, and use
# pam-auth-update to manage selection of other modules.  See
# pam-auth-update(8) for details.

# here are the per-package modules (the "Primary" block)
#password       [success=1 default=ignore]      pam_unix.so obscure sha512
password        sufficient                      pam_unix.so obscure sha512 remember=5
password        required                        pam_cracklib.so retry=3 minlen=14 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1
# here's the fallback if no module succeeds
password        requisite                       pam_deny.so
# prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success code
# since the modules above will each just jump around
password        required                        pam_permit.so
# and here are more per-package modules (the "Additional" block)
password        optional        pam_gnome_keyring.so
# end of pam-auth-update config
EOF


# Backing Up File auth file
cp /etc/pam.d/common-auth /etc/pam.d/common-auth.$(date +"%Y%m%d")
cat <<EOF > /etc/pam.d/common-auth
#
# /etc/pam.d/common-auth - authentication settings common to all services
#
# This file is included from other service-specific PAM config files,
# and should contain a list of the authentication modules that define
# the central authentication scheme for use on the system
# (e.g., /etc/shadow, LDAP, Kerberos, etc.).  The default is to use the
# traditional Unix authentication mechanisms.
#
# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.
# To take advantage of this, it is recommended that you configure any
# local modules either before or after the default block, and use
# pam-auth-update to manage selection of other modules.  See
# pam-auth-update(8) for details.

# here are the per-package modules (the "Primary" block)
auth    [success=1 default=ignore]      pam_unix.so nullok_secure
# here's the fallback if no module succeeds
auth    requisite                       pam_deny.so
# prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success code
# since the modules above will each just jump around
auth    required                        pam_permit.so
# and here are more per-package modules (the "Additional" block)
auth    optional                        pam_cap.so
# end of pam-auth-update config

EOF

echo "Backing up and creating newlogin file"
# Backing Up File
cp /etc/pam.d/login /etc/pam.d/login.$(date +"%Y%m%d")
cat <<EOF > /etc/pam.d/login
# The PAM configuration file for the Shadow 'login' service
#

# Enforce a minimal delay in case of failure (in microseconds).
# (Replaces the 'FAIL_DELAY' setting from login.defs)
# Note that other modules may require another minimal delay. (for example,
# to disable any delay, you should add the nodelay option to pam_unix)
auth       optional   pam_faildelay.so  delay=3000000

# Outputs an issue file prior to each login prompt (Replaces the
# ISSUE_FILE option from login.defs). Uncomment for use
# auth       required   pam_issue.so issue=/etc/issue

# Disallows root logins except on tty's listed in /etc/securetty
# (Replaces the 'CONSOLE' setting from login.defs)
#
# With the default control of this module:
#   [success=ok new_authtok_reqd=ok ignore=ignore user_unknown=bad default=die]
# root will not be prompted for a password on insecure lines.
# if an invalid username is entered, a password is prompted (but login
# will eventually be rejected)
#
# You can change it to a "requisite" module if you think root may mis-type
# her login and should not be prompted for a password in that case. But
# this will leave the system as vulnerable to user enumeration attacks.
#
# You can change it to a "required" module if you think it permits to
# guess valid user names of your system (invalid user names are considered
# as possibly being root on insecure lines), but root passwords may be
# communicated over insecure lines.
auth [success=ok new_authtok_reqd=ok ignore=ignore user_unknown=bad default=die] pam_securetty.so

# Disallows other than root logins when /etc/nologin exists
# (Replaces the 'NOLOGINS_FILE' option from login.defs)
auth       requisite  pam_nologin.so

# SELinux needs to be the first session rule. This ensures that any
# lingering context has been cleared. Without out this it is possible
# that a module could execute code in the wrong domain.
# When the module is present, "required" would be sufficient (When SELinux
# is disabled, this returns success.)
session [success=ok ignore=ignore module_unknown=ignore default=bad] pam_selinux.so close

# This module parses environment configuration file(s)
# and also allows you to use an extended config
# file /etc/security/pam_env.conf.
#
# parsing /etc/environment needs "readenv=1"
session       required   pam_env.so readenv=1
# locale variables are also kept into /etc/default/locale in etch
# reading this file *in addition to /etc/environment* does not hurt
session       required   pam_env.so readenv=1 envfile=/etc/default/locale

# Standard Un*x authentication.
@include common-auth

# This allows certain extra groups to be granted to a user
# based on things like time of day, tty, service, and user.
# Please edit /etc/security/group.conf to fit your needs
# (Replaces the 'CONSOLE_GROUPS' option in login.defs)
auth       optional   pam_group.so

# Uncomment and edit /etc/security/time.conf if you need to set
# time restrainst on logins.
# (Replaces the 'PORTTIME_CHECKS_ENAB' option from login.defs
# as well as /etc/porttime)
# account    requisite  pam_time.so
# Uncomment and edit /etc/security/time.conf if you need to set
# time restrainst on logins.
# (Replaces the 'PORTTIME_CHECKS_ENAB' option from login.defs
# as well as /etc/porttime)
# account    requisite  pam_time.so

# Uncomment and edit /etc/security/access.conf if you need to
# set access limits.
# (Replaces /etc/login.access file)
# account  required       pam_access.so

# Sets up user limits according to /etc/security/limits.conf
# (Replaces the use of /etc/limits in old login)
session    required   pam_limits.so

# Prints the last login info upon succesful login
# (Replaces the 'LASTLOG_ENAB' option from login.defs)
session    optional   pam_lastlog.so

# Prints the message of the day upon succesful login.
# (Replaces the 'MOTD_FILE' option in login.defs)
# This includes a dynamically generated part from /run/motd.dynamic
# and a static (admin-editable) part from /etc/motd.
session    optional   pam_motd.so  motd=/run/motd.dynamic noupdate
session    optional   pam_motd.so

# Prints the status of the user's mailbox upon succesful login
# (Replaces the 'MAIL_CHECK_ENAB' option from login.defs).
#
# This also defines the MAIL environment variable
# However, userdel also needs MAIL_DIR and MAIL_FILE variables
# in /etc/login.defs to make sure that removing a user
# also removes the user's mail spool file.
# See comments in /etc/login.defs
session    optional   pam_mail.so standard
# Standard Un*x account and session
@include common-account
@include common-session
@include common-password

# SELinux needs to intervene at login time to ensure that the process
# starts in the proper default security context. Only sessions which are
# intended to run in the user's context should be run after this.
session [success=ok ignore=ignore module_unknown=ignore default=bad] pam_selinux.so open
# When the module is present, "required" would be sufficient (When SELinux
# is disabled, this returns success.)

#CIS 9.2.2 Account lockout and timeout settings
auth required pam_tally2.so onerr=fail audit silent deny=5 unlock_time=900

EOF

#echo "Creating login file"
# Backing Up File
cp /etc/pam.d/su /etc/pam.d/su.$(date +"%Y%m%d")
cat <<EOF > /etc/pam.d/su
#
# The PAM configuration file for the Shadow 'su' service
#

# This allows root to su without passwords (normal operation)
auth       sufficient pam_rootok.so

# Uncomment this to force users to be a member of group root
# before they can use 'su'. You can also add "group=foo"
# to the end of this line if you want to use a group other
# than the default "root" (but this may have side effect of
# denying "root" user, unless she's a member of "foo" or explicitly
# permitted earlier by e.g. "sufficient pam_rootok.so").
# (Replaces the 'SU_WHEEL_ONLY' option from login.defs)
auth       required   pam_wheel.so use_uid

# Uncomment this if you want wheel members to be able to
# su without a password.
# auth       sufficient pam_wheel.so trust

# Uncomment this if you want members of a specific group to not
# be allowed to use su at all.
# auth       required   pam_wheel.so deny group=nosu

# Uncomment and edit /etc/security/time.conf if you need to set
# time restrainst on su usage.
# (Replaces the 'PORTTIME_CHECKS_ENAB' option from login.defs
# as well as /etc/porttime)
# account    requisite  pam_time.so

# This module parses environment configuration file(s)
# and also allows you to use an extended config
# file /etc/security/pam_env.conf.
#
# parsing /etc/environment needs "readenv=1"
session       required   pam_env.so readenv=1
# locale variables are also kept into /etc/default/locale in etch
# reading this file *in addition to /etc/environment* does not hurt
session       required   pam_env.so readenv=1 envfile=/etc/default/locale

# Defines the MAIL environment variable
# However, userdel also needs MAIL_DIR and MAIL_FILE variables
# in /etc/login.defs to make sure that removing a user
# also removes the user's mail spool file.
# See comments in /etc/login.defs
#
# "nopen" stands to avoid reporting new mail when su'ing to another user
session    optional   pam_mail.so nopen

# Sets up user limits, please uncomment and read /etc/security/limits.conf
# to enable this functionality.
# (Replaces the use of /etc/limits in old login)
# session    required   pam_limits.so

# The standard Unix authentication modules, used with
# NIS (man nsswitch) as well as normal /etc/passwd and
# /etc/shadow entries.
@include common-auth
@include common-account
@include common-session

EOF

## CIS Login Defs
echo '================================='
echo ' Checking For Correct Login.defs '
echo '================================='
# Backing Up File
echo "Backing Up Login.Defs"
cp /etc/login.defs /etc/login.defs.$(date +"%Y%m%d")
cat <<EOF > /etc/login.defs
#
# /etc/login.defs - Configuration control definitions for the login package.
#
# Three items must be defined:  MAIL_DIR, ENV_SUPATH, and ENV_PATH.
# If unspecified, some arbitrary (and possibly incorrect) value will
# be assumed.  All other items are optional - if not specified then
# the described action or option will be inhibited.
#
# Comment lines (lines beginning with "#") and blank lines are ignored.
#
# Modified for Linux.  --marekm

# REQUIRED for useradd/userdel/usermod
#   Directory where mailboxes reside, _or_ name of file, relative to the
#   home directory.  If you _do_ define MAIL_DIR and MAIL_FILE,
#   MAIL_DIR takes precedence.
#
#   Essentially:
#      - MAIL_DIR defines the location of users mail spool files
#        (for mbox use) by appending the username to MAIL_DIR as defined
#        below.
#      - MAIL_FILE defines the location of the users mail spool files as the
#        fully-qualified filename obtained by prepending the user home
#        directory before $MAIL_FILE
#
# NOTE: This is no more used for setting up users MAIL environment variable
#       which is, starting from shadow 4.0.12-1 in Debian, entirely the
#       job of the pam_mail PAM modules
#       See default PAM configuration files provided for
#       login, su, etc.
#
# This is a temporary situation: setting these variables will soon
# move to /etc/default/useradd and the variables will then be
# no more supported
MAIL_DIR        /var/mail
#MAIL_FILE      .mail

#
# Enable logging and display of /var/log/faillog login failure info.
# This option conflicts with the pam_tally PAM module.
#
FAILLOG_ENAB		yes

#
# Enable display of unknown usernames when login failures are recorded.
#
# WARNING: Unknown usernames may become world readable.
# See #290803 and #298773 for details about how this could become a security
# concern
LOG_UNKFAIL_ENAB	no

#
# Enable logging of successful logins
#
LOG_OK_LOGINS		no

#
# Enable "syslog" logging of su activity - in addition to sulog file logging.
# SYSLOG_SG_ENAB does the same for newgrp and sg.
#
SYSLOG_SU_ENAB		yes
SYSLOG_SG_ENAB		yes

#
# If defined, all su activity is logged to this file.
#
#SULOG_FILE	/var/log/sulog

#
# If defined, file which maps tty line to TERM environment parameter.
# Each line of the file is in a format something like "vt100  tty01".
#
#TTYTYPE_FILE	/etc/ttytype

#
# If defined, login failures will be logged here in a utmp format
# last, when invoked as lastb, will read /var/log/btmp, so...
#
FTMP_FILE	/var/log/btmp

#
# If defined, the command name to display when running "su -".  For
# example, if this is defined as "su" then a "ps" will display the
# command is "-su".  If not defined, then "ps" would display the
# name of the shell actually being run, e.g. something like "-sh".
#
SU_NAME		su

#
# If defined, file which inhibits all the usual chatter during the login
# sequence.  If a full pathname, then hushed mode will be enabled if the
# user's name or shell are found in the file.  If not a full pathname, then
# hushed mode will be enabled if the file exists in the user's home directory.
#
HUSHLOGIN_FILE	.hushlogin
#HUSHLOGIN_FILE	/etc/hushlogins

#
# *REQUIRED*  The default PATH settings, for superuser and normal users.
#
# (they are minimal, add the rest in the shell startup files)
ENV_SUPATH	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV_PATH	PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

#
# Terminal permissions
#
#	TTYGROUP	Login tty will be assigned this group ownership.
#	TTYPERM		Login tty will be set to this permission.
#
# If you have a "write" program which is "setgid" to a special group
# which owns the terminals, define TTYGROUP to the group number and
# TTYPERM to 0620.  Otherwise leave TTYGROUP commented out and assign
# TTYPERM to either 622 or 600.
#
# In Debian /usr/bin/bsd-write or similar programs are setgid tty
# However, the default and recommended value for TTYPERM is still 0600
# to not allow anyone to write to anyone else console or terminal

# Users can still allow other people to write them by issuing
# the "mesg y" command.

TTYGROUP	tty
TTYPERM		0600

#
# Login configuration initializations:
#
#	ERASECHAR	Terminal ERASE character ('\010' = backspace).
#	KILLCHAR	Terminal KILL character ('\025' = CTRL/U).
#	UMASK		Default "umask" value.
#
# The ERASECHAR and KILLCHAR are used only on System V machines.
#
# UMASK is the default umask value for pam_umask and is used by
# useradd and newusers to set the mode of the new home directories.
# 022 is the "historical" value in Debian for UMASK
# 027, or even 077, could be considered better for privacy
# There is no One True Answer here : each sysadmin must make up his/her
# mind.
#
# If USERGROUPS_ENAB is set to "yes", that will modify this UMASK default value
# for private user groups, i. e. the uid is the same as gid, and username is
# the same as the primary group name: for these, the user permissions will be
# used as group permissions, e. g. 022 will become 002.
#
# Prefix these values with "0" to get octal, "0x" to get hexadecimal.
#
ERASECHAR	0177
KILLCHAR	025
UMASK		077

#
# Password aging controls:
#
#	PASS_MAX_DAYS	Maximum number of days a password may be used.
#	PASS_MIN_DAYS	Minimum number of days allowed between password changes.
#	PASS_WARN_AGE	Number of days warning given before a password expires.
#
PASS_MAX_DAYS	90
PASS_MIN_DAYS	7
PASS_WARN_AGE	7

#
# Min/max values for automatic uid selection in useradd
#
UID_MIN			 1000
UID_MAX			60000
# System accounts
#SYS_UID_MIN		  100
#SYS_UID_MAX		  999

#
# Min/max values for automatic gid selection in groupadd
#
GID_MIN			 1000
GID_MAX			60000
# System accounts
#SYS_GID_MIN		  100
#SYS_GID_MAX		  999

#
# Max number of login retries if password is bad. This will most likely be
# overriden by PAM, since the default pam_unix module has it's own built
# in of 3 retries. However, this is a safe fallback in case you are using
# an authentication module that does not enforce PAM_MAXTRIES.
#
LOGIN_RETRIES		5

#
# Max time in seconds for login
#
LOGIN_TIMEOUT		60

#
# Which fields may be changed by regular users using chfn - use
# any combination of letters "frwh" (full name, room number, work
# phone, home phone).  If not defined, no changes are allowed.
# For backward compatibility, "yes" = "rwh" and "no" = "frwh".
#
CHFN_RESTRICT		rwh

#
# Should login be allowed if we can't cd to the home directory?
# Default in no.
#
DEFAULT_HOME	yes

#
# If defined, this command is run when removing a user.
# It should remove any at/cron/print jobs etc. owned by
# the user to be removed (passed as the first argument).
#
#USERDEL_CMD	/usr/sbin/userdel_local

#
# Enable setting of the umask group bits to be the same as owner bits
# (examples: 022 -> 002, 077 -> 007) for non-root users, if the uid is
# the same as gid, and username is the same as the primary group name.
#
# If set to yes, userdel will remove the user´s group if it contains no
# more members, and useradd will create by default a group with the name
# of the user.
#
USERGROUPS_ENAB yes

#
# Instead of the real user shell, the program specified by this parameter
# will be launched, although its visible name (argv[0]) will be the shell's.
# The program may do whatever it wants (logging, additional authentification,
# banner, ...) before running the actual shell.
#
# FAKE_SHELL /bin/fakeshell

#
# If defined, either full pathname of a file containing device names or
# a ":" delimited list of device names.  Root logins will be allowed only
# upon these devices.
#
# This variable is used by login and su.
#
#CONSOLE	/etc/consoles
#CONSOLE	console:tty01:tty02:tty03:tty04

#
# List of groups to add to the user's supplementary group set
# when logging in on the console (as determined by the CONSOLE
# setting).  Default is none.
#
# Use with caution - it is possible for users to gain permanent
# access to these groups, even when not logged in on the console.
# How to do it is left as an exercise for the reader...
#
# This variable is used by login and su.
#
#CONSOLE_GROUPS		floppy:audio:cdrom

#
# If set to "yes", new passwords will be encrypted using the MD5-based
# algorithm compatible with the one used by recent releases of FreeBSD.
# It supports passwords of unlimited length and longer salt strings.
# Set to "no" if you need to copy encrypted passwords to other systems
# which don't understand the new algorithm.  Default is "no".
#
# This variable is deprecated. You should use ENCRYPT_METHOD.
#
#MD5_CRYPT_ENAB	no

#
# If set to MD5 , MD5-based algorithm will be used for encrypting password
# If set to SHA256, SHA256-based algorithm will be used for encrypting password
# If set to SHA512, SHA512-based algorithm will be used for encrypting password
# If set to DES, DES-based algorithm will be used for encrypting password (default)
# Overrides the MD5_CRYPT_ENAB option
#
# Note: It is recommended to use a value consistent with
# the PAM modules configuration.
#
ENCRYPT_METHOD SHA512

#
# Only used if ENCRYPT_METHOD is set to SHA256 or SHA512.
#
# Define the number of SHA rounds.
# With a lot of rounds, it is more difficult to brute forcing the password.
# But note also that it more CPU resources will be needed to authenticate
# users.
#
# If not specified, the libc will choose the default number of rounds (5000).
# The values must be inside the 1000-999999999 range.
# If only one of the MIN or MAX values is set, then this value will be used.
# If MIN > MAX, the highest value will be used.
#
# SHA_CRYPT_MIN_ROUNDS 5000
# SHA_CRYPT_MAX_ROUNDS 5000

################# OBSOLETED BY PAM ##############
#						#
# These options are now handled by PAM. Please	#
# edit the appropriate file in /etc/pam.d/ to	#
# enable the equivelants of them.
#
###############

#MOTD_FILE
#DIALUPS_CHECK_ENAB
#LASTLOG_ENAB
#MAIL_CHECK_ENAB
#OBSCURE_CHECKS_ENAB
#PORTTIME_CHECKS_ENAB
#SU_WHEEL_ONLY
#CRACKLIB_DICTPATH
#PASS_CHANGE_TRIES
#PASS_ALWAYS_WARN
#ENVIRON_FILE
#NOLOGINS_FILE
#ISSUE_FILE
#PASS_MIN_LEN
#PASS_MAX_LEN
#ULIMIT
#ENV_HZ
#CHFN_AUTH
#CHSH_AUTH
#FAIL_DELAY

################# OBSOLETED #######################
#						  #
# These options are no more handled by shadow.    #
#                                                 #
# Shadow utilities will display a warning if they #
# still appear.                                   #
#                                                 #
###################################################

# CLOSE_SESSIONS
# LOGIN_STRING
# NO_PASSWORD_CONSOLE
# QMAIL_DIR
EOF



## CIS ID: 9.3.1 Verify SSH dameon for SSHv2
echo '========================================================='
echo ' Checking CIS 9.3.1 Verify SSH dameon for SSHv2 '
echo '========================================================='
    if grep -q "Protocol 2" /etc/ssh/ssh_config; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i "/Protocol 1/ c\Protocol 2" /etc/ssh/ssh_config
    fi

## CIS ID: 9.3.10 Verify SSH does not allow user enviroment settings
echo '================================================================================'
echo ' Checking CIS 9.3.10 Verify SSH does not allow user enviroment settings'
echo '================================================================================'
    if grep -q "^PermitUserEnvironment no" /etc/ssh/ssh_config; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i 's/.\(PermitUserEnvironment no*.\)/\1/g' /etc/ssh/ssh_config
        sed -i "/PermitUserEnvironment yes/ c\PermitUserEnvironment no" /etc/ssh/ssh_config
    fi

## CIS ID: 9.3.11 Verify SSH approved cipher in couter mode
echo '========================================================'
echo ' Checking CIS 9.3.11 Verify SSH approved cipher for SSH '
echo '========================================================'
    if grep -q "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" /etc/ssh/ssh_config; then
        echo "Already Patched"
    else
        echo "Patching"
        echo "" >> /etc/ssh/ssh_config
        echo "#The SSH Cipher settings are defined here" >> /etc/ssh/ssh_config
        echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> /etc/ssh/ssh_config
    fi

## CIS ID: 9.3.14 Verify SSH banner is configured
echo '===================================================='
echo ' Checking CIS 9.3.14 Verify SSH banner is configured'
echo '===================================================='
    if grep -q "^Banner /etc/issue" /etc/ssh/ssh_config; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i 's/.\(Banner none*.\)/\1/g' /etc/ssh/ssh_config
        sed -i "/Banner none/ c\Banner /etc/issue" /etc/ssh/ssh_config
    fi

## CIS ID: 9.3.2 Verify SSH Log Level
echo '========================================='
echo ' Checking CIS 9.3.2 Verify SSH Log Level '
echo '========================================='
    if grep -q "^LogLevel INFO" /etc/ssh/ssh_config; then
        echo "Already Patched"
    else
        echo "Patching"
        echo "" >> /etc/ssh/ssh_config
        echo "#The SSH Log Level settings are defined here" >> /etc/ssh/ssh_config
        echo ""LogLevel INFO"" >> /etc/ssh/ssh_config
    fi

## CIS ID: 9.3.3 Verify the ssh config file owner and permissions
echo '======================================================='
echo ' 9.3.3 Verify the ssh config file owner and permissions'
echo '======================================================='
# Check ownership of ssh file
    uname="$(ls -ld /etc/ssh/ssh_config | awk '{print $3}')"
    ugroup="$(ls -ld /etc/ssh/ssh_config | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/ssh/ssh_config;
    fi
# Check permissions of ssh file
    perms="$(stat -L -c "%a" /etc/ssh/ssh_config | egrep ".44")"
    if [ "$perms" = "644" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 644 /etc/ssh/ssh_config
    fi

## CIS ID: 9.3.4 Verify SSH does not allow user enviroment settings
echo '======================================================================'
echo ' Checking CIS 9.3.4 Verify SSH does not allow user enviroment settings'
echo '======================================================================'
    if grep -q "X11Forwarding yes" /etc/ssh/ssh_config; then
        echo "Patching"
        sed -i 's/X11Forwarding yes.*/#&/g' /etc/ssh/ssh_config
    fi
    if grep -q "^X11Forwarding no" /etc/ssh/ssh_config; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i 's/.\(X11Forwarding no*.\)/\1/g' /etc/ssh/ssh_config
        sed -i "/^X11Forwarding yes/ c\X11Forwarding no" /etc/ssh/ssh_config
    fi

## CIS ID: 9.3.5 Verify SSH MaxAuthTries setting
echo '===================================================='
echo ' Checking CIS 9.3.5 Verify SSH MaxAuthTries settings'
echo '===================================================='
    if grep -q "^MaxAuthTries 4" /etc/ssh/ssh_config; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i "/MaxAuthTries/ c\MaxAuthTries 4" /etc/ssh/ssh_config
    fi

## CIS ID: 9.3.6 Verify SSH ignores rhost files
echo '=================================================='
echo ' Checking CIS 9.3.6 Verify SSH ignores rhost files'
echo '=================================================='
    if grep -q "^IgnoreRhosts yes" /etc/ssh/ssh_config; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i 's/.\(IgnoreRhosts*.\)/\1/g' /etc/ssh/ssh_config
        sed -i "/^IgnoreRhosts no/ c\IgnoreRhosts yes" /etc/ssh/ssh_config
    fi

## CIS ID: 9.3.7 Verify SSH ignores host based authentication
echo '================================================================'
echo ' Checking CIS 9.3.7 Verify SSH ignores host based authentication'
echo '================================================================'
    if grep -q "^HostbasedAuthentication no" /etc/ssh/ssh_config; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i 's/.\(HostbasedAuthentication*.\)/\1/g' /etc/ssh/ssh_config
        sed -i "/^HostbasedAuthentication yes/ c\HostbasedAuthentication no" /etc/ssh/ssh_config
    fi

## CIS ID: 9.3.8 Verify SSH does not allow root login
echo '========================================================'
echo ' Checking CIS 9.3.8 Verify SSH does not allow root login'
echo '========================================================'
    if grep -q "^PermitRootLogin no" /etc/ssh/ssh_config; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i 's/.\(PermitRootLogin*.\)/\1/g' /etc/ssh/ssh_config
        sed -i "/^PermitRootLogin yes/ c\PermitRootLogin no" /etc/ssh/ssh_config
    fi

## CIS ID: 9.3.9 Verify SSH does not allow empty passwords
echo '============================================================='
echo ' Checking CIS 9.3.9 Verify SSH does not allow empty passwords'
echo '============================================================='
    if grep -q "^PermitEmptyPasswords no" /etc/ssh/ssh_config; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i 's/.\(PermitEmptyPasswords*.\)/\1/g' /etc/ssh/ssh_config
        sed -i "/^PermitEmptyPasswords yes/ c\PermitEmptyPasswords no" /etc/ssh/ssh_config
    fi

## CIS ID: 10.50 Verify that accounts are locked after 35 days of inactivity
echo '============================================================================='
echo ' Checking CIS 10.50 Verify that accounts are locked after 35 days of inactivity'
echo '============================================================================='
    account="$(useradd -D | grep INACTIVE | awk '{print $1}')"
    if [ "$account" = "INACTIVE=35" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        useradd -D -f 35
    fi

## CIS ID: 8.1.0 & 11.20 Configuring the motd file
echo '========================================================'
echo ' Configuring CIS 8.1.0 & 11.20 Configuring the motd file'
echo '========================================================'
# Writing New Motd File
    echo "Writing new motd"
    cat <<EOF > /etc/motd
##################################################################
#                       NOTICE TO USERS                          #
#                                                                #
# This server is the property of General Service Administration. #
#                                                                #
# Unauthorized or improper use of this system may result in      #
# administrative disciplinary action and civil and criminal      #
# penalties. By continuing to use this system you indicate your  #
# awareness of and consent to these terms and conditions of use. #
# LOG OFF IMMEDIATELY if you do not agree to the conditions      #
# stated in this warning.                                        #
##################################################################
EOF

# Writing New Issue File
    echo "Writing new Issue"
    cat <<EOF > /etc/issue
##################################################################
#                       NOTICE TO USERS                          #
#                                                                #
# This server is the property of General Service Administration. #
#                                                                #
# Unauthorized or improper use of this system may result in      #
# administrative disciplinary action and civil and criminal      #
# penalties. By continuing to use this system you indicate your  #
# awareness of and consent to these terms and conditions of use. #
# LOG OFF IMMEDIATELY if you do not agree to the conditions      #
# stated in this warning.                                        #
##################################################################
EOF


# Writing New Issue.net File
    echo "Writing new Issue.net"
    cat <<EOF > /etc/issue.net
##################################################################
#                       NOTICE TO USERS                          #
#                                                                #
# This server is the property of General Service Administration. #
#                                                                #
# Unauthorized or improper use of this system may result in      #
# administrative disciplinary action and civil and criminal      #
# penalties. By continuing to use this system you indicate your  #
# awareness of and consent to these terms and conditions of use. #
# LOG OFF IMMEDIATELY if you do not agree to the conditions      #
# stated in this warning.                                        #
##################################################################
EOF

# Check ownership of etc/motd
    uname="$(ls -ld /etc/motd | awk '{print $3}')"
    ugroup="$(ls -ld /etc/motd | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/motd;
    fi
# Check permissions of etc/motd
    perms="$(stat -L -c "%a" /etc/motd | egrep ".44")"
    if [ "$perms" = "644" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 644 /etc/ssh/motd
    fi
# Check ownership of etc/issue
    uname="$(ls -ld /etc/issue | awk '{print $3}')"
    ugroup="$(ls -ld /etc/issue | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/issue;
    fi
# Check permissions of etc/motd
    perms="$(stat -L -c "%a" /etc/issue | egrep ".44")"
    if [ "$perms" = "644" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 644 /etc/issue
    fi
# Check ownership of etc/issue.net
    uname="$(ls -ld /etc/issue.net | awk '{print $3}')"
    ugroup="$(ls -ld /etc/issue.net | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/issue.net;
    fi
# Check permissions of etc/motd
    perms="$(stat -L -c "%a" /etc/issue.net | egrep ".44")"
    if [ "$perms" = "644" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 644 /etc/issue.net
    fi

## CIS ID: 12.1 The etc passwd file much have perms 644 or less permissive
echo '=========================================================================='
echo ' Checking 12.1 The etc passwd file much have perms 644 or less permissive'
echo '=========================================================================='
    perms="$(stat -L -c "%a" /etc/passwd| egrep ".44")"
        if [ "$perms" = "644" ]; then
    echo "Already Patched"
    else
    echo "Patching"
    chmod 644 /etc/passwd
    fi

## CIS ID: 12.2 The etc shadow file much have perms 760
echo '======================================================='
echo ' Checking 12.2 The etc shadow file much have perms 760'
echo '======================================================='
    perms="$(stat -L -c "%a" /etc/shadow)"
    if [ "$perms" = "67" ]; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 067 /etc/shadow
    fi
    perms="$(stat -L -c "%a" /etc/gshadow)"
    if [ "$perms" = "67" ]; then
    echo "Already Patched"
    else
    echo "Patching"
    chmod 067 /etc/gshadow
    fi

## CIS ID: 12.3 The etc group file much have perms 644 or less permissive
echo '========================================================================='
echo ' Checking 12.3 The etc group file much have perms 644 or less permissive'
echo '========================================================================='
    perms="$(stat -L -c "%a" /etc/group| egrep ".44")"
        if [ "$perms" = "644" ]; then
    echo "Already Patched"
    else
    echo "Patching"
    chmod 644 /etc/group
    fi

## CIS ID: 12.4 Verify that the passwd owner is root
echo '========================================================'
echo ' Checking CIS 12.4 Verify that the passwd owner is root'
echo '========================================================'
    uname="$(ls -ld /etc/passwd | awk '{print $3}')"
    ugroup="$(ls -ld /etc/passwd | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/passwd
    fi

## CIS ID: 12.5 Verify that the shadow owner is root
echo '========================================================'
echo ' Checking CIS 12.5 Verify that the shadow owner is root'
echo '========================================================'
    uname="$(ls -ld /etc/shadow | awk '{print $3}')"
    ugroup="$(ls -ld /etc/shadow | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/shadow
    fi

## CIS ID: 12.50 Verify that the gshadow owner is root
echo '========================================================='
echo ' Checking CIS 12.50 Verify that the gshadow owner is root'
echo '========================================================='
    uname="$(ls -ld /etc/gshadow | awk '{print $3}')"
    ugroup="$(ls -ld /etc/gshadow | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/gshadow
    fi

## CIS ID: 12.6 Verify that the etc group owner is root
echo '==========================================================='
echo ' Checking CIS 12.6 Verify that the etc group owner is root'
echo '==========================================================='
    uname="$(ls -ld /etc/group | awk '{print $3}')"
    ugroup="$(ls -ld /etc/group | awk '{print $4}')"
    if [ "$uname" = "root" ] && [ "$ugroup" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root:root /etc/group
    fi

## DISA ONLY IDS
## DISA ID: V-38466 Libary files must be owned by root
echo '===================================================='
echo ' DISA ID: V-38466 Libary files must be owned by root'
echo '===================================================='
    uname="$(ls -ld /lib | awk '{print $3}')"
    if [ "$uname" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root /lib
    fi
    uname="$(ls -ld /lib64 | awk '{print $3}')"
    if [ "$uname" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root /lib64
    fi
    uname="$(ls -ld /usr/lib | awk '{print $3}')"
    if [ "$uname" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root /usr/lib
    fi

## DISA ID: V-38469 Libary files must have 755 or less permissive permissions
echo '==========================================================================='
echo ' DISA ID: V-38469 Libary files must have 755 or less permissive permissions'
echo '==========================================================================='
    perms="$(stat -L -c "%a" /bin)"
    if [[ "$perms" < "756" ]] ; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 755 /bin
    fi
    perms="$(stat -L -c "%a" /usr/bin)"
    if [[ "$perms" < "756" ]] ; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 755 /usr/bin
    fi
    perms="$(stat -L -c "%a" /usr/local/bin)"
    if [[ "$perms" < "756" ]] ; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 755 /usr/local/bin
    fi
    perms="$(stat -L -c "%a" /sbin)"
    if [[ "$perms" < "756" ]] ; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 755 /sbin
    fi
    perms="$(stat -L -c "%a" /usr/sbin)"
    if [[ "$perms" < "756" ]] ; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 755 /usr/sbin
    fi
    perms="$(stat -L -c "%a" /usr/local/sbin)"
    if [[ "$perms" < "756" ]] ; then
        echo "Already Patched"
    else
        echo "Patching"
        chmod 755 /usr/local/sbin
    fi

## DISA ID: V-38472 System files must be owned by root
echo '===================================================='
echo ' DISA ID: V-38472 System files must be owned by root'
echo '===================================================='
    uname="$(ls -ld /bin | awk '{print $3}')"
    if [ "$uname" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root /bin
    fi
    uname="$(ls -ld /usr/bin | awk '{print $3}')"
    if [ "$uname" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root /usr/bin
    fi
    uname="$(ls -ld /sbin | awk '{print $3}')"
    if [ "$uname" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root /sbin
    fi
    uname="$(ls -ld /usr/sbin | awk '{print $3}')"
    if [ "$uname" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root /usr/sbin
    fi
    uname="$(ls -ld /usr/local/sbin | awk '{print $3}')"
    if [ "$uname" = "root" ]; then
        echo "Owner is Root. Already Patched"
    else
        echo "Patching"
        chown root /usr/local/sbin
    fi

## DISA ID: V-38492 The system must prevent the root account from logging in from virtual consoles.
echo '=========================================================================================================='
echo ' Checking DISA ID: V-38492 The system must prevent the root account from logging in from virtual consoles.'
echo '=========================================================================================================='
# Backing Up File
cp /etc/securetty /etc/securetty.$(date +"%Y%m%d")
echo "Creating new securetty file"
    cat <<EOF > /etc/securetty
console
tty1
tty2
tty3
tty4
tty5
tty6
tty7
tty8
tty9
tty10
tty11
ttyS0
EOF

## DISA ID: V-38591 Verify the rsh-server package is not installed
echo '========================================================================='
echo ' Checking DISA ID: V-38591 Verify the rsh-server package is not installed'
echo '========================================================================='
    PACKAGE=rsh-server
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Already Patched"
    else
        echo "Removing Package"
        apt-get -q -y remove $PACKAGE
    fi

## DISA ID: V-38490 Verify and Modify the modprobe CIS file
echo '================================================================'
echo ' Checking DISA ID: V-38490 Make changes to the modprobe CIS file'
echo '================================================================'
#Checking for usb-storage
    echo 'Checking for usb-storage'
    if grep -q "install usb-storage /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "It's Set"
    else
    echo "install usb-storage /bin/true" >> /etc/modprobe.d/CIS.conf
    fi


## DISA ID: V-38598 The rexecd service must not be running
echo '========================================================'
echo ' DISA ID: V-38598 The rexecd service must not be running'
echo '========================================================'

    if grep -q "rexec" /etc/init.d/*; then
            echo "Already Patched"
    else
            echo "Patching"
# chkconfig rexec off
#service rexec stop
    fi

## DISA ID: V-38602 The rlogin service must not be running
echo '========================================================'
echo ' DISA ID: V-38602 The rlogin service must not be running'
echo '========================================================'

    if grep -q "rlogin" /etc/init.d/*; then
            echo "Already Patched"
    else
            echo "Patching"
#chkconfig rlogin off
#service rlogin stop
    fi

## DISA ID: V-38603 Verify the ypserv package is not installed
echo '=============================================================================='
echo ' Checking DISA ID: V-38603: Checking to see if the vpserv package is installed'
echo '=============================================================================='
    PACKAGE=ypserv
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Already Patched"
    else
        echo "Removing Package"
        apt-get -q -y remove $PACKAGE
    fi



## DISA ID: V-38627 Verify the Open-Ldap package is not installed
echo '================================================================================='
echo ' Checking DISA ID: V-38627: Checking to see if the Open-Ldap package is installed'
echo '================================================================================='
    PACKAGE=open-ldap
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Already Patched"
    else
        echo "Removing Package"
        apt-get -q -y remove $PACKAGE
    fi

## DISA ID: V-38640 Verify the abrtd service is running
echo '=============================================================='
echo ' Checking DISA ID: V-38640 Verify the abrtd service is running'
echo '=============================================================='
    SERVICE=abrtd;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

## DISA ID: V-38641 Verify the atd service is not running
echo '============================================================'
echo ' Checking DISA ID: V-38641 Verify the atd service is running'
echo '============================================================'
    SERVICE=atd;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running, stopping"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is already stopped"
    fi

## DISA ID: V-38646 Verify the oddjobd service is not running
echo '============================================================================='
echo ' Checking DISA ID: V-38646: Checking to see if the oddjbob service is running'
echo '============================================================================='
    SERVICE=oddjobd;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

## DISA ID: V-38648 Verify the service is not running
echo '==========================================================================='
echo ' Checking DISA ID: V-38648: Checking to see if the qpidd service is running'
echo '==========================================================================='
    SERVICE=qpidd;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

## DISA ID: V-38650 Verify the rdisc service is not running
echo '==========================================================================='
echo ' Checking DISA ID: V-38650: Checking to see if the rdisc service is running'
echo '==========================================================================='
    SERVICE=rdisc;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

## DISA ID: V-38671 Verify that the sendmail package is not installed
echo '============================================================================='
echo ' Checking DISA ID: V-38671: Verify that the sendmail package is not insatlled'
echo '============================================================================='
    PACKAGE=sendmail
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Already Patched"
    else
        echo "Removing Package"
        apt-get -q -y remove $PACKAGE
    fi

## DISA ID: V-38622 Mail relaying must be restricted
echo '==========================================================='
echo ' Checking DISA ID: V-38622 Mail relaying must be restricted'
echo '==========================================================='
    if grep -q "inet_interfaces = localhost" /etc/postfix/master.cf; then
        echo "Already Patched"
    else
        echo "Patching"
        echo "" >> /etc/postfix/master.cf
        echo "#The mail relaying are defined here" >> /etc/postfix/master.cf
        echo "inet_interfaces = localhost" >> /etc/postfix/master.cf
    fi

## DISA ID: V-38672 Verify the netconsole service is not running
echo '================================================================================'
echo ' Checking DISA ID: V-38650: Checking to see if the netconsole service is running'
echo '================================================================================'
    SERVICE=netconsole;
    if ps ax | grep -v grep | grep $SERVICE > /dev/null
    then
        echo "$SERVICE service running"
        service $SERVICE stop
        update-rc.d $SERVICE disable
    else
        echo "$SERVICE is not running"
    fi

## DISA ID: V-38687 Verify that the openswan package is installed
echo '========================================================================='
echo ' Checking DISA ID: V-38687: Verify that the openswan package is insatlled'
echo '========================================================================='
    PACKAGE=openswan
    if ! dpkg -s $PACKAGE > /dev/null; then
        echo "Patching"
        apt-get -q --assume-yes install $PACKAGE
    else
        echo "Already Patched"
    fi

## DISA ID: V-38649 The system default umask for the csh shell must be 077
echo '================================================================================='
echo ' Checking DISA ID: V-38649 The system default umask for the csh shell must be 077'
echo '================================================================================='
    if grep -q "umask 077" /etc/csh.cshrc; then
        echo "Already Patched"
    else
        echo "Patching"
        echo "" >> /etc/csh.cshrc
        echo "#The UMASK Settings are defined here" >> /etc/csh.cshrc
        echo "umask 077" >> /etc/csh.cshrc
    fi

## DISA ID: V-38684 The system must limte users to 10 simultaneous system logins
echo '======================================================================================='
echo ' Checking DISA ID: V-38684 The system must limte users to 10 simultaneous system logins'
echo '======================================================================================='
    if grep -q "* hard maxlogins 10" /etc/security/limits.conf; then
        echo "Already Patched"
    else
        echo "Patching"
        echo "* hard maxlogins 10" >> /etc/security/limits.conf
    fi

## DISA ID: V-51875 Verify that required lastlog is configured
echo '====================================================================='
echo ' Checking DISA ID: V-51875 Verify that required lastlog is configured'
echo '====================================================================='
    if grep -q "pam_lastlog" /etc/pam.d/login; then
        echo "Already Patched"
    else
        echo "Patching"
        sed -i '/session    optional     pam_console.so/a session    required     pam_lastlog.so showfailed' /etc/pam.d/login
    fi
fi