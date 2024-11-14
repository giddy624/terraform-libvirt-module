terraform {
  source = "./modules/libvirt-vm"
}

inputs = {
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
