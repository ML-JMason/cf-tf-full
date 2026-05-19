terraform {
  backend "azurerm" {}

  # To switch quickly to AWS in the future, replace the backend block above with:
  # backend "s3" {}
}
