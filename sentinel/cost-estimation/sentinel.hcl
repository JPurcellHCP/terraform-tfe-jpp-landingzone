policy "less-than-5-month" {
  source = "../policies/less-than-5-month.sentinel"
  enforcement_level = "advisory"
}

policy "less-than-10-month" {
  source = "../policies/less-than-10-month.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "less-than-20-month" {
  source = "../policies/less-than-20-month.sentinel"
  enforcement_level = "hard-mandatory"
}