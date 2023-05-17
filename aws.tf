data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = "https://${var.host_name}"
  client_id_list  = ["aws.workload.identity"]
  thumbprint_list = ["${data.tls_certificate.tfc_certificate.certificates.0.sha1_fingerprint}"]
}

data "tls_certificate" "tfc_certificate" {
  url = "https://${var.host_name}"
}