# Terraform Deployment Steps
> spring-media/1up-github-actions@deploy-infrastructure

Composite GitHub Action used as a shared build by 1up-team for
AWS Terraform modules

### Steps Summary

- setup Terraform and Git
- validate, plan, apply on Staging (optional)
- validate, plan, apply on Production
- include Terraform plan
