# Terraform provider for libvirt
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Storage Pool Definition
resource "libvirt_pool" "storage_pool" {
  name = var.storage_pool_name
  type = "dir"
  target {
    path = var.storage_pool_path
  }
}

# Define storage volumes (disks)
#resource "libvirt_volume" "vm_disk" {
#  count  = length(var.disks)
#  name   = "${var.instance_name}-disk-${count.index}"
#  pool   = libvirt_pool.storage_pool.name
#  size   = var.disks[count.index].size
#  source = var.disks[count.index].source
#  format = var.disk_format
#}

# Volume resource with source image (no size)
resource "libvirt_volume" "vm_disk_with_source" {
  count  = length([for disk in var.disks : disk if disk.source != null])
  name   = "${var.instance_name}-disk-${count.index}"
  pool   = libvirt_pool.storage_pool.name
  format = var.disk_format
  source = var.disks[count.index].source
}

# Volume resource without source (specifying size)
resource "libvirt_volume" "vm_disk_with_size" {
  count  = length([for disk in var.disks : disk if disk.source == null])
  name   = "${var.instance_name}-disk-${count.index}"
  pool   = libvirt_pool.storage_pool.name
  size   = var.disks[count.index].size
  format = var.disk_format
}


# Define network interfaces
resource "libvirt_network" "network_interface" {
  count = length(var.network_interfaces)
  name  = var.network_interfaces[count.index].name
  mode = "nat"

  # Define the network address range
  addresses = ["192.168.100.0/24"]  # Use an IP range that doesn’t conflict with your existing network
}

# Define VM instances
resource "libvirt_domain" "vm" {
  count  = var.instance_count
  name   = "${var.instance_name}-${count.index}"
  memory = var.memory
  vcpu   = var.vcpu

  disk {
    volume_id = coalesce(
      libvirt_volume.vm_disk_with_source[count.index].id,
      libvirt_volume.vm_disk_with_size[count.index].id
    )
  }

  network_interface {
    network_name = libvirt_network.network_interface[count.index].name
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
  }

  # Ensure the instance starts automatically
  autostart = true
}