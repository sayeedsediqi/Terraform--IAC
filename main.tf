provider "vsphere" {
  user           = " "
  password       = " "
  vsphere_server = "10.XX.XX.X:443"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "DC1"
}

data "vsphere_datastore" "datastore" {
  name          = "dc1-Prod-DDD"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


resource "vsphere_virtual_machine" "vm" {
  name             = "windows-test"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 1024
  guest_id = "Windows_2019_DC_x64_2020-12"

  ignored_guest_ips = []


  disk {
    label = "disk0"
    size = 20
  }

  cdrom {
    datastore_id = "${data.vsphere_datastore.datastore.id}"
    path         = "ubuntu-16.04.6-server-amd64.iso"

  }
}

/*
resource "vsphere_virtual_machine" "vm-clone" {
  name             = "ubuntu-clone-test"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 1024
  guest_id = "ubuntu64Guest"


  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
  }

  disk {
    label            = "disk0"
    size             = "20"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.tempate_from_ovf.id}"

    customize {
      linux_options {
        host_name = "terraform-test"
        domain    = "test.internal"
      }

      network_interface {
        ipv4_address = "10.0.0.10"
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.0.0.1"
    }
  }
}*/

