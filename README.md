# Migrating Credentials with Credential encoding updates
This script is to support migrations activities, for global credentials.
As per documentation: https://docs.cloudbees.com/docs/cloudbees-ci-migration/latest/splitting-controllers/modern-platforms#migrating-data

This script assumes the names of the controllers will remain the same.

# Configure
Configure [config](config) file with authentication credentials.
Configure [controllerPathList](controllerPathList) with a list of controllers (by URL path) to loop through. Ensure a new line at the end of the file.
E.g.
```
example-controller
demo-controller

```

# Run
Run `exportCredentialEncoding.sh` to output credentials into files.
Run `updateCredentialEncoding.sh` to update credential encoding in new instances.

Optionally pass parameters to the start script.

```
bash exportCredentialEncoding.sh <Operations Center Admin username> <Operations Center Admin API token> <[http(s)://domain] e.g. https://example.com>
bash updateCredentialEncoding.sh <Operations Center Admin username> <Operations Center Admin API token> <[http(s)://domain] e.g. https://example.com>
```
