data "aws_security_group" "eks_lb_sg" {
  filter {
    name   = "tag:kubernetes.io/cluster/${module.eks.cluster_name}"
    values = ["owned"]
  }

  filter {
    name   = "tag:elbv2.k8s.aws/cluster"
    values = [module.eks.cluster_name]
  }

  depends_on = [module.eks]
}

resource "aws_security_group_rule" "allow_port_8080_to_lb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.eks_lb_sg.id
}
