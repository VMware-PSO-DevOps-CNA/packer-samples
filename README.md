# packer-samples

Simple packer examples intended to make base images for VMware. 

These templates are organized for a 2 stage build process.  The `iso-to-vmx`
tree has configs for downloading and installing base OS from ISO, and leaves behind
the files needed to build a second stage.  In these examples, the second stage is only a push to
vSphere, but could include provisioning as well.

The 2 stage process allows faster building of the second stage alone.  No need to go through the
boot and save process, as we can just start from the existing vmx files. 



## Build Examples

You'll need to create a vars file for these to work.  See below for details.
  
### 2-stage ubuntu
  
    packer build -force -var-file vars.json iso-to-vmx/ubuntu/16.04.json
    packer build -force \
        -var-file vars.json \ 
        -var "vmx=output-ubuntu-16.04-amd64-vmware-iso/packer-ubuntu-16.04-amd64-vmware-iso.vmx" \
        vmx-to-vsphere/vmx-to-iso.json

### 2-stage centos
    packer build -force -var-file vars.json iso-to-vmx/centos/7.3.json
    packer build -force \
        -var-file vars.json \
        -var "vmx=output-centos-7.3-x86_64-vmware-iso/packer-centos-7.3-x86_64-vmware-iso.vmx" \
        vmx-to-vsphere/vmx-to-iso.json


## Packer vars file

Make a `vars.json` file like this, and run `packer build -vars-file vars.json` for the builds you like.

```json
{
  "memory": "1024",
  "cpu": "2",
  "insecure": "true",
  "disk_mode": "thin",
  "cluster": "BasementLab",
  "datacenter": "Goddard",
  "datastore": "esx-a-ssd",
  "host": "vcenter.home.local",
  "password": "XXXXX",
  "username": "administrator@home.local",
  "resource_pool": "",
  "vm_name": "{{user `role`}}-v{{user `version`}}",
  "vm_network": "VMNet"
}

```

## Packer Variables of Interest
  
Obvious... memory and disk size in MB.
  
    "memory": "512",
    "cpu": "1",
    "disk_size": "3000",
  
The ssh user/pass must match what is set in the VM for a default user

    "ssh_username": "vmware",
    "ssh_password": "VMware1!",

A preeseed file for customization of the base OS

    "preseed": "ubuntu/16.04.cfg",
  
  
### For slow environments:
Bump this up to leave 
enough time for the vm to boot before we start typing in the console.

    "boot_wait": "10s"
    
Set this to `<wait10>` if in really slow environments.
    
    "slow_typing": "<wait5>"
