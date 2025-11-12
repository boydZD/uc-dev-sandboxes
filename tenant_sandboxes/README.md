## Module: `tenant_sandboxes` (Tenant-Based Sandboxes)

This Terraform module provisions isolated Unity Catalog sandboxes on a per-tenant basis in Databricks, with each tenant defined in a configurable map. Each tenant receives its own managed catalog, external location, and catalog admin privileges.

### Module Inputs

- **`workspace_url`**: (string, required)  
  Databricks Workspace URL. All resources will be scoped to this workspace.

- **`workspace_id`**: (string, required)  
  Databricks Workspace ID. All catalogs and bindings are attached to this workspace.

- **`client_id`**: (string, required, sensitive)  
  Client ID for the service principal used to deploy resources.

- **`client_secret`**: (string, required, sensitive)  
  Client secret for the deployment service principal.

- **`s3_sandbox_base_path`**: (string, required)  
  Base S3 path for sandbox external locations (e.g., `s3://my-bucket/sandboxes/`).

- **`storage_credential_id`**: (string, required)  
  Storage credential to associate with the external locations.

- **`tenant_map`**: (map of objects, required)  
  Mapping of tenant names to objects containing required keys (currently supports `catalog_admin`).  
  Example:
  ```hcl
  tenant_map = {
    "demo-tenant1" = { catalog_admin = "irs-sa" },
    "demo-tenant2" = { catalog_admin = "irs-sa2" }
  }
  ```

### Resources Created per Tenant
- **External Location**: An isolated Unity Catalog external location for each tenant using their subpath within the base S3 path.
- **Sandbox Catalog**: A dedicated Unity Catalog catalog for each tenant, pointing to the external location.
- **Workspace Catalog Binding**: Binds each tenant's catalog to the specified Databricks workspace.
- **Permission Grants**:  
  - Grants `ALL PRIVILEGES` on the tenant's catalog to the defined `catalog_admin`.
  - Grants `READ FILES` and `WRITE FILES` on the external location to the `catalog_admin`.

### Implementation Notes
- The `s3_sandbox_base_path` *must not* be a child of any existing external location to avoid Databricks restrictions.
- Make sure the service principal and storage credentials provided have sufficient permissions for external location and catalog creation.
- Modify the `tenant_map` variable to add or remove tenant sandboxes as needed.

For detailed examples, refer to the [tf/terraform.tfvars](./tf/terraform.tfvars) file.
