output "catalog-info" {
    # value = data.ibm_cm_version.cm_version.version_loc_id
    value = data.ibm_cm_catalog.cm_catalog
}

output "offering-info1" {
    value = data.ibm_cm_offering.cm_offering1
}

output "offering-info2" {
    value = data.ibm_cm_offering.cm_offering2
}

output "version-info1" {
    value = data.ibm_cm_version.cm_version1
}
output "version-info2" {
    value = data.ibm_cm_version.cm_version2
}