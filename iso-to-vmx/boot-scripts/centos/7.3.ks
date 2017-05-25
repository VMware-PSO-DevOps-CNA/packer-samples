install
text
reboot
url --mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
lang en_US.UTF-8
keyboard us
timezone --utc Etc/UTC
rootpw --plaintext VMware1!
user --name=vmware --groups=vmware --password=VMware1! --plaintext
zerombr
clearpart --all --initlabel
autopart --type=plain
bootloader --timeout=1

%packages
@core
which
# mandatory packages in the @core group
-btrfs-progs
-iprutils
-kexec-tools
-plymouth
# default packages in the @core group
-*-firmware
-dracut-config-rescue
-kernel-tools
-libsysfs
-microcode_ctl
-NetworkManager*
-postfix
-rdma
%end

%post --erroronfail
yum -y update

cat <<EOF > /etc/sudoers.d/vmware
Defaults:vmware !requiretty
vmware ALL=(ALL) NOPASSWD: ALL
EOF
chmod 440 /etc/sudoers.d/vmware

ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
EOF
%end
