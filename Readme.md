# How To

## Build the infra first:

This assumes you have Terraform installed, and the `az` CLI tool for Azure, logged in.

If you are planning to use the default backend/variables, you'll also need access to the Corndel DevOps Azure tenant.

From the `infra` directory:
* Init terraform with `terraform init -backend-config backend`
* Run `terraform plan`
* If you're happy with the results, `terraform apply`