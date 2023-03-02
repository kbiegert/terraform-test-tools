locals {

  vpc_type = "workload"

  location = regex("^[a-z/-]+", var.prerequisite_workspace_id)
}

data "ibm_schematics_workspace" "schematics_workspace" {
  workspace_id = var.prerequisite_workspace_id
  location     = local.location
}

data "ibm_schematics_output" "schematics_output" {
  workspace_id = var.prerequisite_workspace_id
  location     = local.location
  template_id  = data.ibm_schematics_workspace.schematics_workspace.runtime_data[0].id
}

locals {
  slz_output = jsondecode(data.ibm_schematics_output.schematics_output.output_json)
  prefix = local.slz_output[0].prefix.value
  subnet = join("-", ["${local.prefix}", local.vpc_type, "vsi-zone-1"])
}

data "ibm_is_subnet" "subnet" {
  name = local.subnet
}

data "ibm_is_ssh_key" "ssh-key" {
  name = "${local.prefix}-ssh-key"
}

data "ibm_is_image" "image" {
  name = var.image
}

data "ibm_is_floating_ip" "jump-box-fip" {
  name = "${local.prefix}-jump-box-1-fip"
}

module "slz_vsi" {
  source                     = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vsi.git?ref=v2.0.0"
  resource_group_id          = data.ibm_is_subnet.subnet.resource_group
  image_id                   = data.ibm_is_image.image.id
  create_security_group      = true
  security_group             = var.appSecurityRules
  tags                       = []
  subnets                    = [{"name": local.subnet, "id": data.ibm_is_subnet.subnet.id, "zone":data.ibm_is_subnet.subnet.zone, "cidr": data.ibm_is_subnet.subnet.ipv4_cidr_block}]
  vpc_id                     = data.ibm_is_subnet.subnet.vpc
  prefix                     = "${local.prefix}-apache-webserver"
  machine_type               = "cx2-2x4"
  user_data                  = var.workLoadInitScript
  boot_volume_encryption_key = null
  vsi_per_subnet             = 1
  ssh_key_ids                = [data.ibm_is_ssh_key.ssh-key.id]
}


resource "ibm_schematics_action" "schematics_action" {
  depends_on = [module.slz_vsi]

  name = "install-apache"
  description = "install apache server using ansible"
  location = local.location

  source {
    source_type = "git_hub"
      git {
        git_repo_url = ""
        git_repo_folder = ""
        git_token = ""
      }
  }

  bastion {
    host = data.ibm_is_floating_ip.jump-box-fip.address
  }

  bastion_credential {
    ssh_private_key = var.ssh_private_key
  }

  inventory = data.ibm_schematics_inventory.schematics_inventory.id
}

resource "ibm_schematics_inventory" "schematics_inventory" {
  inventories_ini = ""
}

resource "ibm_schematics_job" "schematics_job" {
  depends_on = [ibm_schematics_action.schematics_action]

  command_object = "action"
  command_object_id = data.ibm_schematics_action.schematics_action.id
  command_name = "ansible_playbook_run"
}

------------------------------
resource "null_resource" "execute_ansible" {
  depends_on = [module.slz_vsi]
    
  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = data.ibm_is_floating_ip.jump-box-fip.address
    host         = module.slz_vsi.list[0].ipv4_address
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "15m"
  }

  provisioner "file" {
    source      = "${path.module}/playbook/install-apache.yml"
    destination = "/root/install-apache.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 150",
      "ansible-playbook --connection=local -i 'localhost,' /root/install-apache.yml",
    ]
  }
}