# 1up-github-actions
Composite GitHub Actions used as shared builds by 1up-team

## Actions
> ℹ️ Each action is created on a separate branch, referenced using 
> `@` sign

> ⚠️ Composite action branches should be prefixed with `build-` in order to apply
> the branch protection rules

### AWS ECS Gradle Build Steps
[spring-media/1up-github-actions@build-ecs-gradle](https://github.com/spring-media/1up-github-actions/tree/build-ecs-gradle)

### Nodejs AWS SAM Build Steps
[spring-media/1up-github-actions@build-nodejs-lambda](https://github.com/spring-media/1up-github-actions/tree/build-nodejs-lambda)

### AWS Terraform Deploy Steps
[spring-media/1up-github-actions@deploy-infrastructure](https://github.com/spring-media/1up-github-actions/tree/deploy-infrastructure)
