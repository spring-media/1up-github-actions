spring-media/1up-github-actions@build-ecs-nodejs

Composite GitHub Action used as a shared build by 1up-team for Nodejs projects deployed to AWS ECS
### Steps Summary
- setup
- docker build and push
- STG Deploy
- on master 
  - deploy Docker image 
  - AWS ECS release 
  - terraform changes are applied (if any)
  - status report
