# AWS ECS Gradle Build Steps
> spring-media/1up-github-actions@build-ecs-gradle

Composite GitHub Action used as a shared build by 1up-team for
Java/Gradle projects deployed to AWS ECS

### Steps Summary
- setup
- Gradle build
- Docker build and Push
- Sonar analysis when `sonar-token` is passed
- STG deploy (if parameter passed)
- on master
    - deploy Docker image
    - AWS ECS release
    - terraform changes are applied (if any)
    - status report
