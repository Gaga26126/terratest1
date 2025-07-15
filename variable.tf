# Define variables
variable "SNOWFLAKE_ACCOUNT" { 
  description = "Snowflake Account"
  type = string
}

variable "SNOWFLAKE_SNOWSQL_ACCOUNT" {
  default = "DY13756"
}

variable "SNOWFLAKE_PASSWORD" {}
variable "SNOWFLAKE_ROLE" {}
variable "SNOWFLAKE_WAREHOUSE" {}
variable "SNOWFLAKE_ORG" {
  description = "Snowflake Org"
  type        = string
}

variable "SNOWFLAKE_USER" {
 description = "Snowflake Username"
  type        = string
}

variable "SNOWFLAKE_DATABASE" { default = "DEMO_DB" }
variable "SNOWFLAKE_SCHEMA"   { default = "DEMO_SCHEMA"}
variable "wi_table_name" { default = "temp_wi"}
variable "br_table_name" { default = "temp_br"}
variable "new_id" { default = "id4"}