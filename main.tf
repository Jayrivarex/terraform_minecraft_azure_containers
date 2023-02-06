provider "aws" {
  profile = "default"
  region  = "us-west-2"
  version = "3.72.0"
  access_key = "AKIARVZE6MMNURDVGVVP"
  secret_key = "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"
 
}

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "JayRivaInc"

    workspaces {
      prefix = "jay_"
    }
  }
}

variable "environment" {
  type    = map
  default = {
    jay_dev  = "dev"
    jay_qa = "qa"
    jay_stage = "stage"
    jay_mds= "mds"
    jay_prod= "prod"
  }
}


resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}



resource "aws_resourcegroups_group" "grupoderecurso" {
  name     = "${var.environment[terraform.workspace]}-rg"
  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "Stage",
      "Values": ["Test"]
    }
  ]
}
JSON
  }
}

output "rcon_password" {
  value = random_password.password.result
  sensitive = true
}  
