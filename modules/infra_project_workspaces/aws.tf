resource "aws_iam_role" "tfc_role" {
  count = var.aws_creds == true ? 1 : 0
  name               = "${tfe_project.projects_demo.name}-workload-identity-role"
  assume_role_policy = data.aws_iam_policy_document.tfc_role_trust_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}

data "aws_iam_policy_document" "tfc_role_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.host_name}:aud"
      values   = ["aws.workload.identity"]
    }

    condition {
      test     = "StringLike"
      variable = "${var.host_name}:sub"
      values = [
        "organization:${var.organization_name}:project:${tfe_project.projects_demo.name}:workspace:*:run_phase:plan",
        "organization:${var.organization_name}:project:${tfe_project.projects_demo.name}:workspace:*:run_phase:apply",
      ]
    }
  }
}