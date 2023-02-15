
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