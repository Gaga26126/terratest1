# locals {
#   shell_script = templatefile("${path.module}/templates/template.sh.tmpl", {
#     account_name = var.snowflake_account_name
#     username     = var.snowflake_username
#     password     = var.snowflake_password
#   })
# }

# resource "local_file" "init_script" {
#   filename = "${path.module}/scripts/setup.sh"

#   content = <<-EOT
#     #!/bin/bash
#     echo "Creating user directory..."
#     mkdir -p /home/new_user

#     echo "Inserting test data..."
#     snowsql -a ${var.snowflake_account_name} -u ${var.snowflake_username} -p ${var.snowflake_password} \\
#       -q "INSERT INTO ${var.database_name}.${var.schema_name}.USERS (ID, USERNAME) VALUES (3, 'terraform');"
#   EOT
# }

resource "null_resource" "append_id" {
  provisioner "local-exec" {
    command = <<EOT
      (Get-Content -Raw -Path "scripts\\variable.config") -replace '(")$', ",'${var.new_id}'`$1" | Set-Content -Path "scripts\\variable.config"
    EOT
    interpreter = ["PowerShell", "-Command"]
  }

  triggers = {
    always_run = timestamp()
  }
}

resource "snowflake_database" "demo_db_create" {
  name = var.SNOWFLAKE_DATABASE
}

resource "snowflake_schema" "demo_schema_create" {
  depends_on = [ snowflake_database.demo_db_create ]
  database = snowflake_database.demo_db_create.name
  name = var.SNOWFLAKE_SCHEMA
}

data "template_file" "wi_table_sql" {
  template = file("${path.module}/templates/create_wi_table.sql.tmpl")
  vars = {
    database     = var.SNOWFLAKE_DATABASE
    schema       = var.SNOWFLAKE_SCHEMA
    table_name   = var.wi_table_name
  }
}

resource "local_file" "create_wi_table_sql" {
  content  = data.template_file.wi_table_sql.rendered
  filename = "${path.module}/scripts/generated_wi_create.sql"
}

data "template_file" "br_table_sql" {
  template = file("${path.module}/templates/create_br_table.sql.tmpl")
  vars = {
    database     = var.SNOWFLAKE_DATABASE
    schema       = var.SNOWFLAKE_SCHEMA
    table_name   = var.br_table_name
  }
}

resource "local_file" "create_br_table_sql" {
  content  = data.template_file.br_table_sql.rendered
  filename = "${path.module}/scripts/generated_br_create.sql"
}

resource "null_resource" "run_sql_script" {
  depends_on = [snowflake_schema.demo_schema_create, local_file.create_wi_table_sql, local_file.create_br_table_sql]
  provisioner "local-exec" {
    environment = {
      SNOWSQL_PWD = var.SNOWFLAKE_PASSWORD
    }
    command = <<-EOT
      snowsql -a ${var.SNOWFLAKE_ACCOUNT} -u ${var.SNOWFLAKE_USER} -f ${local_file.create_wi_table_sql.filename}
      echo "${var.wi_table_name} created"
      snowsql -a ${var.SNOWFLAKE_ACCOUNT} -u ${var.SNOWFLAKE_USER} -f ${local_file.create_br_table_sql.filename} 
      echo "${var.br_table_name} created"
    EOT
    interpreter = ["PowerShell", "-Command"]
  }
  triggers = {
    always_run = timestamp()
  }
}