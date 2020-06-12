# Terraform Variables and Outputs

## Variables

Variables are very useful in terraform. They can be used to configure almost anything, and support strings, number and boolean values. There are complex types like lists and tuples. Regex validation is supported.

More information about variables can be found at https://www.terraform.io/docs/configuration/variables.html

Before you begin, run `terraform init` in this folder.

> Auto approve is used in these examples. Do not use that often.

### Defining inputs manually

If no defaults are defined, you will be asked about this variable when planning or applying.

    ❯ terraform apply
    var.length
    How many words should be in the password?

    Enter a value: 3

    random_pet.password: Creating...
    random_pet.password: Creation complete after 0s [id=specially-premium-toad]

    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

    Outputs:

    password = specially-premium-toad


### Defining via cli

You can specify variables at runtime. The `delimiter` is new here. That has a default defined so we were not asked about it earlier.

    ❯ terraform apply -auto-approve --var=delimiter="|" --var=length=3
    random_pet.password: Refreshing state... [id=hideously|immense|terrier]

    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

    Outputs:

    password = hideously|immense|terrier

### terraform.tfvars

This is the best way to handle variables, in my opinion, when working as an engineer on a terraform project. Using variables in the commandline will become problematic fast. Since our code here is stored in git, we don't want to store api keys or other credentials in the repo. The project should have variables for its api keys, engineers will use their own dev accounts while production deploys can use the right creds.

Open `terraform.tfvars`, uncomment the length and delimiter lines, then run terraform apply again


    ❯ terraform apply -auto-approve
    random_pet.password: Refreshing state... [id=hideously|immense|terrier]
    random_pet.password: Destroying... [id=hideously|immense|terrier]
    random_pet.password: Destruction complete after 0s
    random_pet.password: Creating...
    random_pet.password: Creation complete after 0s [id=relaxing.ghost]

    Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

    Outputs:

    password = relaxing.ghost

## Output

`terraform output` will show the value of any outputs that were defined. These values come from the state file meaning they are stored once at the time the state was applied. 

https://www.terraform.io/docs/configuration/outputs.html

    ❯ terraform output
    password = relaxing.ghost

JSON output is an option that might be useful if you need to use the value in a script.

    ❯ terraform output -json
    {
        "password": {
            "sensitive": false,
            "type": "string",
            "value": "relaxing.ghost"
        }
    }
