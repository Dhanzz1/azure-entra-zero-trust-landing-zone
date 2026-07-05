# Empty block = "use default authentication."
# The azuread provider automatically reuses your `az login` session,
# so there are no secrets in your code. (For CI you'd switch to a
# service principal — note that as a future ADR.)
provider "azuread" {}