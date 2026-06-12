# Slack Notifications

> spring-media/1up-github-actions@send-notifications

Composite GitHub Action used in builds to send out success/error messages

### Test Step: 'Setup - GitHub Message Env Vars'

```shell
export GITHUB_ENV="GITHUB_ENV.test.ipr"
rm -rf $GITHUB_ENV

export GITHUB_REPOSITORY="spring-media/1up-repo"
export GITHUB_RUN_ID='000000000'
export inputs_service_name='test-name'
export inputs_success-prefix=':rocket:'
export inputs_success_message=
export inputs_failure_message=

echo "With defaults:" >> $GITHUB_ENV
./setup.env.step.test.sh 
echo "" >> $GITHUB_ENV

echo "With inputs:" >> $GITHUB_ENV
export inputs_success_message='Stuff was done.'
export inputs_success_prefix='Nice!'
export inputs_failure_message='Stuff imploded!'
./setup.env.step.test.sh
cat $GITHUB_ENV
```
