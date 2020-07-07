# Learning Terraform

This repo will help get set up with terraform and is meant to be something that you can play with locally. In production, deployment should involve builds on a CI/CD pipeline. That might not be covered here.

## Setup

Install terraform via brew

    brew install terraform

You can install brew easily. Visit https://brew.sh for more information

Now, try running `terraform -v`

    ❯ terraform -v
    Terraform v0.12.26

Good. Seems like it is installed. Be sure to go to this folder in your terminal and favorite editor.

## Project structure

Concepts are broken up in to chapters. Each include their own `README.md` to follow along with. In more advanced chapters, you may need to fill in certain api keys in `terraform.tfvars`

State and other files needed to run chapters are not included. When starting a new chapter, you will want to run `terraform init` in that folder.
