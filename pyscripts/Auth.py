def authenticate_and_retrieve_secrets():
    try:
        secrets = {
            'SNOWFLAKE_ACCOUNT': "TICOODW-DY13756",
            'SNOWFLAKE_SNOWSQL_ACCOUNT': "DY13756",
            'SNOWFLAKE_USER': "GAGAN261",
            'SNOWFLAKE_ORG': "ticoodw",
            'SNOWFLAKE_PASSWORD': "Gagandeep_261#",
            'SNOWFLAKE_ROLE': "ACCOUNTADMIN",
            'SNOWFLAKE_WAREHOUSE': "COMPUTE_WH",
            'SNOWFLAKE_DATABASE': "DEMO_DB",
            'SNOWFLAKE_SCHEMA': "DEMO_SCHEMA"}
        return secrets
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        exit(1)

if __name__ == '__main__':
    secrets = authenticate_and_retrieve_secrets()
    with open("terraform.tfvars", "w") as f:
        for key, value in secrets.items():
            value = value.replace('"', '\\"')  # escape double-quotes if needed
            f.write(f'{key} = "{value}"\n')