# Terraform Libvirt Module

This Terraform module uses the `libvirt` provider to create virtual machines (VMs), manage disks, and network interfaces. It also manages storage pools for the VMs. The module is designed to be flexible, allowing you to create one or more VM instances, attach multiple disks and network interfaces, and manage your storage pools.

## Features

- Create one or multiple VM instances
- Attach one or more disks to each instance
- Attach one or more network interfaces to each instance
- Manage storage pools of type `dir`

## Requirements

- **Terraform v1.0.0 or above**
- `libvirt`zprovider
- A running instance of `libvirtd`

## Usage

Here’s how you can use the module to create VM instances, attach disks, and set up network interfaces.

### Example 1: Basic Usage with Terragrunt

```hcl
# terragrunt.hcl
terraform {
  source = "../libvirt-vm"
}

inputs = {
  instance_name       = "Debian"
  instance_count      = 2
  memory              = 2048
  vcpu                = 2
  disks               = [
    { source = "/var/lib/libvirt/images/debian-12.7.0-amd64-netinst.iso" },
    { size = 10737418240 }
    ]
  storage_pool_name   = "default"
  storage_pool_path   = "/var/lib/libvirt/images"
  network_interfaces  = [{ name = "k8snet" }]
}
```
### Inputs

| Name                 | Description                       | Type   | Default                    | Required |
|----------------------|-----------------------------------|--------|----------------------------|----------|
| `instance_name`      | Base name for the VM instance(s)  | string | `"example-vm"`             | Yes      |
| `instance_count`     | Number of VM instances to create  | number | `1`                        | No       |
| `memory`             | Amount of memory for the VM in MB | number | `1024`                     | No       |
|  `vcpu`              | Number of virtual CPUs for the VM | number | `1`                        | No       |
|  `disks`             | List of disks to attach to the VM |  list  | `[{ size = 10 }]`          | No       |
|                      |   (size in GB)                    |        |                            |          |
|`storage_pool_name`   | Name of the storage pool where    | string |  `default`                 |  No      |
|                      |  the disks will be created        |        |                            |          |
|`storage_pool_path`   | Path to the directory used for    |string  |`"/var/lib/libvirt/images"` |          |
|                      | the storage pool                  |        |                            |          |
| `network_interfaces` | List of network interfaces to     | list   | `[{ name = "k8snet" }]`   | No       |
|                      |  attach to the VM                 |        |                            |          |

### Outputs
|Name	        | Description                      |
|---------------|----------------------------------|
|instance_names	| List of VM instance names        |
|instance_ips	| List of IP addresses for the VMs |
