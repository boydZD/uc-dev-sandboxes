# Unity Catalog - Development Sandboxes

This repository contains two modules for creating Unity Catalog sandbox environments:

1. **`sandbox_catalog`** - Tenant-based external sandboxes (original module)
2. **`user_schemas`** - User-based managed sandboxes (new module)

---

## Module 1: `sandbox_catalog` (Tenant-Based Sandboxes)

### Module Inputs
- `workspace_url`: Target Workspace URL (string, required); All catalogs created with this module will be isolated to this workspace.
- `workspace_id`: Target Workspace ID (string, required); All catalogs created with this module will be isolated to this workspace.
- `client_id`: Service Principal Client ID for the deployment Service Principal (string, required, sensitive)
- `client_secret`: Service Principal Client Secret for the deployment Service Principal (string, optional, sensitive)
- `s3_sandbox_base_path`: Base path for the sandbox external locations (string, optional, default: `s3://<my-bucket>/sandboxes/`)
- `storage_credential_id`: Storage Credential ID to be used for the sandbox external location (string, required)
- `tenant_map`: Map of tenant names to tenant details, including catalog admins (map of objects, optional, defaults provided)

### Resources Created (per Tenant)
- A Databricks Unity Catalog external location for each tenant sandbox.
- A Databricks Unity Catalog sandbox catalog for each tenant.
- A workspace catalog binding for each tenant sandbox catalog.
- Permissions granted to each tenant's `catalog_admin`:
    - [ALL_PRIVILEGES] on the sandbox catalog.
    - [READ_FILES, WRITE_FILES] on the sandbox external location.

### Notes
- The `s3_sandbox_base_path` cannot be a child path of any existing external location.

---

## Module 2: `user_schemas` (User-Based Managed Sandboxes)

### Module Inputs
- `user_catalog_name`: Name of the managed user sandbox catalog (string, optional, default: `"user_sandboxes"`)
- `users_csv_path`: Path to CSV file containing user emails (string, optional, default: `"./users.csv"`)
- `user_s3_base_path`: Base S3 path for the managed catalog storage location (string, required)
- `external_location_name`: Name of existing external location covering the S3 base path (string, required)

### Resources Created
- One managed Unity Catalog catalog for all users
- Workspace binding for the catalog
- Per user:
  - Managed schema: `{catalog_name}.{username}`
  - Managed volume: `{catalog_name}.{username}.my_volume`
  - Schema grants: ALL_PRIVILEGES
  - Catalog grants: USE_CATALOG

### Users CSV Format
The `users.csv` file should contain an `email` column:
```csv
email
user1@example.com
user2@example.com
```

### Features
- **Fully managed storage**: Unity Catalog manages data lifecycle
- **Per-user isolation**: Each user gets their own schema and volume
- **Repeatable**: Add new users to CSV and run `terraform apply`
- **Automatic volume creation**: Each user gets a `my_volume` for file storage

### Notes
- Users must exist at the account level for grants to work
- Usernames are sanitized (dots replaced with underscores)
- Storage is managed at the catalog level with specified S3 path
