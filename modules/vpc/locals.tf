locals {
  vpc_cidr_block           = "10.0.0.0/16"
  private_zone1_cidr_block = "10.0.0.0/19"
  private_zone2_cidr_block = "10.0.32.0/19"
  public_zone1_cidr_block  = "10.0.64.0/19"
  public_zone2_cidr_block  = "10.0.96.0/19"
  vpc_name                 = "vpc-A"
}