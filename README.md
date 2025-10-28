# Unity Catalog - Development Sandboxes

## Module Inputs
- `workspace_url`: Target Workspace URL (string, required); All created catalogs will be isolated to this workspace.
- `workspace_id`: Target Workspace ID (string, required); All created catalogs will be isolated to this workspace.
- `client_id`: Service Principal Client ID for the deployment Service Principal (string, required, sensitive)
- `client_secret`: Service Principal Client Secret for the deployment Service Principal (string, optional, sensitive)
- `s3_sandbox_base_path`: Base path for the sandbox external locations (string, optional, default: `s3://<my-bucket>/sandboxes/`)
- `storage_credential_id`: Storage Credential ID to be used for the sandbox external location (string, required)
- `tenant_map`: Map of tenant names to tenant details, including catalog admins (map of objects, optional, defaults provided)


## Resources Created (per Tenant)
- A Databricks Unity Catalog external location for each tenant sandbox.
- A Databricks Unity Catalog sandbox catalog for each tenant.
- A workspace catalog binding for each tenant sandbox catalog.
- Appropriate admin grants and external location permissions for tenant administrators (user or group).

## Notes
- The `s3_sandbox_base_path` cannot be a child path of any existing external location.
