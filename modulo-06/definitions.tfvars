# Definitions that may contains any sensitive data, such as passwords,
# private keys, and other secrets, must be declared in other .tfvars
# file named secrets.tfvars or secrets.tfvars.json
#
# These should not be part of version control as they are data points
# which are potentially sensitive and subject to change depending on
# the environment.

locals {
    provider = "aws"
}