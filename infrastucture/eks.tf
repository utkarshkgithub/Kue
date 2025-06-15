module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_group_defaults = {
    cluster_addons = {
      vpc-cni = { most_recent = true }
      kube-proxy = { most_recent = true }
      core-dns = { most_recent = true }
    }
    instance_types = ["t2.medium"]
    attach_cluster_primary_security_group = true

    # No additional_security_group_ids or custom tags here!
  }

  eks_managed_node_groups = {
    terra-eks-test = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.medium"]
      min_size       = 2
      max_size       = 3
      desired_size   = 2
      capacity_type  = "SPOT"
      # No additional_security_group_ids or custom tags here!
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
  
  depends_on = [module.vpc]
  
  
}