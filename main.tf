# 
# 

# read only data source - read an existing catalog 
# catalog "my-GoldenEye-offerings" in prod under keith biegert account
data "ibm_cm_catalog" "cm_catalog" {
    catalog_identifier = "b92d6984-f42a-4ba8-bf3a-2bcdb132538c"
}

# this will create a catalog with the given name and description
# resource "ibm_cm_catalog" "cm_catalog" {
#   label = "kb-test-catalog"
#   short_description = "created via terraform"
# }

# read the catalog data source and retrieve the catalog id for use here.
# offering "custom-apache" in catalog "my-GoldenEye-offerings"
data "ibm_cm_offering" "cm_offering1" {
    catalog_id = data.ibm_cm_catalog.cm_catalog.id
    offering_id = "9f98f576-d9fa-4dfc-8467-1042024ecd38"
}

# read the catalog data source and retrieve the catalog id for use here.
# offering "terraform-sample-1.1.0" in catalog "my-GoldenEye-offerings"
data "ibm_cm_offering" "cm_offering2" {
    catalog_id = data.ibm_cm_catalog.cm_catalog.id
    offering_id = "be7eb954-bba3-4fe8-9eb6-ab09743adcd9"
}

# this will create an offering with the given name in the given catalog
# resource "ibm_cm_offering" "cm_offering" {
#   catalog_id = "b92d6984-f42a-4ba8-bf3a-2bcdb132538c"
#   label = "test offering"
#   long_description = "this is a long description of this offering"
# }

# version 0.0.24 of offering "custom-apache" in catalog "my-GoldenEye-offerings"
data "ibm_cm_version" "cm_version1" {
    version_loc_id = "b92d6984-f42a-4ba8-bf3a-2bcdb132538c.1c1186a9-ec67-44d8-abbc-9a545a265751"
}

# version 1.1.0 of offering "terraform-sample-1.1.0" in catalog "my-GoldenEye-offerings"
data "ibm_cm_version" "cm_version2" {
    version_loc_id = "b92d6984-f42a-4ba8-bf3a-2bcdb132538c.60b9e398-a208-4021-8a1e-d85a168c9db7"
}
#data "ibm_iam_auth_token" "tokendata" {}

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