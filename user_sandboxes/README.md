## Module: `user_sandboxes` (User-Based Managed Sandboxes)

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
