# AWS ECS Gradle Build Steps
> spring-media/1up-github-actions@build-ecs-gradle

Composite GitHub Action used as a shared build by 1up-team for
Java/Gradle projects deployed to AWS ECS

### Steps Summary
- setup
- Gradle build
- Docker build
- Sonar analysis when `sonar-token` is passed
- on master
    - deploy Docker image
    - AWS ECS release
    - status report
