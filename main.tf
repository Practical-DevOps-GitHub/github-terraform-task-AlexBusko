terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = "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"
  owner = "Practical-DevOps-GitHub"
}

resource "github_repository" "task1" {
  name        = "github-terraform-task-AlexBusko"
  description = "Terraform managed repository"
  template {
    include_all_branches = false
    owner                = "Practical-DevOps-GitHub"
    repository           = "github-terraform-task"
  }
  has_downloads = true
  has_issues    = true
  has_projects  = true
  has_wiki      = true
}

resource "github_repository_file" "codeowners" {
  repository          = github_repository.task1.name
  branch              = "main"
  file                = ".github/CODEOWNERS"
  content             = "* @softservedata"
  commit_message      = "- added CODEOWNERS file"
  overwrite_on_create = true
}


resource "github_branch" "develop" {
  repository = github_repository.task1.name
  branch     = "develop"
}

resource "github_branch_default" "default" {
  repository = "github-terraform-task-AlexBusko"
  branch     = github_branch.develop.branch
}

resource "github_repository_collaborator" "collaborator" {
  repository = "github-terraform-task-AlexBusko"
  username   = "softservedata"
  permission = "admin"
}

resource "github_branch_protection" "main" {
  repository_id = github_repository.task1.name
  pattern       = "main"
  required_pull_request_reviews {
    require_code_owner_reviews      = true
    required_approving_review_count = 0
  }
}


resource "github_branch_protection" "develop" {
  repository_id = github_repository.task1.name
  pattern       = "develop"
  required_pull_request_reviews {
    required_approving_review_count = 2
  }
}

resource "github_repository_deploy_key" "deploy_key" {
  repository = github_repository.task1.name
  title      = "DEPLOY_KEY"
  key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDmkJ/GzdTeKsakS+uCIZBGejkvSeIlfIX1T2ADt/W33LB+mnl8qmvWheqebRf6AJCqFpv00agpYugZX7dJdcM8ltCEBzZ9TuMInoCIt5cwxghOWeYPjJsBxUygcPCbe/miqjpzrCOFqpDfcPL2Xxf3F48vXJMqQmpanbKfcpnr3QC0pEamLrvcF73ACjx1WWv8LhWoGpT5qKD1WZ4qnWNoLOOBqqstBzbHYjiOrh2R4XmCwnmfZ3gXUE2uBsfLzqigdPL7clumLt9quXrokjPUF9IHhcbJ4K/K6mnF8gfibEsorugafPDpJk6m7DOLCQsGYzVkewZnVAtnal/76HCmEvY7a/i8bjNCCdEGbUhGSlQQRFwat4lJT7jtNKkffZ5TL79s+NmYFhNrMugQYF3COMkO7nHfLqHMiGJ0l3ERhdaIbHqt0RZ8jXrSCMXKHTnZgVDQ1FxL7wUw2IZRfusS6slnSVUYAbWd2aba6Rjl6iFSPoBvM4FRtLtbCMyZr1E= alex@maraboo"
  read_only  = false
}

resource "github_actions_secret" "pat_secret" {
  repository      = github_repository.task1.name
  secret_name     = "PAT"
  plaintext_value = "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"
}
