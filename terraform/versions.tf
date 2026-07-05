terraform {
  # Don't run this config with a Terraform older than 1.6 — guards against
  # someone using an incompatible CLI and getting confusing errors.
  required_version = ">= 1.6"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread" # where to download it from (the registry)
      version = "~> 2.50"           # allow 2.50 up to <3.0 (patch/minor, no major jumps)
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    # azurerm / azapi are intentionally omitted until Phase 2/3.
    # Declaring a provider you haven't configured can trigger auth errors,
    # and azuread needs no Azure subscription — keep Step 1 dependency-free.
  }
}