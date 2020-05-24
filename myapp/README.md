# Test Rails App

This app is based on this guide: https://docs.docker.com/compose/rails/

A simple Rails app was generated with the following command:

```
rails new myapp --database=postgresql --skip-git --skip-keeps --skip-action-mailer --skip-action-mailbox --skip-action-cable --skip-sprockets --skip-spring --skip-listen --skip-javascript --skip-turbolinks --skip-test --skip-system-test --skip-bootsnap --skip-webpack-install --skip-action-text --skip-active-storage --skip-puma
```

To check if application is build and running correctly, run:

```
docker build -t testrailsapp .
docker run -it --rm -p 3000:3000 testrailsapp
open http://localhost:3000
```

## Datadog Ruby client

- Added Datadog Ruby client gem `ddtrace` to Gemfile
- Created an initializer `config/initializers/datadog_tracer.rb`
