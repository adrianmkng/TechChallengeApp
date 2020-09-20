# Deployment instructions for TechChallenge app

This folder contains the code for deploying the techchallenge app to AWS.

## Prerequisites

- AWS
- terraform (tested with 12.29)

## Usage

Deployment is run from the environment folder.

```
cd environment
terraform init
terraform apply
```

:warning: Defaults have been configured for above usage.


## Deployment configuration

| Variable    | Description |
| ----------- | ----------- |
| name        | the name of the deployment e.g. "dev" |
| vpc_cidr    | CIDR block for the network e.g. "10.0.0.0/8" |
| app_version | The version of techchallenge app to deploy see [releases](https://github.com/servian/TechChallengeApp/releases) |
| db_name     | name for the database in Postgres |
| db_username | Postgres DB username |
| db_password | Postgres DB password |

Example usage:
```
terraform apply -var="name=test" -var="vpc_cidr=172.17.0.0/16" -var="app_version=v.0.7.0"
```

