# Example usage of the libvirt-vm module

module "libvirt_vms" {
  source             = "../libvirt-vm"
  instance_name      = "Debian"
  instance_count     = 2
  memory             = 2048
  vcpu               = 2
  disks = [
    { source = "/var/lib/libvirt/images/debian-12.7.0-amd64-netinst.iso" },
    { size = 10737418240 }
  ]
  storage_pool_name  = "storage-pool"
  storage_pool_path  = "/var/lib/libvirt/kvm"
  disk_format        = "iso"
  network_interfaces = [{ name = "k8snet" }]
}

# Output the instance details
output "vm_names" {
  value = module.libvirt_vms.instance_names
}

output "vm_ips" {
  value = module.libvirt_vms.instance_ips
}