## Module: `user_sandboxes` (User-Based Managed Sandboxes)

This Terraform module provisions individual managed schemas and volumes for a set of users within a single Unity Catalog catalog. User identities are provided via a CSV, and each user gets an isolated sandbox schema within the shared catalog on managed S3 storage.

### Module Inputs

- **`user_catalog_name`**: (string, optional, default: `"user_sandboxes"`)  
  Name for the managed catalog containing user schemas.

- **`users_csv_path`**: (string, optional, default: `"./users.csv"`)  
  Path to a CSV file with a required `email` column, listing user emails.

- **`user_s3_base_path`**: (string, required)  
  Base S3 path used as the storage root for the managed catalog.

- **`external_location_name`**: (string, required)  
  Name of an existing Unity Catalog external location granting access to the specified S3 path.

- **Other (via `terraform.tfvars`)**:  
  See `tf/terraform.tfvars` for example inputs and authentication variables.

### Resources Created

- **One managed Unity Catalog catalog** for all users (with managed storage at `user_s3_base_path`)
- **Workspace binding** to make the catalog visible in the target Databricks workspace
- **Per user** (from CSV):
  - **Managed Schema**: `{catalog_name}.{sanitized_username}` (email username part, periods replaced with underscores)
  - **Managed Volume**: `{catalog_name}.{sanitized_username}.my_volume`
  - **Schema Privileges**: Grants `ALL PRIVILEGES` to the user on their schema
  - **Catalog Privileges**: Grants `USE_CATALOG` to the user

### Users CSV Format

The users CSV must contain at least the following column:

```csv
email
user1@example.com
user2@example.com
```

### Features

- **Fully managed storage:** All data is managed by Unity Catalog within the provided S3 base path.
- **Per-user isolation:** Each user's schema and volume are accessible only to them.
- **Easy updates:** Add/remove users by editing the CSV, then run `terraform apply`.
- **Automatic volume provisioning:** Each schema includes a `my_volume` volume for files.

### Implementation Notes

- **User requirements:** Users must exist in Databricks (at the account level) for privilege assignments to succeed.
- **Username sanitization:** Email usernames are transformed (periods replaced with underscores) to conform to Unity Catalog naming rules.
- **Catalog management:** The main catalog storage is controlled via the `user_s3_base_path` and secured with an external location.

For a working example, see [`tf/terraform.tfvars`](./tf/terraform.tfvars).

