# 1up-github-actions
Composite GitHub Actions used as shared builds by 1up-team


## Actions
> ℹ️ Each action is created on a separate branch, referenced using 
> `@` sign

> ⚠️ Composite action branches should be prefixed with `build-` in order to apply
> the branch protection rules


## Build Steps
> Contains all the steps required to build and release an ECS service

- [spring-media/1up-github-actions@build-ecs-gradle](https://github.com/spring-media/1up-github-actions/tree/build-ecs-gradle)

- [spring-media/1up-github-actions@build-nodejs-lambda](https://github.com/spring-media/1up-github-actions/tree/build-nodejs-lambda)

- [spring-media/1up-github-actions@build-ecs-nodejs](https://github.com/spring-media/1up-github-actions/tree/build-ecs-nodejs)


## Job Steps
> Contains the minimal steps required to support other Build Steps or workflows

- [spring-media/1up-github-actions@deploy-infrastructure](https://github.com/spring-media/1up-github-actions/tree/deploy-infrastructure)
