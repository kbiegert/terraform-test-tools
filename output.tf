output "version-info" {
    # value = data.ibm_cm_version.cm_version.version_loc_id
    value = data.ibm_cm_catalog.cm_catalog.created
}