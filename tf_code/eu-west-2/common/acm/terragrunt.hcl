include {
  path = find_in_parent_folders()
}

locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

inputs = merge(
  local.region_vars.locals,
  local.environment_vars.locals,
{
  project_name = "diploma"
  environment = "development"
}
)
