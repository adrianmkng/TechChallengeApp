# Deployment instructions

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

The public endpoint for the techchallenge will be printed out at the end of the deployment.

:warning: The endpoint might not be immediately available as it takes time for the ELB to register active instances

Once the application as been started you will need to initialise the database for the first time. 
To do this you need to access one of the EC2 instances running the techchallenge application via SSM in the AWS console.

Once you are in the session on the EC2 instance you can run the following command:
```
/app/dist/TechChallengeApp updatedb -s
```

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

## Architecture

The network has been setup with a public and private tiers.

The public tier is for the Load Balancer.

The private tier is the EC2 instances that run the techchallenge as well at the postgres RDS.


