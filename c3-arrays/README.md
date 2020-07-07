# Terraform Variables Part II

## Arrays

Arrays are a supported variable in terraform. One good place to use an array is when you want to create mostly identical resources at once.

More information about variables can be found at https://www.terraform.io/docs/configuration/variables.html

Before you begin, run `terraform init` in this folder.

### Using an array

An array is pretty easy to define. Here we have a list of IP addresses that will be used for dns.

    variable "arecords" {
        type    = list(string)
        default = [
            "192.168.0.1",
            "192.168.0.2",
            "192.168.0.3",
        ]
    }

You can see in the plan that the IP addresses are used for a single a record.

    ❯ terraform plan

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # dns_a_record_set.www will be created
    + resource "dns_a_record_set" "www" {
        + addresses = [
            + "192.168.0.1",
            + "192.168.0.2",
            + "192.168.0.3",
          ]
        + id        = (known after apply)
        + name      = "www"
        + ttl       = 300
        + zone      = "example.com."
        }

    Plan: 1 to add, 0 to change, 0 to destroy.

### Multiple resources based on arrays

At some point you will want to make many resources based on items in an array. In this example, we are going to create many hostnames based on a list of ip addresses.

What we want to happen is something like this. The code below is NOT valid for terraform. It is just an example of what we want to do.

    for (i = 0; i < 3; i++) {
        resource "dns_a_record_set" "www-multi" {
            name = vars.arecords[i]
        }
    }

This is what it really looks like in terraform. `count` says how many of the things there will be, and you access each value in the array with `var.arecords[count.index]`

    resource "dns_a_record_set" "www-multi" {
        count = length(var.arecords)
        zone = "example.com."
        name = "web-0${count.index}"
        addresses = [var.arecords[count.index]]
    }

If you uncomment the last block in `main.tf` and run `terraform plan`, you will see new A records. One for each array item.

    # dns_a_record_set.www-multi[0] will be created
    + resource "dns_a_record_set" "www-multi" {
        + addresses = [
            + "192.168.0.1",
            ]
        + id        = (known after apply)
        + name      = "web-00"
        + ttl       = 300
        + zone      = "example.com."
        }

    # dns_a_record_set.www-multi[1] will be created
    + resource "dns_a_record_set" "www-multi" {
        + addresses = [
            + "192.168.0.2",
            ]
        + id        = (known after apply)
        + name      = "web-01"
        + ttl       = 300
        + zone      = "example.com."
        }

    # dns_a_record_set.www-multi[2] will be created
    + resource "dns_a_record_set" "www-multi" {
        + addresses = [
            + "192.168.0.3",
            ]
        + id        = (known after apply)
        + name      = "web-02"
        + ttl       = 300
        + zone      = "example.com."
        }

    Plan: 4 to add, 0 to change, 0 to destroy.
