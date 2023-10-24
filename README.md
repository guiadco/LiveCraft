[![Go Reference](https://pkg.go.dev/badge/github.com/guiadco/LiveCraft.svg)](https://pkg.go.dev/github.com/guiadco/LiveCraft)

# LiveCraft

When talking about infrastructure, a "live environment" (also known as a "production environment") refers to the actual infrastructure that supports and runs the live applications or services that end-users or customers access and use.

LiveCraft is a CLI tool for creating live environments.

Actually, Livecraft only support bash script with one arguments like:


```
livecraft infra/tf.sh plan
```

## Compatibility

Livecraft could help generated live environments with:

- `Terraform`
- `OpenTofu`
- `Bash`

## Avaliable variables:

| name | description | example |
| --- | --- | --- |
| STAGE | this variables is the stage ID `(string)`| `prod` |
|CURRENT_BRANCH| the current git branch | main |
|TAG| autogenerated tags  | prod-39e58ad258288cc8a0013fac8a80552ac511c619 |


## How to use the bash version (to be deprecated)

- Clone this repository
- Add your own Terraform or OpenTofu code to infra/terraform
- Add your default variables to infra/terraform/variables.tf
- Add your your live environment variables to infra/ci-vars.tfvars.json.tpl

```
make infra.init
make infra.plan
make infra.apply
make infra.destroy
```
