#!/bin/bash
# Run script with root privileges to harden system according to the CIS Level 1 Benchmark for RHEL7 (v2.1.0). Provided by Thomas Heffron on 2/8/17.

echo "Welcome to the Red Hat Enterprise Linux 7 hardening script."
echo "Please note this will harden your system aggressively according to CIS guidelines."
echo "This script requires root privileges to run and will reboot your system when complete."
sleep 10

_DEBUG="off"

function DEBUG()
{
 [ "$_DEBUG" == "on" ] &&  $@
}

####### Checks #######

# Make sure we are on RHEL7
echo "Checking for RHEL version"
if grep -q "release 7" /etc/redhat-release; then
  echo "System is running RHEL 7"
else
  echo "!!This script must be run on RHEL 7!!" 1>&2
  exit 1
fi

# Make sure user is root
echo "Checking if you are root"
if [ $EUID -ne 0 ]; then
  echo "!!This script must be run as root!!" 1>&2
  exit 1
else
  ####### Operating System Update #######
  echo "Performing a full Operating System patch update"
  yum -y update

  ####### System Hardening #######

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1 Filesystem Configuration"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.1 Disable Unused filesystems"
  DEBUG echo "===================================================================="

  DEBUG echo "Managing unused filesystems"
  DEBUG echo "Checking for conf file at /etc/modprobe.d/CIS.conf"

  if [ ! -f /etc/modprobe.d/CIS.conf ]; then
    echo "/etc/modprobe.d/CIS.conf file does not exist. Creating it..."
    echo "# CIS.conf file created by Ubuntu Hardening Script on $(date)" >> /etc/modprobe.d/CIS.conf
  else
    echo "/etc/modprobe.d/CIS.conf file exists"
  fi

  # CIS Section 1.1.1.1 - Ensure mounting of cramfs filesystems is disabled
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.1.1 Ensure mounting of cramfs filesystem is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install cramfs /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "cramfs is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "cramfs is not currently disabled. Disabling..."
    echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  # CIS Section 1.1.1.2 - Ensure mounting of freevxfs filesystems is disabled
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.1.2 Ensure mounting of freevxfs filesystem is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install freevxfs /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "freevxfs is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "freevxfs is not currently disabled. Disabling..."
    echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  # CIS Section 1.1.1.3 - Ensure mounting of jffs2 filesystems is disabled
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.1.3 Ensure mounting of jffs2 filesystem is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install jffs2 /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "jffs2 is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "jffs2 is not currently disabled. Disabling..."
    echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  # CIS Section 1.1.1.4 - Ensure mounting of hfs filesystems is disabled
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.1.4 Ensure mounting of hfs filesystem is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install hfs /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "hfs is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "hfs is not currently disabled. Disabling..."
    echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  # CIS Section 1.1.1.5 - Ensure mounting of hfsplus filesystems is disabled
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.1.5 Ensure mounting of hfsplus filesystem is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install hfsplus /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "hfsplus is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "hfsplus is not currently disabled. Disabling..."
    echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  # CIS Section 1.1.1.6 - Ensure mounting of squashfs filesystems is disabled
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.1.6 Ensure mounting of squashfs filesystem is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install squashfs /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "squashfs is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "squashfs is not currently disabled. Disabling..."
    echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  # CIS Section 1.1.1.7 - Ensure mounting of udf filesystems is disabled
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.1.7 Ensure mounting of udf filesystem is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install udf /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "udf is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "udf is not currently disabled. Disabling..."
    echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  # CIS Section 1.1.1.8 - Ensure mounting of vfat filesystems is disabled
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.1.8 Ensure mounting of vfat filesystem is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install vfat /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "vfat is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "vfat is not currently disabled. Disabling..."
    echo "install vfat /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  # CIS Section 1.1.2 Ensure separate partition exist for /tmp
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.2 Ensure separate partition exist for /tmp"
  DEBUG echo "===================================================================="
  _CHECK_TMP_OPTIONS = "false"

  DEBUG echo "Checking for separate /tmp partition using 'mount' command"
  if [ $(mount | grep /tmp | wc -l) == 1 ]; then
    echo "According to the 'mount' command, /tmp directory is mounted to a separate partition"
    _CHECK_TMP_OPTIONS = "true"
  else
    echo "According to the 'mount' command, /tmp directory is not a separate partition"
  fi

  DEBUG echo "Checking for separate /tmp partition using 'df' command"
  if [ $(df -k /tmp | awk {'if (NR!=1) print $6'}) == "/tmp" ]; then
    echo "According to the 'df' command, /tmp directory is mounted to a separate partition"
    _CHECK_TMP_OPTIONS = "true"
  else
    echo "According to the 'df' command, /tmp directory is part of the root partition"
  fi

  DEBUG echo "Checking for separate /tmp partition in systemd"
  if [ -e /etc/systemd/system/local-fs.target.wants/tmp.mount -a $(grep "^Where=/tmp$" /etc/systemd/system/local-fs.target.wants/tmp.mount | wc -l) -eq 1 ]; then
    echo "According to 'systemd', /tmp directory is mounted to a separate partition"
    _CHECK_TMP_OPTIONS = "true"
  else
    echo "According to 'systemd', /tmp directory is not managed through this service"
  fi

  if [ $_CHECK_TMP_OPTIONS == "true" ]; then
    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.1.3 Ensure nodev option set on /tmp"
    DEBUG echo "===================================================================="
    if [ $(mount | grep /tmp | grep nodev | wc -l) -eq 1 ]; then
      echo "According to the 'mount' command, /tmp directory is mounted with nodev option"
    else
      echo "According to the 'mount' command, /tmp directory is not mounted with the nodev option"
    fi

    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.1.4 Ensure nosuid option set on /tmp"
    DEBUG echo "===================================================================="
    if [ $(mount | grep /tmp | grep nosuid | wc -l) -eq 1 ]; then
      echo "According to the 'mount' command, /tmp directory is mounted with nosuid option"
    else
      echo "According to the 'mount' command, /tmp directory is not mounted with the nosuid option"
    fi

    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.1.5 Ensure noexec option set on /tmp"
    DEBUG echo "===================================================================="
    if [ $(mount | grep /tmp | grep noexec | wc -l) -eq 1 ]; then
      echo "According to the 'mount' command, /tmp directory is mounted with noexec option"
    else
      echo "According to the 'mount' command, /tmp directory is not mounted with the noexec option"
    fi
  else
    echo "/tmp is not a separate partition. Skipping the following checks:"
    echo "-- 1.1.3 - Ensure nodev option set on /tmp"
    echo "-- 1.1.4 - Ensure nosuid option set on /tmp"
    echo "-- 1.1.5 - Ensure noexec option set on /tmp"
  fi

  # CIS Section 1.1.6 Ensure separate partition exist for /var
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.6 Ensure separate partition exist for /var"
  DEBUG echo "===================================================================="
  _CHECK_VAR_OPTIONS = "false"

  DEBUG echo "Checking for separate /var partition using 'mount' command"
  if [ $(mount | grep /var | wc -l) == 1 ]; then
    echo "According to the 'mount' command, /var directory is mounted to a separate partition"
    _CHECK_VAR_OPTIONS = "true"
  else
    echo "According to the 'mount' command, /var directory is not a separate partition"
  fi

  DEBUG echo "Checking for separate /var partition using 'df' command"
  if [ $(df -k /var | awk {'if (NR!=1) print $6'}) == "/var" ]; then
    echo "According to the 'df' command, /var directory is mounted to a separate partition"
    _CHECK_VAR_OPTIONS = "true"
  else
    echo "According to the 'df' command, /var directory is part of the root partition"
  fi

  DEBUG echo "Checking for separate /var partition in systemd"
  if [ -e /etc/systemd/system/local-fs.target.wants/var.mount -a $(grep "^Where=/var$" /etc/systemd/system/local-fs.target.wants/var.mount | wc -l) -eq 1 ]; then
    echo "According to 'systemd', /var directory is mounted to a separate partition"
    _CHECK_VAR_OPTIONS = "true"
  else
    echo "According to 'systemd', /var directory is not managed through this service"
  fi

  # CIS Section 1.1.7 Ensure separate partition exist for /var/tmp
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.7 Ensure separate partition exist for /var/tmp"
  DEBUG echo "===================================================================="
  _CHECK_VARTMP_OPTIONS = "false"

  DEBUG echo "Checking for separate /var/tmp partition using 'mount' command"
  if [ $(mount | grep /var/tmp | wc -l) == 1 ]; then
    echo "According to the 'mount' command, /var/tmp directory is mounted to a separate partition"
    _CHECK_VARTMP_OPTIONS = "true"
  else
    echo "According to the 'mount' command, /var/tmp directory is not a separate partition"
  fi

  DEBUG echo "Checking for separate /var/tmp partition using 'df' command"
  if [ $(df -k /var/tmp | awk {'if (NR!=1) print $6'}) == "/var/tmp" ]; then
    echo "According to the 'df' command, /var/tmp directory is mounted to a separate partition"
    _CHECK_VARTMP_OPTIONS = "true"
  else
    echo "According to the 'df' command, /var/tmp directory is part of the root partition"
  fi

  DEBUG echo "Checking for separate /var/tmp partition in systemd"
  if [ -e /etc/systemd/system/local-fs.target.wants/var-tmp.mount -a $(grep "^Where=/var/tmp$" /etc/systemd/system/local-fs.target.wants/var-tmp.mount | wc -l) -eq 1 ]; then
    echo "According to 'systemd', /var/tmp directory is mounted to a separate partition"
    _CHECK_VARTMP_OPTIONS = "true"
  else
    echo "According to 'systemd', /var/tmp directory is not managed through this service"
  fi

  if [ $_CHECK_VARTMP_OPTIONS == "true" ]; then
    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.1.8 Ensure nodev option set on /var/tmp"
    DEBUG echo "===================================================================="
    if [ $(mount | grep /var/tmp | grep nodev | wc -l) -eq 1 ]; then
      echo "According to the 'mount' command, /var/tmp directory is mounted with nodev option"
    else
      echo "According to the 'mount' command, /var/tmp directory is not mounted with the nodev option"
    fi

    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.1.9 Ensure nosuid option set on /var/tmp"
    DEBUG echo "===================================================================="
    if [ $(mount | grep /var/tmp | grep nosuid | wc -l) -eq 1 ]; then
      echo "According to the 'mount' command, /var/tmp directory is mounted with nosuid option"
    else
      echo "According to the 'mount' command, /var/tmp directory is not mounted with the nosuid option"
    fi

    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.1.10 Ensure noexec option set on /var/tmp"
    DEBUG echo "===================================================================="
    if [ $(mount | grep /var/tmp | grep noexec | wc -l) -eq 1 ]; then
      echo "According to the 'mount' command, /var/tmp directory is mounted with noexec option"
    else
      echo "According to the 'mount' command, /var/tmp directory is not mounted with the noexec option"
    fi
  else
    echo "/var/tmp is not a separate partition. Skipping the following checks:"
    echo "-- 1.1.8 - Ensure nodev option set on /var/tmp"
    echo "-- 1.1.9 - Ensure nosuid option set on /var/tmp"
    echo "-- 1.1.10 - Ensure noexec option set on /var/tmp"
  fi

  # CIS Section 1.1.11 Ensure separate partition exist for /var/log
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.11 Ensure separate partition exist for /var/log"
  DEBUG echo "===================================================================="
  _CHECK_VARLOG_OPTIONS = "false"

  DEBUG echo "Checking for separate /var/log partition using 'mount' command"
  if [ $(mount | grep /var/log | wc -l) == 1 ]; then
    echo "According to the 'mount' command, /var/log directory is mounted to a separate partition"
    _CHECK_VARLOG_OPTIONS = "true"
  else
    echo "According to the 'mount' command, /var/log directory is not a separate partition"
  fi

  DEBUG echo "Checking for separate /var/log partition using 'df' command"
  if [ $(df -k /var/log | awk {'if (NR!=1) print $6'}) == "/var/log" ]; then
    echo "According to the 'df' command, /var/log directory is mounted to a separate partition"
    _CHECK_VARLOG_OPTIONS = "true"
  else
    echo "According to the 'df' command, /var/log directory is part of the root partition"
  fi

  DEBUG echo "Checking for separate /var/log partition in systemd"
  if [ -e /etc/systemd/system/local-fs.target.wants/var-log.mount -a $(grep "^Where=/var/log$" /etc/systemd/system/local-fs.target.wants/var-log.mount | wc -l) -eq 1 ]; then
    echo "According to 'systemd', /var/log directory is mounted to a separate partition"
    _CHECK_VARLOG_OPTIONS = "true"
  else
    echo "According to 'systemd', /var/log directory is not managed through this service"
  fi

  # CIS Section 1.1.12 Ensure separate partition exist for /var/log/audit
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.12 Ensure separate partition exist for /var/log/audit"
  DEBUG echo "===================================================================="
  _CHECK_VARLOGAUDIT_OPTIONS = "false"

  DEBUG echo "Checking for separate /var/log/audit partition using 'mount' command"
  if [ $(mount | grep /var/log/audit | wc -l) == 1 ]; then
    echo "According to the 'mount' command, /var/log/audit directory is mounted to a separate partition"
    _CHECK_VARLOGAUDIT_OPTIONS = "true"
  else
    echo "According to the 'mount' command, /var/log/audit directory is not a separate partition"
  fi

  DEBUG echo "Checking for separate /var/log/audit partition using 'df' command"
  if [ $(df -k /var/log/audit | awk {'if (NR!=1) print $6'}) == "/var/log/audit" ]; then
    echo "According to the 'df' command, /var/log/audit directory is mounted to a separate partition"
    _CHECK_VARLOGAUDIT_OPTIONS = "true"
  else
    echo "According to the 'df' command, /var/log/audit directory is part of the root partition"
  fi

  DEBUG echo "Checking for separate /var/log/audit partition in systemd"
  if [ -e /etc/systemd/system/local-fs.target.wants/var-log-audit.mount -a $(grep "^Where=/var/log/audit$" /etc/systemd/system/local-fs.target.wants/var-log-audit.mount | wc -l) -eq 1 ]; then
    echo "According to 'systemd', /var/log/audit directory is mounted to a separate partition"
    _CHECK_VARLOGAUDIT_OPTIONS = "true"
  else
    echo "According to 'systemd', /var/log/audit directory is not managed through this service"
  fi

  # CIS Section 1.1.13 Ensure separate partition exist for /home
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.13 Ensure separate partition exist for /home"
  DEBUG echo "===================================================================="
  _CHECK_HOME_OPTIONS = "false"

  DEBUG echo "Checking for separate /home partition using 'mount' command"
  if [ $(mount | grep /home | wc -l) == 1 ]; then
    echo "According to the 'mount' command, /home directory is mounted to a separate partition"
    _CHECK_HOME_OPTIONS = "true"
  else
    echo "According to the 'mount' command, /home directory is not a separate partition"
  fi

  DEBUG echo "Checking for separate /home partition using 'df' command"
  if [ $(df -k /home | awk {'if (NR!=1) print $6'}) == "/home" ]; then
    echo "According to the 'df' command, /home directory is mounted to a separate partition"
    _CHECK_HOME_OPTIONS = "true"
  else
    echo "According to the 'df' command, /home directory is part of the root partition"
  fi

  DEBUG echo "Checking for separate /home partition in systemd"
  if [ -e /etc/systemd/system/local-fs.target.wants/var-log-audit.mount -a $(grep "^Where=/home$" /etc/systemd/system/local-fs.target.wants/var-log-audit.mount | wc -l) -eq 1 ]; then
    echo "According to 'systemd', /home directory is mounted to a separate partition"
    _CHECK_HOME_OPTIONS = "true"
  else
    echo "According to 'systemd', /home directory is not managed through this service"
  fi

  if [ $_CHECK_HOME_OPTIONS == "true" ]; then
    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.1.14 Ensure nodev option set on /home"
    DEBUG echo "===================================================================="
    if [ $(mount | grep /home | grep nodev | wc -l) -eq 1 ]; then
      echo "According to the 'mount' command, /home directory is mounted with nodev option"
    else
      echo "According to the 'mount' command, /home directory is not mounted with the nodev option"
    fi
  else
    echo "/home is not a separate partition. Skipping the following checks:"
    echo "-- 1.1.14 - Ensure nodev option set on /home"
  fi

v  # CIS Section 1.1.15 Ensure separate partition exist for /dev/shm
  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.15 Ensure separate partition exist for /dev/shm"
  DEBUG echo "===================================================================="
  _CHECK_RUNSHM_OPTIONS = "false"

  DEBUG echo "Checking for separate /dev/shm partition using 'mount' command"
  if [ $(mount | grep /dev/shm | wc -l) == 1 ]; then
    echo "According to the 'mount' command, /dev/shm directory is mounted to a separate partition"
    _CHECK_RUNSHM_OPTIONS = "true"
  else
    echo "According to the 'mount' command, /dev/shm directory is not a separate partition"
  fi

  DEBUG echo "Checking for separate /dev/shm partition using 'df' command"
  if [ $(df -k /dev/shm | awk {'if (NR!=1) print $6'}) == "/dev/shm" ]; then
    echo "According to the 'df' command, /dev/shm directory is mounted to a separate partition"
    _CHECK_RUNSHM_OPTIONS = "true"
  else
    echo "According to the 'df' command, /dev/shm directory is part of the root partition"
  fi

  DEBUG echo "Checking for separate /dev/shm partition in systemd"
  if [ -e /etc/systemd/system/local-fs.target.wants/dev-shm.mount -a $(grep "^Where=/dev/shm$" /etc/systemd/system/local-fs.target.wants/dev-shm.mount | wc -l) -eq 1 ]; then
    echo "According to 'systemd', /dev/shm directory is mounted to a separate partition"
    _CHECK_RUNSHM_OPTIONS = "true"
  else
    echo "According to 'systemd', /dev/shm directory is not managed through this service"
  fi

  if [ $_CHECK_RUNSHM_OPTIONS == "true" ]; then
    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.1.16 Ensure nosuid option set on /dev/shm"
    DEBUG echo "===================================================================="
    if [ $(mount | grep /dev/shm | grep nosuid | wc -l) -eq 1 ]; then
      echo "According to the 'mount' command, /dev/shm directory is mounted with nosuid option"
    else
      echo "According to the 'mount' command, /dev/shm directory is not mounted with the nosuid option"
    fi

    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.1.17 Ensure noexec option set on /dev/shm"
    DEBUG echo "===================================================================="
    if [ $(mount | grep /dev/shm | grep noexec | wc -l) -eq 1 ]; then
      echo "According to the 'mount' command, /dev/shm directory is mounted with noexec option"
    else
      echo "According to the 'mount' command, /dev/shm directory is not mounted with the noexec option"
    fi
  else
    echo "/dev/shm is not a separate partition. Skipping the following checks:"
    echo "-- 1.1.16 - Ensure nosuid option set on /dev/shm"
    echo "-- 1.1.17 - Ensure noexec option set on /dev/shm"
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.18 Ensure nodev option set on removable media partitions"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure nodev option set on removable media partitions"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.19 Ensure nosuid option set on removable media partitions"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure nosuid option set on removable media partitions"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.20 Ensure noexec option set on removable media partitions"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure noexec option set on removable media partitions"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.21 Ensure sticky bit is set on all world-writable directories"
  DEBUG echo "===================================================================="
  echo "World writable directories that do not have sticky bit set:"
  df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \)
  echo ""
  echo "Setting sticky bit on world writable files..."
  df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.1.22 Disable Automounting"
  DEBUG echo "===================================================================="
  PACKAGE=autofs
  if ( ! rpm -q $PACKAGE > /dev/null) && ( ! service $PACKAGE status &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' installed and configuration file found. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.2.1 Ensure package manager repositories are configured"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure package manager repositories are configured"
  echo "This can be performed using 'yum repolist' and reviewing /etc/yum.repos.d/*"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.2.2 Ensure gpgcheck is globally activated"
  DEBUG echo "===================================================================="
  if [ $(grep -R ^gpgcheck /etc/yum.* | sed -e 's/ //g' | cut -d: -f2 | grep -v ^gpgcheck=1 | wc -l) -ne 0 ]; then
    echo "All yum repositories are configured to use GPG keys"
  fi
  echo "Not all yum repositories are configured to use GPG keys"
  echo "MANUAL ACTION: Check all repositories in /etc/yum.conf and /etc/yum.repos.d/*"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.2.3 Ensure GPG keys are configured"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure GPG keys are configured"
  echo "The following GPG keys are valid for installing O/S packages"
  rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.2.4 Ensure Red Hat Network or Subscription Manager connection is configured"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure Red Hat Network or Subscription Manager connection is configured"
  echo "Verify your subscription using 'subscription-manager identity'"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.2.5 Disable the rhnsd Daemon"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Disable the rhnsd Daemon"
  echo "Use the command 'chkconfig rhnsd off' to turn off automatic updates"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.3.1 Ensure AIDE is installed"
  DEBUG echo "===================================================================="
  PACKAGE=aide
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed. Installing..."
    yum -y -q install $PACKAGE
    aide --init
    mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
  else
    echo "Package '$PACKAGE' already installed."
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.3.2 Ensure filesystem integrity is regularly checked"
  DEBUG echo "===================================================================="
  if grep -r aide /etc/cron.* /etc/crontab; then
    echo "Integrity check found in cron structure"
    echo "MANUAL CHECK: Ensure cron entry is configured according to organization policy"
  else
    echo "Integrity check not found in cron structure"
    echo "MANUAL CHECK: Ensure cron entry is configured according to organization policy"
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.4.1 Ensure permissions on bootloader config are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /boot/grub/grub.cfg) == "0" ]; then
    echo "Bootloader config file /boot/grub/grub.cfg has correct owner (uid = 0)"
  else
    echo "Bootloader config file /boot/grub/grub.cfg does not have correct owner. Setting..."
    chown root /boot/grub/grub.cfg
  fi
  if [ $(stat --format=%g /boot/grub/grub.cfg) == "0" ]; then
    echo "Bootloader config file /boot/grub/grub.cfg has correct group (gid = 0)"
  else
    echo "Bootloader config file /boot/grub/grub.cfg does not have correct group. Setting..."
    chgrp root /boot/grub/grub.cfg
  fi
  if [ $(stat --format=%a /boot/grub/grub.cfg) == "400" ] -o [ $(stat --format=%a /boot/grub/grub.cfg) == "600" ]; then
    echo "Bootloader config file /boot/grub/grub.cfg has correct permissions (400 or 600)"
  else
    echo "Bootloader config file /boot/grub/grub.cfg does not have correct permissions. Setting..."
    chmod 600 /boot/grub/grub.cfg
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.4.2 Ensure bootloader password is set"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Configure bootloader password in accordance with your systems policies"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.4.3 Ensure authentication required for single user mode"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure authentication required for single user mode";

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.5.1 Ensure core dumps are restricted"
  DEBUG echo "===================================================================="
  if grep -q "* hard core 0" /etc/security/limits.conf; then
    echo "Core dump limits are set correctly in limits.conf file"
  else
      echo "Core dump limits are not set in limits.conf file"
      echo "* hard core 0" >> /etc/security/limits.conf
  fi
  if [ "$(grep "fs.suid_dumpable" /etc/sysctl.conf)" == "fs.suid_dumpable = 0" ]; then
    echo "/etc/sysctl.conf is configured to limit core dumps from SUID programs on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for core dumps from SUID programs. Resolving..."
    sed -i 's/^fs.suid_dumpable.*//g' /etc/sysctl.conf
    echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.5.2 Ensure XD/NX support is enabled"
  DEBUG echo "===================================================================="
  if [ $(dmesg | grep ' NX ' | grep "protection: active" | awk '{print $NF}') == "active" ]; then
    echo "According to the 'dmesg' command, NX support is acive in the kernel"
  else
    echo "According to the 'dmesg' command, NX support is not active"
    echo "MANUAL ACTION: upgrade kernel to nx|pae enabled protection"
  fi
  if [ "$(uname -m)" == "x86_64" ]; then
    echo "Kernel is reporting as 64-bit enabled"
  else
    echo "Kernel is reporting as 32-bit only"
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.5.3 Ensure address space layout randomization (ASLR) is enabled"
  DEBUG echo "===================================================================="
  if [ "$(grep "kernel.randomize_va_space" /etc/sysctl.conf)" == "kernel.randomize_va_space = 2" ]; then
    echo "/etc/sysctl.conf is correctly configured to randomize va space"
  else
    echo "/etc/sysctl.conf is correctly configured to randomize va space. Resolving..."
    echo "" >> /etc/sysctl.conf
    echo "#Kernel Randomize VA setting per CIS paragraph 1.5.3" >> /etc/sysctl.conf
    echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.5.4 Ensure prelink is disabled"
  DEBUG echo "===================================================================="
  PACKAGE=prelink
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    prelink -ua
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.6.1 Configure SELinux"
  DEBUG echo "===================================================================="
  PACKAGE=selinux
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed. Skipping the following checks:"
    echo "-- 1.6.1.1 - Ensure SELinux is not disabled in bootloader configuration"
    echo "-- 1.6.1.2 - Ensure the SELinux state is enforcing"
    echo "-- 1.6.1.3 - Ensure SELinux policy is configured"
    echo "-- 1.6.1.4 - Ensure SETroubleshoot is not installed"
    echo "-- 1.6.1.5 - Ensure the MCS Translation Service (mcstrans) is not installed"
    echo "-- 1.6.1.6 - Ensure no unconfined daemons exist"
  else
    echo "Package '$PACKAGE' is installed. Checking configuration..."

    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.6.1.1 Ensure SELinux is not disabled in bootloader configuration"
    DEBUG echo "===================================================================="
    if [ $(grep "^\s*linux" /boot/grub/grub.cfg | grep "selinux=0" | wc -l) -ge 1 ] || [ $(grep "^\s*linux" /boot/grub/grub.cfg | grep "enforcing=0" | wc -l) -ge 1 ]; then
      echo "SELinux found disabled or non-enforcing in /boot/grub/grub.cfg. You must resolve this"
      echo "MANUAL ACTION: Fix linux kernel line with lowered SELinux configuration"
    fi

    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.6.1.2 Ensure the SELinux state is enforcing"
    DEBUG echo "===================================================================="
    if [ $(grep SELINUX=enforcing /etc/selinux/config) == "SELINUX=enforcing"]; then
      echo "SELinux found in enforcing mode according /etc/selinux/config"
    else
      echo "SELinux is not in enforcing mode according to /etc/selinux/config"
      echo "MANUAL ACTION: Adjust /etc/selinux/config to add a line 'SELINUX=enforcing'"
    fi

    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.6.1.3 Ensure SELinux policy is configured"
    DEBUG echo "===================================================================="
    if [ $(grep SELINUXTYPE= /etc/selinux/config) == "SELINUXTYPE=ubuntu"]; then
      echo "SELinux found the 'ubuntu' policy set in /etc/selinux/config"
    else
      echo "SELinux does not have the 'ubuntu' policy set in /etc/selinux/config"
      echo "MANUAL ACTION: Adjust /etc/selinux/config to add a line 'SELINUXTYPE=ubuntu'"
    fi

    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.6.1.4 Ensure setroubleshoot is disabled"
    DEBUG echo "===================================================================="
    PACKAGE=setroubleshoot
    if ( ! rpm -q $PACKAGE &> /dev/null ); then
      echo "Package '$PACKAGE' is not installed - according to policy"
    else
      echo "Package '$PACKAGE' is installed. Removing..."
      yum -y remove $PACKAGE
    fi

    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.6.1.5 Ensure mcstrans is disabled"
    DEBUG echo "===================================================================="
    PACKAGE=mcstrans
    if ( ! rpm -q $PACKAGE &> /dev/null ); then
      echo "Package '$PACKAGE' is not installed - according to policy"
    else
      echo "Package '$PACKAGE' is installed. Removing..."
      yum -y remove $PACKAGE
    fi

    DEBUG echo "===================================================================="
    DEBUG echo "Checking: 1.6.1.6 Ensure no unconfined daemons exist"
    DEBUG echo "===================================================================="
    echo "MANUAL CHECK: Investigate the following processes that are unconfined by SELinux:"
    ps -eZ | egrep "initrc" | egrep -vw "tr|ps|egrep|bash|awk" | tr ':' ' ' | awk '{ print $NF }'
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.6.2 Ensure SELinux is installed"
  DEBUG echo "===================================================================="
  PACKAGE=libselinux
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed. Installing..."
    yum -y install $PACKAGE
  else
    echo "Package '$PACKAGE' is installed - according to policy"
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.7.1 Command Line Warning Banners"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.7.1.1 Ensure message of the day is configured properly"
  DEBUG echo "===================================================================="
  echo "Setting /etc/motd according to Organization Policy"
  cat <<EOF > /etc/motd
##################################################################
#                       NOTICE TO USERS                          #
#                                                                #
# This server is the property of General Services Administration #
#                                                                #
# Unauthorized or improper use of this system may result in      #
# administrative disciplinary action and civil and criminal      #
# penalties. By continuing to use this system you indicate your  #
# awareness of and consent to these terms and conditions of use. #
# LOG OFF IMMEDIATELY if you do not agree to the conditions      #
# stated in this warning.                                        #
##################################################################
EOF

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.7.1.2 Ensure local login warning banner is configured properly"
  DEBUG echo "===================================================================="
  echo "Setting /etc/issue according to Organization Policy"
  cat <<EOF > /etc/issue
##################################################################
#                       NOTICE TO USERS                          #
#                                                                #
# This server is the property of General Services Administration #
#                                                                #
# Unauthorized or improper use of this system may result in      #
# administrative disciplinary action and civil and criminal      #
# penalties. By continuing to use this system you indicate your  #
# awareness of and consent to these terms and conditions of use. #
# LOG OFF IMMEDIATELY if you do not agree to the conditions      #
# stated in this warning.                                        #
##################################################################
EOF

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.7.1.3 Ensure remote login warning banner is configured properly"
  DEBUG echo "===================================================================="
  echo "Setting /etc/issue.net according to Organization Policy"
  cat <<EOF > /etc/issue.net
##################################################################
#                       NOTICE TO USERS                          #
#                                                                #
# This server is the property of General Services Administration #
#                                                                #
# Unauthorized or improper use of this system may result in      #
# administrative disciplinary action and civil and criminal      #
# penalties. By continuing to use this system you indicate your  #
# awareness of and consent to these terms and conditions of use. #
# LOG OFF IMMEDIATELY if you do not agree to the conditions      #
# stated in this warning.                                        #
##################################################################
EOF

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.7.1.4 Ensure permissions on /etc/motd are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/motd) == "0" ]; then
    echo "Message file /etc/motd has correct owner (uid = 0)"
  else
    echo "Message file /etc/motd does not have correct owner. Setting..."
    chown root /etc/motd
  fi
  if [ $(stat --format=%g /etc/motd) == "0" ]; then
    echo "Message file /etc/motd has correct group (gid = 0)"
  else
    echo "Message file /etc/motd does not have correct group. Setting..."
    chgrp root /etc/motd
  fi
  if [ $(stat --format=%a /etc/motd) == "644" ]; then
    echo "Message file /etc/motd has correct permissions (644)"
  else
    echo "Message file /etc/motd does not have correct permissions. Setting..."
    chmod 644 /etc/motd
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.7.1.5 Ensure permissions on /etc/issue are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/issue) == "0" ]; then
    echo "Login banner file /etc/issue has correct owner (uid = 0)"
  else
    echo "Login banner file /etc/issue does not have correct owner. Setting..."
    chown root /etc/issue
  fi
  if [ $(stat --format=%g /etc/issue) == "0" ]; then
    echo "Login banner file /etc/issue has correct group (gid = 0)"
  else
    echo "Login banner file /etc/issue does not have correct group. Setting..."
    chgrp root /etc/issue
  fi
  if [ $(stat --format=%a /etc/issue) == "644" ]; then
    echo "Login banner file /etc/issue has correct permissions (644)"
  else
    echo "Login banner file /etc/issue does not have correct permissions. Setting..."
    chmod 644 /etc/issue
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.7.1.6 Ensure permissions on /etc/issue.net are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/issue.net) == "0" ]; then
    echo "Network login banner file /etc/issue.net has correct owner (uid = 0)"
  else
    echo "Network login banner file /etc/issue.net does not have correct owner. Setting..."
    chown root /etc/issue.net
  fi
  if [ $(stat --format=%g /etc/issue.net) == "0" ]; then
    echo "Network login banner file /etc/issue.net has correct group (gid = 0)"
  else
    echo "Network login banner file /etc/issue.net does not have correct group. Setting..."
    chgrp root /etc/issue.net
  fi
  if [ $(stat --format=%a /etc/issue.net) == "644" ]; then
    echo "Network login banner file /etc/issue.net has correct permissions (644)"
  else
    echo "Network login banner file /etc/issue.net does not have correct permissions. Setting..."
    chmod 644 /etc/issue.net
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.7.2 Ensure GDM login banner is configured"
  DEBUG echo "===================================================================="
  if [ -e /etc/dconf/profile/gdm ]; then
  	if [ $(grep "banner-message-enable=true" /etc/dconf/db/gdm.d/01-banner-message) -ne 1]; then
  		echo "MANUAL ACTION: Set a banner for the graphical login manager"
  	fi
  else
  	echo "Verified GDM not installed. Skipping required banner setting"
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 1.8 Ensure updates, patches, and additional security software are installed"
  DEBUG echo "===================================================================="
  echo "NOTE: Operating System updates performed at the beginning of this script"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.1 inetd Services"
  DEBUG echo "===================================================================="
  if ( ! rpm -q xinetd &> /dev/null ) && ( ! rpm -q openbsd-inetd &> /dev/null ); then
    echo "inetd and xinetd are not installed on this system. Skipping the following checks:"
    echo "-- 2.1.1 - Ensure chargen services are not enabled"
    echo "-- 2.1.2 - Ensure daytime services are not enabled"
    echo "-- 2.1.3 - Ensure discard services are not enabled"
    echo "-- 2.1.4 - Ensure echo services are not enabled"
    echo "-- 2.1.5 - Ensure time services are not enabled"
    echo "-- 2.1.6 - Ensure tftp server is not enabled"
    echo "-- 2.1.7 - Ensure xinetd is not enabled"
  else
    if ( rpm -q openbsd-inetd &> /dev/null ); then
      echo "Found inetd services installed on this host. Disabling and removing..."
      /etc/init.d/inetd stop
      yum -y remove openbsd-inetd
      echo "inetd service removed. Skipping the following checks:"
      echo "-- 2.1.1 - Ensure chargen services are not enabled"
      echo "-- 2.1.2 - Ensure daytime services are not enabled"
      echo "-- 2.1.3 - Ensure discard services are not enabled"
      echo "-- 2.1.4 - Ensure echo services are not enabled"
      echo "-- 2.1.5 - Ensure time services are not enabled"
      echo "-- 2.1.7 - Ensure tftp server is not enabled"
    fi
    if ( ! rpm -q xinetd &> /dev/null ); then
      echo "Found xinetd services installed on this host. Disabling and removing..."
      /etc/init.d/xinetd stop
      yum -q remove xinetd
    fi
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2 Special Purpose Services"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.1 Time Synchronization"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.1.1 Ensure time synchronization is in use"
  DEBUG echo "===================================================================="
  PACKAGE=ntp
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed. Installing..."
    yum -y install $PACKAGE
  else
    echo "Package '$PACKAGE' already installed."
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.1.2 Ensure ntp is configured"
  DEBUG echo "===================================================================="
  echo "MANUAL ACTION: Ensure ntp is configured"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.1.4 Ensure chrony is configured"
  DEBUG echo "===================================================================="
  echo "MANUAL ACTION: Ensure chrony is configured"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.2 Ensure X Window System is not installed"
  DEBUG echo "===================================================================="
  PACKAGE=xorg-x11*
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.3 Ensure Avahi Server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=avahi
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.4 Ensure CUPS is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=cups
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.5 Ensure DHCP Server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=dhcp
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.6 Ensure LDAP server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=openldap
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.7 Ensure NFS and RPC are not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=nfs-utils
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  PACKAGE=rpcbind
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.8 Ensure DNS Server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=bind-utils
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  PACKAGE=bind
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.9 Ensure FTP Server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=vsftpd
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.10 Ensure HTTP Server is not enabled"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.11 Ensure IMAP and POP3 server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=dovecot
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.12 Ensure Samba is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=samba
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.13 Ensure HTTP Proxy is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=squid
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.14 Ensure SNMP server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=net-snmp
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.15 Ensure mail transfer agent is configured for local-only mode"
  DEBUG echo "===================================================================="
  if [ ! -f /etc/postfix/main.cf ]; then
    echo "File not found. Postfix not installed"
  else
    echo "Checking for local mode"
    if grep -q "#inet_interfaces = loopback-only" /etc/postfix/main.cf; then
      echo "Patching"
      sed -i 's/#inet_interfaces = loopback-only/inet_interfaces = loopback-only/g' /etc/postfix/main.cf
    else
      echo "configured correctly"
    fi
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.16 Ensure NIS Server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=ypserv
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.17 Ensure rsh server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=rsh-server
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.18 Ensure talk server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=ntalk
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.19 Ensure telnet server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=telnet-server
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.20 Ensure tftp server is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=tftp
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  PACKAGE=atftp
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.2.21 Ensure rsync service is not enabled"
  DEBUG echo "===================================================================="
  PACKAGE=rsync
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.3 Service Clients"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.3.1 Ensure NIS Client is not installed"
  DEBUG echo "===================================================================="
  PACKAGE=ypbind
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.3.2 Ensure rsh client is not installed"
  DEBUG echo "===================================================================="
  PACKAGE=rsh
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.3.3 Ensure talk client is not installed"
  DEBUG echo "===================================================================="
  PACKAGE=talk
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.3.4 Ensure telnet client is not installed"
  DEBUG echo "===================================================================="
  PACKAGE=telnet
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 2.3.5 Ensure LDAP client is not installed"
  DEBUG echo "===================================================================="
  PACKAGE=openldap-clients
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed - according to policy"
  else
    echo "Package '$PACKAGE' is installed. Removing..."
    yum -y remove $PACKAGE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.1 Network Parameters (Host Only)"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.1.1 Ensure IP forwarding is disabled"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv4.ip_forward" /etc/sysctl.conf)" == "net.ipv4.ip_forward = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable IP forwarding on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for IP forwarding. Resolving..."
    sed -i 's/^net.ipv4.ip_forward.*//g' /etc/sysctl.conf
    echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.1.2 Ensure packet redirect sending is disabled"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv4.conf.all.send_redirects" /etc/sysctl.conf)" == "net.ipv4.conf.all.send_redirects = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable all IP packet redirects on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for all IP packet redirects. Resolving..."
    sed -i 's/^net.ipv4.conf.all.send_redirects.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf
  fi
  if [ "$(grep "net.ipv4.conf.default.send_redirects" /etc/sysctl.conf)" == "net.ipv4.conf.default.send_redirects = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable default IP packet redirects on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for default IP packet redirects. Resolving..."
    sed -i 's/^net.ipv4.conf.default.send_redirects.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.2 Network Parameters (Host and Router)"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.2.1 Ensure source routed packets are not accepted"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv4.conf.all.accept_source_route" /etc/sysctl.conf)" == "net.ipv4.conf.all.accept_source_route = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable all IP packet routing on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for all IP packet routing. Resolving..."
    sed -i 's/^net.ipv4.conf.all.accept_source_route.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.all.accept_source_route = 0" >> /etc/sysctl.conf
  fi
  if [ "$(grep "net.ipv4.conf.default.accept_source_route" /etc/sysctl.conf)" == "net.ipv4.conf.default.accept_source_route = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable default IP packet routing on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for default IP packet routing. Resolving..."
    sed -i 's/^net.ipv4.conf.default.accept_source_route.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.2.2 Ensure ICMP redirects are not accepted"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv4.conf.all.accept_redirects" /etc/sysctl.conf)" == "net.ipv4.conf.all.accept_redirects = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable all ICMP packet redirects on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for all ICMP packet redirects. Resolving..."
    sed -i 's/^net.ipv4.conf.all.accept_redirects.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
  fi
  if [ "$(grep "net.ipv4.conf.default.accept_redirects" /etc/sysctl.conf)" == "net.ipv4.conf.default.accept_redirects = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable default ICMP packet redirects on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for default ICMP packet redirects. Resolving..."
    sed -i 's/^net.ipv4.conf.default.accept_redirects.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.2.3 Ensure secure ICMP redirects are not accepted"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv4.conf.all.secure_redirects" /etc/sysctl.conf)" == "net.ipv4.conf.all.secure_redirects = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable all secure ICMP packet redirects on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for all secure ICMP packet redirects. Resolving..."
    sed -i 's/^net.ipv4.conf.all.secure_redirects.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.all.secure_redirects = 0" >> /etc/sysctl.conf
  fi
  if [ "$(grep "net.ipv4.conf.default.secure_redirects" /etc/sysctl.conf)" == "net.ipv4.conf.default.secure_redirects = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable default secure ICMP packet redirects on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for default secure ICMP packet redirects. Resolving..."
    sed -i 's/^net.ipv4.conf.default.secure_redirects.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.2.4 Ensure suspicious packets are logged"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv4.conf.all.log_martians" /etc/sysctl.conf)" == "net.ipv4.conf.all.log_martians = 1" ]; then
    echo "/etc/sysctl.conf is configured to enable logging on all suspicious packets on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for all logging on all suspicious packets. Resolving..."
    sed -i 's/^net.ipv4.conf.all.log_martians.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.conf
  fi
  if [ "$(grep "net.ipv4.conf.default.log_martians" /etc/sysctl.conf)" == "net.ipv4.conf.default.log_martians = 1" ]; then
    echo "/etc/sysctl.conf is configured to enable logging default suspicious packets on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for default logging on all suspicious packets. Resolving..."
    sed -i 's/^net.ipv4.conf.default.log_martians.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.2.5 Ensure broadcast ICMP requests are ignored"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv4.icmp_echo_ignore_broadcasts" /etc/sysctl.conf)" == "net.ipv4.icmp_echo_ignore_broadcasts = 1" ]; then
    echo "/etc/sysctl.conf is configured to ignore broadcast ICMP on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly to ignore broadcast ICMP. Resolving..."
    sed -i 's/^net.ipv4.icmp_echo_ignore_broadcasts.*//g' /etc/sysctl.conf
    echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.2.6 Ensure bogus ICMP responses are ignored"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv4.icmp_ignore_bogus_error_responses" /etc/sysctl.conf)" == "net.ipv4.icmp_ignore_bogus_error_responses = 1" ]; then
    echo "/etc/sysctl.conf is configured to ignore bogus ICMP responses on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly to ignore bogus ICMP responses. Resolving..."
    sed -i 's/^net.ipv4.icmp_ignore_bogus_error_responses.*//g' /etc/sysctl.conf
    echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.2.7 Ensure Reverse Path Filtering is enabled"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv4.conf.all.rp_filter" /etc/sysctl.conf)" == "net.ipv4.conf.all.rp_filter = 1" ]; then
    echo "/etc/sysctl.conf is configured to filter all reverse IP path on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for all reverse IP path requests. Resolving..."
    sed -i 's/^net.ipv4.conf.all.rp_filter.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf
  fi
  if [ "$(grep "net.ipv4.conf.default.rp_filter" /etc/sysctl.conf)" == "net.ipv4.conf.default.rp_filter = 1" ]; then
    echo "/etc/sysctl.conf is configured to filter default reverse IP path on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for default reverse IP path requests. Resolving..."
    sed -i 's/^net.ipv4.conf.default.rp_filter.*//g' /etc/sysctl.conf
    echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.2.8 Ensure TCP SYN Cookies is enabled"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv4.tcp_syncookies" /etc/sysctl.conf)" == "net.ipv4.tcp_syncookies = 1" ]; then
    echo "/etc/sysctl.conf is configured to enable TCP SYN cookies on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for TCP SYN cookies. Resolving..."
    sed -i 's/^net.ipv4.tcp_syncookies.*//g' /etc/sysctl.conf
    echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.3 IPv6"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.3.1 Ensure IPv6 router advertisements are not accepted"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv6.conf.all.accept_ra" /etc/sysctl.conf)" == "net.ipv6.conf.all.accept_ra = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable all IPv6 router advertisements on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for all IPv6 router advertisements. Resolving..."
    sed -i 's/^net.ipv6.conf.all.accept_ra.*//g' /etc/sysctl.conf
    echo "net.ipv6.conf.all.accept_ra = 0" >> /etc/sysctl.conf
  fi
  if [ "$(grep "net.ipv6.conf.default.accept_ra" /etc/sysctl.conf)" == "net.ipv6.conf.default.accept_ra = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable default IPv6 router advertisements on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for default IPv6 router advertisements. Resolving..."
    sed -i 's/^net.ipv6.conf.default.accept_ra.*//g' /etc/sysctl.conf
    echo "net.ipv6.conf.default.accept_ra = 0" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.3.2 Ensure IPv6 redirects are not accepted"
  DEBUG echo "===================================================================="
  if [ "$(grep "net.ipv6.conf.all.accept_redirects" /etc/sysctl.conf)" == "net.ipv6.conf.all.accept_redirects = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable all IPv6 packet redirects on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for all IPv6 packet redirects. Resolving..."
    sed -i 's/^net.ipv6.conf.all.accept_redirects.*//g' /etc/sysctl.conf
    echo "net.ipv6.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
  fi
  if [ "$(grep "net.ipv6.conf.default.accept_redirects" /etc/sysctl.conf)" == "net.ipv6.conf.default.accept_redirects = 0" ]; then
    echo "/etc/sysctl.conf is configured to disable default IPv6 packet redirects on startup"
  else
    echo "/etc/sysctl.conf is not configured correctly for default IPv6 packet redirects. Resolving..."
    sed -i 's/^net.ipv6.conf.default.accept_redirects.*//g' /etc/sysctl.conf
    echo "net.ipv6.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.3.3 Ensure IPv6 is disabled"
  DEBUG echo "===================================================================="
  if [ "$(grep "options ipv6 disable" /etc/modprobe.d/CIS.conf)" == "options ipv6 disable=1" ]; then
    echo "/etc/modprobe.d/CIS.conf is configured to disable IPv6 on startup"
  else
    echo "/etc/modprobe.d/CIS.conf is not configured correctly to disable IPv6. Resolving..."
    sed -i 's/^options ipv6 disable.*//g' /etc/modprobe.d/CIS.conf
    echo "options ipv6 disable=1" >> /etc/modprobe.d/CIS.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.4 TCP Wrappers"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.4.1 Ensure TCP Wrappers is installed"
  DEBUG echo "===================================================================="
  PACKAGE=tcp_wrappers
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed. Installing..."
    yum -y install $PACKAGE
  else
    echo "Package '$PACKAGE' already installed."
  fi
  PACKAGE=tcp_wrappers-libs
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed. Installing..."
    yum -y install $PACKAGE
  else
    echo "Package '$PACKAGE' already installed."
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.4.2 Ensure /etc/hosts.allow is configured"
  DEBUG echo "===================================================================="
  echo "ALL : 172.19.*.* 172.30.*.* 159.142.*.* 192.168.*.* 10.*" >> /etc/hosts.allow

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.4.3 Ensure /etc/hosts.deny is configured"
  DEBUG echo "===================================================================="
  echo "ALL : ALL" >> /etc/hosts.deny

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.4.4 Ensure permissions on /etc/hosts.allow are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/hosts.allow) == "0" ]; then
    echo "Config file /etc/hosts.allow has correct owner (uid = 0)"
  else
    echo "Config file /etc/hosts.allow does not have correct owner. Setting..."
    chown root /etc/hosts.allow
  fi
  if [ $(stat --format=%g /etc/hosts.allow) == "0" ]; then
    echo "Config file /etc/hosts.allow has correct group (gid = 0)"
  else
    echo "Config file /etc/hosts.allow does not have correct group. Setting..."
    chgrp root /etc/hosts.allow
  fi
  if [ $(stat --format=%a /etc/hosts.allow) == "644" ]; then
    echo "Config file /etc/hosts.allow has correct permissions (644)"
  else
    echo "Config file /etc/hosts.allow does not have correct permissions. Setting..."
    chmod 644 /etc/hosts.allow
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.4.5 Ensure permissions on /etc/hosts.deny are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/hosts.deny) == "0" ]; then
    echo "Config file /etc/hosts.deny has correct owner (uid = 0)"
  else
    echo "Config file /etc/hosts.deny does not have correct owner. Setting..."
    chown root /etc/hosts.deny
  fi
  if [ $(stat --format=%g /etc/hosts.deny) == "0" ]; then
    echo "config file /etc/hosts.deny has correct group (gid = 0)"
  else
    echo "Config file /etc/hosts.deny does not have correct group. Setting..."
    chgrp root /etc/hosts.deny
  fi
  if [ $(stat --format=%a /etc/hosts.deny) == "644" ]; then
    echo "Config file /etc/hosts.deny has correct permissions (644)"
  else
    echo "Config file /etc/hosts.deny does not have correct permissions. Setting..."
    chmod 644 /etc/hosts.deny
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.5 Uncommon Network Protocols"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.5.1 Ensure DCCP is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install dccp /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "dccp is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "dccp is not currently disabled. Disabling..."
    echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.5.2 Ensure sctp is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install sctp /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "sctp is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "sctp is not currently disabled. Disabling..."
    echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.5.3 Ensure RDS is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install rds /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "rds is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "rds is not currently disabled. Disabling..."
    echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.5.4 Ensure TIPC is disabled"
  DEBUG echo "===================================================================="
  if grep -q "install tipc /bin/true" /etc/modprobe.d/CIS.conf; then
    echo "tipc is disabled in /etc/modprobe.d/CIS.conf"
  else
    echo "tipc is not currently disabled. Disabling..."
    echo "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.6 Firewall Configuration"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.6.1 Ensure iptables is installed"
  DEBUG echo "===================================================================="
  PACKAGE=iptables
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed. You must install and configure a host-based firewall"
  else
    echo "Package '$PACKAGE' already installed."
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 3.7 Ensure wireless interfaces are disabled"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Disable all wireless interfaces"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.1 Configure System Accounting (auditd)"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.1.1 Configure Data Retention"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.1.1.1 Ensure audit log storage size is configured"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure audit log storage size is configured"
  echo "Currently set at:"
  grep "^max_log_file " /etc/audit/auditd.conf

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.1.1.2 Ensure system is disabled when audit logs are full"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure system is disabled when audit logs are full"
  echo "Currently set at:"
  grep "^space_left_action " /etc/audit/auditd.conf
  grep "^action_mail_acct " /etc/audit/auditd.conf
  grep "^admin_space_left_action " /etc/audit/auditd.conf

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.1.1.3 Ensure audit logs are not automatically deleted"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure audit logs are not automatically deleted"
  echo "Currently set at:"
  grep "^max_log_file_action " /etc/audit/auditd.conf

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.1.2 Ensure auditd service is enabled"
  DEBUG echo "===================================================================="
  PACKAGE=audit
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed. Installing..."
    yum -y install $PACKAGE
  else
    echo "Package '$PACKAGE' already installed."
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.1.3 Ensure auditing for processes that start prior to auditd is enabled"
  DEBUG echo "===================================================================="
  if [ $(grep "^\s*linux" /boot/grub/grub.cfg | grep "audit=0" | wc -l) -ge 1 ]; then
    echo "Audit deamon found disabled in /boot/grub/grub.cfg. You must resolve this"
    echo "MANUAL ACTION: Fix linux kernel line with disabled audit configuration"
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.1.4 - 4.1.18 Ensure auditd configuration"
  DEBUG echo "===================================================================="
  echo "Setting required configuration in /etc/audit/audit.rules"

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

# 4.1.4 Ensure events that modify date and time information are collected
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change
-a always,exit -F arch=b64 -S clock_settime -k time-change
-a always,exit -F arch=b32 -S clock_settime -k time-change
-w /etc/localtime -p wa -k time-change

# 4.1.5 Ensure events that modify user/group information are collected
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity

# 4.1.6 Ensure events that modify the system's network environment are collected
-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale

# 4.1.7 Ensure events that modify the system's Mandatory Access Controls are collected
-w /etc/selinux/ -p wa -k MAC-policy

# 4.1.8 Ensure login and logout events are collected
-w /var/log/faillog -p wa -k logins
-w /var/log/lastlog -p wa -k logins
-w /var/log/tallylog -p wa -k logins

# 4.1.9 Ensure session initiation information is collected
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k session
-w /var/log/btmp -p wa -k session

# 4.1.10 Ensure discretionary access control permission modification events are collected
-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod

# 4.1.11 Ensure unsuccessful unauthorized file access attempts are collected
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate \-F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate \-F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate \-F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate \-F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access

# 4.1.13 Ensure successful file system mounts are collected
-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts
-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts

# 4.1.14 Ensure file deletion events by users are collected
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-a always,exit -F arch=ARCH -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-a always,exit -F arch=ARCH -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid=0 -k delete

# 4.1.15 Ensure changes to system administration scope (sudoers) is collected
-w /etc/sudoers -p wa -k scope

# 4.1.16 Ensure system administrator actions (sudolog) are collected
-w /var/log/sudo.log -p wa -k actions

# 4.1.17 Ensure kernel module loading and unloading is collected
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
-a always,exit -F arch=b64 -S init_module -S delete_module -k modules

# 4.1.18 Ensure the audit configuration is immutable
-e 2
EOF

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.2.1 Configure rsyslog"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.2.1.1 Ensure rsyslog Service is enabled"
  DEBUG echo "===================================================================="
  PACKAGE=rsyslog
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed. Installing..."
    yum -y install $PACKAGE
  else
    echo "Package '$PACKAGE' already installed."
  fi
  if ( systemctl is-enabled rsyslog &> /dev/null ); then
    echo "rsyslog is enabled - according to policy"
  else
    echo "rsyslog is not enabled"
    echo "MANUAL ACTION: enable and configure rsyslog"
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.2.1.2 Ensure logging is configured"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure logging is configured to your Organizational needs"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.2.1.3 Ensure rsyslog default file permissions configured"
  DEBUG echo "===================================================================="
  if [ "$(grep ^\$FileCreateMode /etc/rsyslog.conf)" == "\$FileCreateMode 0640" ]; then
    echo "/etc/rsyslog.conf is configured for log file creation permissions"
  else
    echo "/etc/rsyslog.conf is not configured correctly for log file creation permissions. Resolving..."
    sed -i 's/^\$FileCreateMode.*//g' /etc/rsyslog.conf
    echo "\$FileCreateMode 0640" >> /etc/rsyslog.conf
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.2.1.4 Ensure rsyslog is configured to send logs to a remote log host"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure rsyslog is configured to send logs to a remote log host"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.2.1.5 Ensure remote rsyslog messages are only accepted on designated log hosts"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure remote rsyslog messages are only accepted on designated log hosts"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.2.2 Configure syslog-ng"
  DEBUG echo "===================================================================="
  echo "Configure syslog-ng. Skipping syslog-ng configuration..."

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.2.3 Ensure rsyslog or syslog-ng is installed"
  DEBUG echo "===================================================================="
  PACKAGE=rsyslog
  if ( ! rpm -q $PACKAGE &> /dev/null ); then
    echo "Package '$PACKAGE' is not installed. Installing..."
    yum -y install $PACKAGE
  else
    echo "Package '$PACKAGE' already installed."
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.2.4 Ensure permissions on all logfiles are configured"
  DEBUG echo "===================================================================="
  echo "MANUAL ACTION: Ensure permissions on all logfiles are configured"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 4.3 Ensure logrotate is configured"
  DEBUG echo "===================================================================="
  echo "MANUAL ACTION: Ensure logrotate is configured"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.1 Configure cron"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.1.1 Ensure cron daemon is enabled"
  DEBUG echo "===================================================================="
  SERVICE=crond
  if ( systemctl is-enabled $SERVICE &> /dev/null ); then
    echo "$SERVICE is enabled - according to policy"
  else
    echo "$SERVICE is not enabled. Resolving..."
    systemctl enable $SERVICE
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.1.2 Ensure permissions on /etc/crontab are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/crontab) == "0" ]; then
    echo "Config file /etc/crontab has correct owner (uid = 0)"
  else
    echo "Config file /etc/crontab does not have correct owner. Setting..."
    chown root /etc/crontab
  fi
  if [ $(stat --format=%g /etc/crontab) == "0" ]; then
    echo "config file /etc/crontab has correct group (gid = 0)"
  else
    echo "Config file /etc/crontab does not have correct group. Setting..."
    chgrp root /etc/crontab
  fi
  if [ $(stat --format=%a /etc/crontab) == "600" ]; then
    echo "Config file /etc/crontab has correct permissions (644)"
  else
    echo "Config file /etc/crontab does not have correct permissions. Setting..."
    chmod 600 /etc/crontab
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.1.3 Ensure permissions on /etc/cron.hourly are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/cron.hourly) == "0" ]; then
    echo "Config file /etc/cron.hourly has correct owner (uid = 0)"
  else
    echo "Config file /etc/cron.hourly does not have correct owner. Setting..."
    chown root /etc/cron.hourly
  fi
  if [ $(stat --format=%g /etc/cron.hourly) == "0" ]; then
    echo "config file /etc/cron.hourly has correct group (gid = 0)"
  else
    echo "Config file /etc/cron.hourly does not have correct group. Setting..."
    chgrp root /etc/cron.hourly
  fi
  if [ $(stat --format=%a /etc/cron.hourly) == "600" ]; then
    echo "Config file /etc/cron.hourly has correct permissions (644)"
  else
    echo "Config file /etc/cron.hourly does not have correct permissions. Setting..."
    chmod 600 /etc/cron.hourly
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.1.4 Ensure permissions on /etc/cron.daily are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/cron.daily) == "0" ]; then
    echo "Config file /etc/cron.daily has correct owner (uid = 0)"
  else
    echo "Config file /etc/cron.daily does not have correct owner. Setting..."
    chown root /etc/cron.daily
  fi
  if [ $(stat --format=%g /etc/cron.daily) == "0" ]; then
    echo "config file /etc/cron.daily has correct group (gid = 0)"
  else
    echo "Config file /etc/cron.daily does not have correct group. Setting..."
    chgrp root /etc/cron.daily
  fi
  if [ $(stat --format=%a /etc/cron.daily) == "600" ]; then
    echo "Config file /etc/cron.daily has correct permissions (644)"
  else
    echo "Config file /etc/cron.daily does not have correct permissions. Setting..."
    chmod 600 /etc/cron.daily
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.1.5 Ensure permissions on /etc/cron.weekly are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/cron.weekly) == "0" ]; then
    echo "Config file /etc/cron.weekly has correct owner (uid = 0)"
  else
    echo "Config file /etc/cron.weekly does not have correct owner. Setting..."
    chown root /etc/cron.weekly
  fi
  if [ $(stat --format=%g /etc/cron.weekly) == "0" ]; then
    echo "config file /etc/cron.weekly has correct group (gid = 0)"
  else
    echo "Config file /etc/cron.weekly does not have correct group. Setting..."
    chgrp root /etc/cron.weekly
  fi
  if [ $(stat --format=%a /etc/cron.weekly) == "600" ]; then
    echo "Config file /etc/cron.weekly has correct permissions (644)"
  else
    echo "Config file /etc/cron.weekly does not have correct permissions. Setting..."
    chmod 600 /etc/cron.weekly
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.1.6 Ensure permissions on /etc/cron.monthly are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/cron.monthly) == "0" ]; then
    echo "Config file /etc/cron.monthly has correct owner (uid = 0)"
  else
    echo "Config file /etc/cron.monthly does not have correct owner. Setting..."
    chown root /etc/cron.monthly
  fi
  if [ $(stat --format=%g /etc/cron.monthly) == "0" ]; then
    echo "config file /etc/cron.monthly has correct group (gid = 0)"
  else
    echo "Config file /etc/cron.monthly does not have correct group. Setting..."
    chgrp root /etc/cron.monthly
  fi
  if [ $(stat --format=%a /etc/cron.monthly) == "600" ]; then
    echo "Config file /etc/cron.monthly has correct permissions (644)"
  else
    echo "Config file /etc/cron.monthly does not have correct permissions. Setting..."
    chmod 600 /etc/cron.monthly
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.1.7 Ensure permissions on /etc/cron.d are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/cron.d) == "0" ]; then
    echo "Config file /etc/cron.d has correct owner (uid = 0)"
  else
    echo "Config file /etc/cron.d does not have correct owner. Setting..."
    chown root /etc/cron.d
  fi
  if [ $(stat --format=%g /etc/cron.d) == "0" ]; then
    echo "config file /etc/cron.d has correct group (gid = 0)"
  else
    echo "Config file /etc/cron.d does not have correct group. Setting..."
    chgrp root /etc/cron.d
  fi
  if [ $(stat --format=%a /etc/cron.d) == "600" ]; then
    echo "Config file /etc/cron.d has correct permissions (644)"
  else
    echo "Config file /etc/cron.d does not have correct permissions. Setting..."
    chmod 600 /etc/cron.d
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.1.8 Ensure at/cron is restricted to authorized users"
  DEBUG echo "===================================================================="
  if [ -f /etc/cron.deny ]; then
    echo "/etc/cron.deny file exists. Removing..."
    rm -f /etc/cron.deny
  fi

  if [ -f /etc/at.deny ]; then
    echo "/etc/at.deny file exists. Removing..."
    rm -f /etc/at.deny
  fi

  echo "Enforcing file restrictions on /etc/cron.allow and /etc/at.allow"
  touch /etc/cron.allow
  touch /etc/at.allow
  chmod og-rwx /etc/cron.allow
  chmod og-rwx /etc/at.allow
  chown root:root /etc/cron.allow
  chown root:root /etc/at.allow

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2 SSH Server Configuration"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/ssh/sshd_config) == "0" ]; then
    echo "Config file /etc/ssh/sshd_config has correct owner (uid = 0)"
  else
    echo "Config file /etc/ssh/sshd_config does not have correct owner. Setting..."
    chown root /etc/ssh/sshd_config
  fi
  if [ $(stat --format=%g /etc/ssh/sshd_config) == "0" ]; then
    echo "config file /etc/ssh/sshd_config has correct group (gid = 0)"
  else
    echo "Config file /etc/ssh/sshd_config does not have correct group. Setting..."
    chgrp root /etc/ssh/sshd_config
  fi
  if [ $(stat --format=%a /etc/ssh/sshd_config) == "600" ]; then
    echo "Config file /etc/ssh/sshd_config has correct permissions (600)"
  else
    echo "Config file /etc/ssh/sshd_config does not have correct permissions. Setting..."
    chmod 600 /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.2 Ensure SSH Protocol is set to 2"
  DEBUG echo "===================================================================="
  if [ "$(grep ^Protocol /etc/ssd/sshd_config)" == "Protocol 2" ]; then
    echo "/etc/ssd/sshd_config is configured for Protocol version"
  else
    echo "/etc/ssd/sshd_config is not configured correctly for Protocol version. Resolving..."
    sed -i 's/^Protocol.*//g' /etc/ssh/sshd_config
    echo "Protocol 2" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.3 Ensure SSH LogLevel is set to INFO"
  DEBUG echo "===================================================================="
  if [ "$(grep ^LogLevel /etc/ssd/sshd_config)" == "LogLevel INFO" ]; then
    echo "/etc/ssd/sshd_config is configured for correct log level"
  else
    echo "/etc/ssd/sshd_config is not configured for correct log level. Resolving..."
    sed -i 's/^LogLevel.*//g' /etc/ssh/sshd_config
    echo "LogLevel INFO" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.4 Ensure SSH X11 forwarding is disabled"
  DEBUG echo "===================================================================="
  if [ "$(grep ^X11Forwarding /etc/ssd/sshd_config)" == "X11Forwarding no" ]; then
    echo "/etc/ssd/sshd_config is configured for correct log level"
  else
    echo "/etc/ssd/sshd_config is not configured for correct log level. Resolving..."
    sed -i 's/^X11Forwarding.*//g' /etc/ssh/sshd_config
    echo "X11Forwarding no" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.5 Ensure SSH MaxAuthTries is set to 4 or less"
  DEBUG echo "===================================================================="
  if [ "$(grep ^MaxAuthTries /etc/ssd/sshd_config)" == "MaxAuthTries 4" ]; then
    echo "/etc/ssd/sshd_config is configured for correct MaxAuthTries"
  else
    echo "/etc/ssd/sshd_config is not configured for correct MaxAuthTries. Resolving..."
    sed -i 's/^MaxAuthTries.*//g' /etc/ssh/sshd_config
    echo "MaxAuthTries 4" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.6 Ensure SSH IgnoreRhosts is enabled"
  DEBUG echo "===================================================================="
  if [ "$(grep ^IgnoreRhosts /etc/ssd/sshd_config)" == "IgnoreRhosts yes" ]; then
    echo "/etc/ssd/sshd_config is configured for correctly IgnoreRhosts"
  else
    echo "/etc/ssd/sshd_config is not configured for correct IgnoreRhosts. Resolving..."
    sed -i 's/^IgnoreRhosts.*//g' /etc/ssh/sshd_config
    echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.7 Ensure SSH HostbasedAuthentication is disabled"
  DEBUG echo "===================================================================="
  if [ "$(grep ^HostbasedAuthentication /etc/ssd/sshd_config)" == "HostbasedAuthentication no" ]; then
    echo "/etc/ssd/sshd_config is configured for correctly HostbasedAuthentication"
  else
    echo "/etc/ssd/sshd_config is not configured for correct HostbasedAuthentication. Resolving..."
    sed -i 's/^HostbasedAuthentication.*//g' /etc/ssh/sshd_config
    echo "HostbasedAuthentication no" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.8 Ensure SSH root login is disabled"
  DEBUG echo "===================================================================="
  if [ "$(grep ^PermitRootLogin /etc/ssd/sshd_config)" == "PermitRootLogin no" ]; then
    echo "/etc/ssd/sshd_config is configured for correctly PermitRootLogin"
  else
    echo "/etc/ssd/sshd_config is not configured for correct PermitRootLogin. Resolving..."
    sed -i 's/^PermitRootLogin.*//g' /etc/ssh/sshd_config
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.9 Ensure SSH PermitEmptyPasswords is disabled"
  DEBUG echo "===================================================================="
  if [ "$(grep ^PermitEmptyPasswords /etc/ssd/sshd_config)" == "PermitEmptyPasswords no" ]; then
    echo "/etc/ssd/sshd_config is configured for correctly PermitEmptyPasswords"
  else
    echo "/etc/ssd/sshd_config is not configured for correct PermitEmptyPasswords. Resolving..."
    sed -i 's/^PermitEmptyPasswords.*//g' /etc/ssh/sshd_config
    echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.10 Ensure SSH PermitUserEnvironment is disabled"
  DEBUG echo "===================================================================="
  if [ "$(grep ^PermitUserEnvironment /etc/ssd/sshd_config)" == "PermitUserEnvironment no" ]; then
    echo "/etc/ssd/sshd_config is configured for correctly PermitUserEnvironment"
  else
    echo "/etc/ssd/sshd_config is not configured for correct PermitUserEnvironment. Resolving..."
    sed -i 's/^PermitUserEnvironment.*//g' /etc/ssh/sshd_config
    echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.11 Ensure only approved ciphers are used"
  DEBUG echo "===================================================================="
  if [ "$(grep ^Ciphers /etc/ssd/sshd_config)" == "Ciphers aes256-ctr,aes192-ctr,aes128-ctr" ]; then
    echo "/etc/ssd/sshd_config is configured for correct Ciphers"
  else
    echo "/etc/ssd/sshd_config is not configured for correct Ciphers. Resolving..."
    sed -i 's/^Ciphers.*//g' /etc/ssh/sshd_config
    echo "Ciphers aes256-ctr,aes192-ctr,aes128-ctr" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.12 Ensure only approved MAC algorithms are used"
  DEBUG echo "===================================================================="
  if [ "$(grep ^MACs /etc/ssd/sshd_config)" == "MACs hmac-sha2-512,hmac-sha2-256,hmac-ripemd160" ]; then
    echo "/etc/ssd/sshd_config is configured for correct MACs"
  else
    echo "/etc/ssd/sshd_config is not configured for correct MACs. Resolving..."
    sed -i 's/^MACs.*//g' /etc/ssh/sshd_config
    echo "MACs hmac-sha2-512,hmac-sha2-256,hmac-ripemd160" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.13 Ensure SSH Idle Timeout Interval is configured"
  DEBUG echo "===================================================================="
  if [ "$(grep ^ClientAliveInterval /etc/ssd/sshd_config)" == "ClientAliveInterval 300" ]; then
    echo "/etc/ssd/sshd_config is configured for correct ClientAliveInterval"
  else
    echo "/etc/ssd/sshd_config is not configured for correct ClientAliveInterval. Resolving..."
    sed -i 's/^ClientAliveInterval.*//g' /etc/ssh/sshd_config
    echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
  fi

  if [ "$(grep ^ClientAliveCountMax /etc/ssd/sshd_config)" == "ClientAliveCountMax 0" ]; then
    echo "/etc/ssd/sshd_config is configured for correct ClientAliveCountMax"
  else
    echo "/etc/ssd/sshd_config is not configured for correct ClientAliveCountMax. Resolving..."
    sed -i 's/^ClientAliveCountMax.*//g' /etc/ssh/sshd_config
    echo "ClientAliveCountMax 0" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.14 Ensure SSH LoginGraceTime is set to one minute or less"
  DEBUG echo "===================================================================="
  if [ "$(grep ^LoginGraceTime /etc/ssd/sshd_config)" == "LoginGraceTime 60" ]; then
    echo "/etc/ssd/sshd_config is configured for correct LoginGraceTime"
  else
    echo "/etc/ssd/sshd_config is not configured for correct LoginGraceTime. Resolving..."
    sed -i 's/^LoginGraceTime.*//g' /etc/ssh/sshd_config
    echo "LoginGraceTime 60" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.15 Ensure SSH access is limited"
  DEBUG echo "===================================================================="
  echo "MANUAL CHECK: Ensure SSH access is limited"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.2.16 Ensure SSH warning banner is configured"
  DEBUG echo "===================================================================="
  if [ "$(grep ^Banner /etc/ssd/sshd_config)" == "Banner /etc/issue.net" ]; then
    echo "/etc/ssd/sshd_config is configured for correct Banner"
  else
    echo "/etc/ssd/sshd_config is not configured for correct Banner. Resolving..."
    sed -i 's/^Banner.*//g' /etc/ssh/sshd_config
    echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.3 Configure PAM"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.3.1 Ensure password creation requirements are configured"
  DEBUG echo "===================================================================="
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
  # echo================================='
  # echo Checking For Correct Login.defs '
  # echo================================='
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
#					                                    	#
# These options are now handled by PAM. Please	#
# edit the appropriate file in /etc/pam.d/ to	  #
# enable the equivelants of them.               #
#                                               #
#################################################

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
#						                                      #
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

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.4 User Accounts and Environment"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.4.1 Set Shadow Password Suite Parameters"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.4.1.4 Ensure inactive password lock is 30 days or less"
  DEBUG echo "===================================================================="
  account="$(useradd -D | grep INACTIVE | awk '{print $1}')"
  if [ "$account" = "INACTIVE=35" ]; then
    echo "Already Patched"
  else
    echo "Patching"
    useradd -D -f 35
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.4.2 Ensure system accounts are non-login"
  DEBUG echo "===================================================================="
  if [ $(egrep -v "^\+" /etc/passwd | awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<1000 && $7!="/usr/sbin/nologin" && $7!="/bin/false") {print}' | wc -l) -ne 0 ]; then
    echo "You must set system accounts (< UID 1000) to a non-login status"
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.4.3 Ensure default group for the root account is GID 0"
  DEBUG echo "===================================================================="
  if [ $(grep "^root:" /etc/passwd | cut -f4 -d:) != "0" ]; then
    echo "MANUAL ACTION: Default GID is not zero. You must set this in /etc/passwd"
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.4.4 Ensure default user umask is 027 or more restrictive"
  DEBUG echo "===================================================================="
  defmask=$(grep -i "^umask" /etc/login.defs | awk '{print $2}')
  if [ $(($defmask + 0)) -lt 23 ]; then
    echo "You must set the system default umask to 027 or more restrictive in /etc/login.defs"
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.5 Ensure root login is restricted to system console"
  DEBUG echo "===================================================================="
  echo "MANUAL ACTION: Ensure root login is restricted to system console"
  echo "NOTE: This must be correct for your environment"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 5.6 Ensure access to the su command is restricted"
  DEBUG echo "===================================================================="
  if [ $(grep pam_wheel.so /etc/pam.d/su | egrep "^auth\s+required" | wc -l) -ne 1 ]; then
    echo "MANUAL ACTION: You must restrict access to su by editing /etc/pam.d/su"
  fi
  echo "you must verify the following users should be allowed access to su:"
  egrep "admin|sudo" /etc/group | cut -f4 -d:

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6 System Maintenance"
  DEBUG echo "===================================================================="

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.2 Ensure permissions on /etc/passwd are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/passwd) == "0" ]; then
    echo "Config file /etc/passwd has correct owner (uid = 0)"
  else
    echo "Config file /etc/passwd does not have correct owner. Setting..."
    chown root /etc/passwd
  fi
  if [ $(stat --format=%g /etc/passwd) == "0" ]; then
    echo "config file /etc/passwd has correct group (gid = 0)"
  else
    echo "Config file /etc/passwd does not have correct group. Setting..."
    chgrp root /etc/passwd
  fi
  if [ $(stat --format=%a /etc/passwd) == "644" ]; then
    echo "Config file /etc/passwd has correct permissions (644)"
  else
    echo "Config file /etc/passwd does not have correct permissions. Setting..."
    chmod 644 /etc/passwd
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.3 Ensure permissions on /etc/shadow are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/shadow) == "0" ]; then
    echo "Config file /etc/shadow has correct owner (uid = 0)"
  else
    echo "Config file /etc/shadow does not have correct owner. Setting..."
    chown root /etc/shadow
  fi
  if [ $(stat --format=%g /etc/shadow) == "0" ]; then
    echo "config file /etc/shadow has correct group (gid = 0)"
  else
    echo "Config file /etc/shadow does not have correct group. Setting..."
    chgrp root /etc/shadow
  fi
  if [ $(stat --format=%a /etc/shadow) == "000" ]; then
    echo "Config file /etc/shadow has correct permissions (000)"
  else
    echo "Config file /etc/shadow does not have correct permissions. Setting..."
    chmod 000 /etc/shadow
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.4 Ensure permissions on /etc/group are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/group) == "0" ]; then
    echo "Config file /etc/group has correct owner (uid = 0)"
  else
    echo "Config file /etc/group does not have correct owner. Setting..."
    chown root /etc/group
  fi
  if [ $(stat --format=%g /etc/group) == "0" ]; then
    echo "config file /etc/group has correct group (gid = 0)"
  else
    echo "Config file /etc/group does not have correct group. Setting..."
    chgrp root /etc/group
  fi
  if [ $(stat --format=%a /etc/group) == "644" ]; then
    echo "Config file /etc/group has correct permissions (644)"
  else
    echo "Config file /etc/group does not have correct permissions. Setting..."
    chmod 644 /etc/group
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.5 Ensure permissions on /etc/gshadow are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/gshadow) == "0" ]; then
    echo "Config file /etc/gshadow has correct owner (uid = 0)"
  else
    echo "Config file /etc/gshadow does not have correct owner. Setting..."
    chown root /etc/gshadow
  fi
  if [ $(stat --format=%g /etc/gshadow) == "0" ]; then
    echo "config file /etc/gshadow has correct group (gid = 0)"
  else
    echo "Config file /etc/gshadow does not have correct group. Setting..."
    chgrp root /etc/gshadow
  fi
  if [ $(stat --format=%a /etc/gshadow) == "000" ]; then
    echo "Config file /etc/gshadow has correct permissions (000)"
  else
    echo "Config file /etc/gshadow does not have correct permissions. Setting..."
    chmod 000 /etc/gshadow
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.6 Ensure permissions on /etc/passwd- are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/passwd-) == "0" ]; then
    echo "Config file /etc/passwd- has correct owner (uid = 0)"
  else
    echo "Config file /etc/passwd- does not have correct owner. Setting..."
    chown root /etc/passwd-
  fi
  if [ $(stat --format=%g /etc/passwd-) == "0" ]; then
    echo "config file /etc/passwd- has correct group (gid = 0)"
  else
    echo "Config file /etc/passwd- does not have correct group. Setting..."
    chgrp root /etc/passwd-
  fi
  if [ $(stat --format=%a /etc/passwd-) == "600" ]; then
    echo "Config file /etc/passwd- has correct permissions (600)"
  else
    echo "Config file /etc/passwd- does not have correct permissions. Setting..."
    chmod 600 /etc/passwd-
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.7 Ensure permissions on /etc/shadow- are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/shadow-) == "0" ]; then
    echo "Config file /etc/shadow- has correct owner (uid = 0)"
  else
    echo "Config file /etc/shadow- does not have correct owner. Setting..."
    chown root /etc/shadow-
  fi
  if [ $(stat --format=%g /etc/shadow-) == "0" ]; then
    echo "config file /etc/shadow- has correct group (gid = 0)"
  else
    echo "Config file /etc/shadow- does not have correct group. Setting..."
    chgrp root /etc/shadow-
  fi
  if [ $(stat --format=%a /etc/shadow-) == "600" ]; then
    echo "Config file /etc/shadow- has correct permissions (600)"
  else
    echo "Config file /etc/shadow- does not have correct permissions. Setting..."
    chmod 600 /etc/shadow-
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.8 Ensure permissions on /etc/group- are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/group-) == "0" ]; then
    echo "Config file /etc/group- has correct owner (uid = 0)"
  else
    echo "Config file /etc/group- does not have correct owner. Setting..."
    chown root /etc/group-
  fi
  if [ $(stat --format=%g /etc/group-) == "0" ]; then
    echo "config file /etc/group- has correct group (gid = 0)"
  else
    echo "Config file /etc/group- does not have correct group. Setting..."
    chgrp root /etc/group-
  fi
  if [ $(stat --format=%a /etc/group-) == "600" ]; then
    echo "Config file /etc/group- has correct permissions (600)"
  else
    echo "Config file /etc/group- does not have correct permissions. Setting..."
    chmod 600 /etc/group-
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.9 Ensure permissions on /etc/gshadow- are configured"
  DEBUG echo "===================================================================="
  if [ $(stat --format=%u /etc/gshadow-) == "0" ]; then
    echo "Config file /etc/gshadow- has correct owner (uid = 0)"
  else
    echo "Config file /etc/gshadow- does not have correct owner. Setting..."
    chown root /etc/gshadow-
  fi
  if [ $(stat --format=%g /etc/gshadow-) == "0" ]; then
    echo "config file /etc/gshadow- has correct group (gid = 0)"
  else
    echo "Config file /etc/gshadow- does not have correct gshadow. Setting..."
    chgrp root /etc/gshadow-
  fi
  if [ $(stat --format=%a /etc/gshadow-) == "600" ]; then
    echo "Config file /etc/gshadow- has correct permissions (600)"
  else
    echo "Config file /etc/gshadow- does not have correct permissions. Setting..."
    chmod 600 /etc/gshadow-
  fi

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.10 Ensure no world writable files exist"
  DEBUG echo "===================================================================="
  echo "MANUAL ACTUON: Ensure no world writable files exist"

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.11 Ensure no unowned files or directories exist"
  DEBUG echo "===================================================================="
  echo "Ensure no unowned files or directories exist"
  df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.12 Ensure no ungrouped files or directories exist"
  DEBUG echo "===================================================================="
  echo "Ensure no unowned files or directories exist"
  df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nogroup

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.13 Audit SUID executables"
  DEBUG echo "===================================================================="
  echo "Audit SUID executables"
  df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -4000

  DEBUG echo "===================================================================="
  DEBUG echo "Checking: 6.1.14 Audit SGID executables"
  DEBUG echo "===================================================================="
  echo "Audit SGID executables"
  df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -2000

fi