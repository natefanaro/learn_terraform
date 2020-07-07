# Terraform Providers and Resources

**Note** _This chapter requires aws keys to function, and will create real resources that can incur charges from the provider. Be sure to follow the destruction step of this process if you apply changes here._

You will need to make a `terraform.tfvars` file with your AWS creds to run these examples.

    $ cat terraform.tfvars
    access_key = "0000000000000000"
    secret_key = "0000000000000000000000000000000000000000"

## Providers

A provider is responsible for understanding API interactions and exposing resources. These are usually connections to an IaaS or SaaS provider and leverage their public apis and tools to make calls to that service.

Most major cloud platforms have a terraform provider. This includes AWS, Azure, and Google Cloud. You can also find providers for services like Okta or Datadog. Some local providers exist too like Docker and Git.

It is worth getting familiar with terraform's list of providers and their documentation https://www.terraform.io/docs/providers/index.html

### Defining a provider

A provider may need certain credentials to work.

    provider "aws" {
        region     = "us-west-2"
        access_key = "my-access-key"
        secret_key = "my-secret-key"
    }

These can also be defined as variables. When possible, use variables and make sure that secrets are not committed to git. See `main.tf` for an example of this.

### Multiple Providers

It might be common for you to use many different providers in one file. For example: You create a web server in AWS and need to use that instance's ip address in CloudFlare. Or create monitoring for the instance in DataDog. 

You can also define multiple providers of the same type with aliasing. This is useful when you have different access policies for api keys. Or, in the case of AWS, you want to use a different region.

    provider "aws" {
        region     = "us-east-1"
        access_key = "my-access-key"
        secret_key = "my-secret-key"
        alias      = "backup"
    }

## Resources

Resources define what you want to manage in each provider. These are things like DNS records, security policies, IAM roles, RDS Instances, etc.

A resource is defined like this. We already had a few resources defined in the previous chapter on arrays.

    resource "aws_instance" "web01" {
        availability_zone = "us-west-2a"
        ami               = "ami-0e35a5f9e16acbf01"
        instance_type     = "t2.micro"
        tags = {
            env = "staging"
        }
    }

This is what will be managed by terraform. If you apply this, you can see the ec2 instance was created at this page https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#Instances:sort=instanceId

Apply this, update the tags, and apply again. You can see the tag will be changed. You can also see a lot of other values that can be updated.

    $ terraform apply

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    ~ update in-place

    Terraform will perform the following actions:

    # aws_instance.web01 will be updated in-place
    ~ resource "aws_instance" "web01" {
        ami                          = "ami-0bac6fc47ad07c5f5"
        arn                          = "arn:aws:ec2:us-west-2:448112123655:instance/i-0faee853bf133e052"
        associate_public_ip_address  = false
        availability_zone            = "us-west-2a"
        id                           = "i-0faee853bf133e052"
        instance_state               = "running"
        instance_type                = "t2.micro"
        ipv6_address_count           = 0
        ipv6_addresses               = []
        monitoring                   = false
        primary_network_interface_id = "eni-02c3683720ec2d255"
        private_dns                  = "ip-172-16-10-100.us-west-2.compute.internal"
        private_ip                   = "172.16.10.100"
        security_groups              = []
        source_dest_check            = true
        subnet_id                    = "subnet-01ef94f60bd9f72cf"
        ~ tags                         = {
            ~ "env" = "prod" -> "staging"
        }

Someone might think that changing this resource in the AWS console is a good idea. Terraform can see there is a difference between its own state, and what is live. I changed the `env` label from `prod` to `pre-prod` in the AWS console, and this is what happened when I ran `terraform apply` next.

      ~ tags                         = {
          ~ "env" = "pre-prod" -> "prod"
        }

Terraform wants to get this resource back in to the state that was defined.

### Resource Destruction

We haven't covered removing defined resources yet. You can remove or comment out each resource that has been defined. If you comment out the web01 resource form main.tf and apply again, it will remove that instance.

You can also run `terraform destroy` and it will remove everything that was defined. One thing to note, this is generally safe to do when unmanaged resources exist. Meaning that if you have other ec2 instances that the state file does not know about, it will not remove them.

Be sure to run `terraform destroy` now if the `apply` above worked.

    $ terraform destroy
    data.aws_ami.ubuntu: Refreshing state...
    aws_vpc.my_vpc: Refreshing state... [id=vpc-0e39452add355265a]
    aws_instance.web01: Refreshing state... [id=i-0faee853bf133e052]
    aws_subnet.my_subnet: Refreshing state... [id=subnet-01ef94f60bd9f72cf]
    aws_network_interface.foo: Refreshing state... [id=eni-02c3683720ec2d255]

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    - destroy

    Terraform will perform the following actions:

    # aws_instance.web01 will be destroyed
    - resource "aws_instance" "web01" {
        - ami                          = "ami-0bac6fc47ad07c5f5" -> null
        - arn                          = "arn:aws:ec2:us-west-2:448112123655:instance/i-0faee853bf133e052" -> null
        - associate_public_ip_address  = false -> null
        - availability_zone            = "us-west-2a" -> null
        - cpu_core_count               = 1 -> null
        - cpu_threads_per_core         = 1 -> null
        - disable_api_termination      = false -> null
        - ebs_optimized                = false -> null
        - get_password_data            = false -> null
        - hibernation                  = false -> null
        - id                           = "i-0faee853bf133e052" -> null
        - instance_state               = "running" -> null
        - instance_type                = "t2.micro" -> null

    ---cut---

    aws_instance.web01: Destroying... [id=i-0faee853bf133e052]
    aws_instance.web01: Still destroying... [id=i-0faee853bf133e052, 10s elapsed]
    aws_instance.web01: Still destroying... [id=i-0faee853bf133e052, 20s elapsed]
    aws_instance.web01: Still destroying... [id=i-0faee853bf133e052, 30s elapsed]
    aws_instance.web01: Destruction complete after 37s
    aws_network_interface.foo: Destroying... [id=eni-02c3683720ec2d255]
    aws_network_interface.foo: Destruction complete after 7s
    aws_subnet.my_subnet: Destroying... [id=subnet-01ef94f60bd9f72cf]
    aws_subnet.my_subnet: Destruction complete after 1s
    aws_vpc.my_vpc: Destroying... [id=vpc-0e39452add355265a]
    aws_vpc.my_vpc: Destruction complete after 0s

    Destroy complete! Resources: 4 destroyed.
