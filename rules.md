# Terraform AWS Provider Best Practices — Summary

- Use Terraform on AWS in a way that improves consistency, security, reliability, compliance, and team productivity.
- Focus especially on:
    - security
    - remote backends
    - codebase structure
    - provider version management
    - community modules :contentReference[oaicite:0]{index=0}

## Security

- Follow **least privilege** everywhere.
- Prefer **IAM roles** over IAM users.
- Avoid long-lived access keys; use **temporary credentials** instead.
- For local runs, use **assume-role**.
- For EC2, use **instance profiles / IAM roles**.
- For CI/CD, prefer **OIDC** or other short-lived credential flows.
- If legacy tooling forces IAM users, keep permissions minimal and remove them when no longer needed.
- Continuously review and reduce unused permissions.
- Monitor and rotate access keys if you still have them.
- Secure Terraform state:
    - store it remotely
    - encrypt it
    - restrict access
    - limit direct manual access through controlled workflows
- Do not put secrets into Terraform state; use **AWS Secrets Manager**.
- Mark sensitive outputs as `sensitive`.
- Continuously scan infra and code for misconfigurations and exposed credentials.
- Enforce policy checks and governance guardrails. :contentReference[oaicite:1]{index=1}

## Backend / State

- Use **Amazon S3** as the remote backend for Terraform state on AWS.
- Use **S3 native state locking**.
- Prefer remote state over local files for:
    - team collaboration
    - safer concurrent changes
    - backup and recovery
    - better operational reliability
- Keep **separate backends per environment**.
- Actively **monitor remote state activity**. :contentReference[oaicite:2]{index=2}

## Codebase Structure

- Standardize repository structure across Terraform projects.
- Keep a clear root module with common files such as:
    - `main.tf`
    - `variables.tf`
    - `outputs.tf`
    - `locals.tf`
    - `data.tf`
    - `README.md`
    - `versions.tf`
- Add useful descriptions to all variables and outputs.
- Define variable types explicitly.
- Give defaults only when values are truly environment-independent.
- Do not over-parameterize modules.
- Use modules for **logical groups of resources**, not for single-resource wrappers.
- Prefer composable modules over deeply nested module trees.
- Use consistent naming conventions.
- Prefer dedicated **attachment resources** where applicable.
- Apply **default tags** to resources.
- Structure modules so they can meet **Terraform Registry** expectations even if you do not publish them yet.
- Follow consistent coding standards and automated formatting/style checks.

## Provider Version Management

- Pin provider versions.
- Add automated CI/CD checks to fail builds when provider versions are not properly constrained.
- Use **TFLint** and AWS provider rulesets.
- Monitor provider release notes and changelogs.
- Review release impact before upgrading.
- Test upgrades in **non-production** before production rollout.

## Community Modules

- Before building your own module, check whether a good community module already exists.
- Prefer modules that are:
    - popular
    - recently updated
    - actively maintained
- Customize through **input variables**, not by editing module internals.
- Avoid forking unless you plan to contribute fixes/features back.
- Review module dependencies before adoption:
    - required providers
    - nested modules
    - external data sources or plugins
- Use trusted sources and contribute improvements back when possible.