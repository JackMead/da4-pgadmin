# Infra set up

Note that this only covers the set up of PG Admin. An appropriate Postgres DB can be set up through Azure or any other cloud provider, and learners can be provided the necessary access details.

These can be set up using the Terraform scripts or manually through Azure

**In practice, I expect the infra to be set up manually.**

## Manual Set Up

Instructions as of December 2023 can be read below.

- Set up a Resource Group hold the relevant things
- Then we need a "Storage Account" first, to handle file persistence*
  - "Uk South" presumably for location
  - "Standard" performance will be fine
  - I doubt you need more than Zone-Redundant storage, (even Local Redundancy claims 99.999999999% barring flood/fire/war in the datacenter - source)
  - Other settings should be obvious (e.g. pick a name) or left at defaults
- Once that's created, go into the storage account and add a File Share:
  - I suspect Hot tier should be sufficient
  - Up to you what backup policy you want - the main thing you could lose is the users created in PGAdmin and it strikes me that re-creating those is probably less effort than managing & restoring backups, but that may be being sceptical!
- Then we can set up the App Service:
- Search "Web App" in the Create interface - the subtext should refer to "App Service Web Apps"
  - Publish: Docker Container
  - Operating System: Linux
  - Region: UK South
  - Pricing plan: create a new App Service Plan
  - Explore Pricing Plans - we've never bothered with more than a B1 for the services we host for learners, but scale as you choose (I'd be surprised if you need to look beyond the B series, and I'd probably start with B1 and load test but feel free to buffer as you prefer)
  - Leave "Database" empty
  - Under "Docker":
    - Single Container
    - DockerHub
    - Image tag: dpage/pgadmin4:latest
  - Everything else leave as needed, and create
- Then there are a handful of things to configure in the App service once it's created:
  - Under "Configuration"-> "Application Settings" you can add app settings for:
    - PGADMIN_DEFAULT_EMAIL = whatever admin address you want to use for PG Admin
    - PGADMIN_DEFAULT_PASSWORD = what it says
    - PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION = False (to do with proxying the service behind Azure's DNS, per PGAdmin's advice)
    - Don't forget to hit the Save button at the top - sounds stupid but the interface doesn't make it obvious!
    - Under "Configuration" -> "Path Mappings", add a storage mount at /var/lib/pgadmin for our created file share

*From testing, this should cover PG Admin users, connections, and saved queries, but if there's anything else you need to persist between service restarts it would be worth explicitly testing!

## Automated

As an alternative, it should be equivalent to setting it up through Terraform as below.

This assumes you have Terraform installed, and the `az` CLI tool for Azure, logged in.

Set the backend appropriately; if you are planning to use the default backend/variables included, then you'll be creating within the Corndel **DevOps** Azure tenant, so you'll need access.

From the `infra` directory:
* Init terraform with `terraform init -backend-config backend`
* Copy the `terraform.tfvars.template` file and rename it `terraform.tfvars`, and set the variables as you want
* Run `terraform plan`
* If you're happy with the results, `terraform apply`