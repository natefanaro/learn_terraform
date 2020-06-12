# Terraform Commands

Let's go over terraform and the commands you will be using.

There is a single provider in main.tf called random. More information about this provider can be found here https://www.terraform.io/docs/providers/random/index.html

This is a good provider to get used to terraform commands as there are no external dependencies. Random may be useful for generating things like passphrases or hostnames.

## terraform init

This will initialize a Terraform working directory. That is required when starting a new project or after adding a new resource to your project. This created a `.terraform` folder that contains plugins mentioned in our `*.tf` files.

    ❯ terraform init

    Initializing the backend...

    Initializing provider plugins...
    - Checking for available provider plugins...
    - Downloading plugin for provider "random" (hashicorp/random) 2.2.1...

    ❯ tree -a
    .
    ├── .terraform
    │   └── plugins
    │       └── darwin_amd64
    │           ├── lock.json
    │           └── terraform-provider-random_v2.2.1_x4
    └── main.tf


## terraform plan

`terraform plan` will perform a diff between the resource and what you have defined in all of the `*.tf` files in this folder.

    ❯ terraform plan

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # random_pet.password will be created
    + resource "random_pet" "password" {
        + id        = (known after apply)
        + length    = 5
        + separator = "-"
        }

    Plan: 1 to add, 0 to change, 0 to destroy.

    ------------------------------------------------------------------------

    Note: You didn't specify an "-out" parameter to save this plan, so Terraform
    can't guarantee that exactly these actions will be performed if
    "terraform apply" is subsequently run.

> The warning below is outside the scope of this guide but is something to note. What you plan here may go differently later on, as other changes are made to the system. Be mindful of this when working on large projects together.

## terraform apply

Performs a new plan and will ask to run the changes. In this case, a random pet name is generated and output. Output can be useful for debugging, or to use as variables for other scripts.

    ❯ terraform apply

    Terraform will perform the following actions:

    # random_pet.password will be created
    + resource "random_pet" "password" {
        + id        = (known after apply)
        + length    = 5
        + separator = "-"
        }

    Plan: 1 to add, 0 to change, 0 to destroy.

    Do you want to perform these actions?
    Terraform will perform the actions described above.

    Enter a value: yes

    random_pet.password: Creation complete after 0s 

    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

    Outputs:
    password = mistakenly-intensely-actually-mighty-grub

We have new `tfstate` files

    ❯ tree
    .
    ├── main.tf
    ├── terraform.tfstate
    └── terraform.tfstate.backup

If you run `terraform apply` right away you will see that the same output is given. The name was stored in the state file above.

> You can look at the `terraform.tfstate` file with your editor. Terraform maintains a record of the current state of the system to help with diffing your new changes. There are ways to share state files across teams that we can cover later.  You can also run `terraform show` to see this data.

It turns out that users aren't able to remember a five word password very well. Change the length in `main.if` from 5 to 2.

    ❯ git diff 
    diff --git a/c1-commands/main.tf b/c1-commands/main.tf
    index c21e7cf..1594e58 100644
    --- a/c1-commands/main.tf
    +++ b/c1-commands/main.tf
    @@ -1,5 +1,5 @@
    resource "random_pet" "password" {
        -  length = 5
        +  length = 2
    }

And run `terraform apply` again

    ❯ terraform apply

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    -/+ destroy and then create replacement

    Terraform will perform the following actions:

    # random_pet.password must be replaced
    -/+ resource "random_pet" "password" {
        ~ id        = "mistakenly-intensely-actually-mighty-grub" -> (known after apply)
        ~ length    = 5 -> 2 # forces replacement
            separator = "-"
        }

    Plan: 1 to add, 0 to change, 1 to destroy.

    Do you want to perform these actions?
    Only 'yes' will be accepted to approve.

    Enter a value: yes

    random_pet.password: Destroying... [id=mistakenly-intensely-actually-mighty-grub]
    random_pet.password: Destruction complete after 0s
    random_pet.password: Creating...
    random_pet.password: Creation complete after 0s [id=hot-halibut]

    Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

    Outputs:

    password = hot-halibut

We have a new password. Great! You can clearly see what was going to change and was able to approve it. 

## terraform destroy

If you want to remove everything that terraform made, use `terraform destroy`. This will remove any resource covered in the manifest. If your resource is a cloud provider like aws, and someone manually makes a new resource terraform doesn't know about, it will not remove it. Generally this will not be done in production. 

    ❯ terraform destroy
    random_pet.password: Refreshing state... [id=hot-halibut]

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    - destroy

    Terraform will perform the following actions:

    # random_pet.password will be destroyed
    - resource "random_pet" "password" {
        - id        = "hot-halibut" -> null
        - length    = 2 -> null
        - separator = "-" -> null
        }

    Plan: 0 to add, 0 to change, 1 to destroy.

    Do you really want to destroy all resources?
    Terraform will destroy all your managed infrastructure, as shown above.
    There is no undo. Only 'yes' will be accepted to confirm.

    Enter a value: yes

    random_pet.password: Destroying... [id=hot-halibut]
    random_pet.password: Destruction complete after 0s

    Destroy complete! Resources: 1 destroyed.

> Make sure that you destroy your resources if you are learning about cloud provider resources to avoid a surprise bill.

# Other Interesting Commands

See `terraform --help` for a full list

    graph              Create a visual graph of Terraform resources
    import             Import existing infrastructure into Terraform
    providers          Prints a tree of the providers used in the configuration
    show               Inspect Terraform state or plan
    validate           Validates the Terraform files
    state              Advanced state management

