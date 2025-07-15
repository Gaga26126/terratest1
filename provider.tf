terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.76"
    }
  }
}

provider "snowflake" {
  account_name = var.SNOWFLAKE_SNOWSQL_ACCOUNT
  organization_name = var.SNOWFLAKE_ORG
  user = var.SNOWFLAKE_USER
  password = var.SNOWFLAKE_PASSWORD
}