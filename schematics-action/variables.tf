
# the OS image to install on the VSI
variable "image" {
  default = "ibm-ubuntu-20-04-4-minimal-amd64-2"
}

# API key with sufficient permissions to deploy resources 
variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

# configure the terraform provider and direct it to the same region where the 
# custom secure infrastructure resources were deployed.
variable "region" {
  type    = string
  default = "us-east"
}

variable "prerequisite_workspace_id" {
  description = "IBM Cloud Schematics workspace ID of an existing custom-deployable-arch."
  type        = string
}

variable "ssh_private_key" {
  description = "Private SSH key (RSA format) that is paired with the public ssh key.  Will be used by Ansible to access the VSI. Entered data must be in [heredoc strings format](https://www.terraform.io/language/expressions/strings#heredoc-strings). The key is not uploaded or stored. For more information about SSH keys, see [SSH keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys)."
  type        = string
  sensitive   = true
}