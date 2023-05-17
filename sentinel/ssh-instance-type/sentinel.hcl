module "tfplan-functions" {
  source = "./modules/tfplan-functions/tfplan-functions.sentinel"
}

module "tfstate-functions" {
  source = "./modules/tfstate-functions/tfstate-functions.sentinel"
}

module "tfconfig-functions" {
  source = "./modules/tfconfig-functions/tfconfig-functions.sentinel"
}

module "tfrun-functions" {
  source = "../modules/tfrun-functions/tfrun-functions.sentinel"
}

module "aws-functions" {
  source = "../modules/aws-functions/aws-functions.sentinel"
}

policy "restrict-ec2-instance-type" {
  source = "../policies/restrict-ec2-instance-type.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "restrict-ingress-sg-rule-ssh" {
  source = "../policies/restrict-ingress-sg-rule-ssh.sentinel"
  enforcement_level = "soft-mandatory"
}