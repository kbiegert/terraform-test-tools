data "ibm_iam_auth_token" "tokendata" {}

data "ibm_cm_version" "cm_version" {
    version_loc_id = "b92d6984-f42a-4ba8-bf3a-2bcdb132538c.1c1186a9-ec67-44d8-abbc-9a545a265751"
}

# resource "ibm_cm_validation" "my_cm_version_validation" {
#   version_locator = ibm_cm_version.my_cm_version_tf.version_locator
#   x_auth_refresh_token = data.ibm_iam_auth_token.tokendata.iam_refresh_token
#   revalidate_if_validated = false
#   override_values = {
#     subnet_zone = "us-south-1"
#     vpc_id = "r134-476cbb67-a6c2-4957-9806-3fcbac3498be"
#   }
#   mark_version_consumable = true
# }