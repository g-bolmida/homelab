data "teleport_user" "teleport-admin" {
  version = "v2"
  metadata = {
    name = "teleport-admin"
  }
}

resource "teleport_role" "terraform_ci" {
  version = "v8"
  metadata = {
    name        = "terraform-ci"
    description = "Least-privilege role for the Terraform provider running in CI"
  }
  spec = {
    allow = {
      rules = [
        {
          resources = ["role", "user", "token", "bot"]
          verbs     = ["list", "create", "read", "update", "delete"]
        }
      ]
    }
  }
}

resource "teleport_bot" "terraform_ci" {
  metadata = {
    name = "terraform-ci"
  }
  spec = {
    roles = [teleport_role.terraform_ci.metadata.name]
  }
}

resource "teleport_provision_token" "terraform_ci_github" {
  version = "v2"
  metadata = {
    name = "terraform-ci-github"
  }
  spec = {
    roles       = ["Bot"]
    join_method = "github"
    bot_name    = teleport_bot.terraform_ci.metadata.name
    github = {
      allow = [
        {
          repository = "gbolmida/homelab"
        }
      ]
    }
  }
}