
# AWS Provider Configuration:
provider "aws" {
  region = "eu-west-1"
}
# VPC Creation: Define your VPC where the EKS cluster and resources will reside.

resource "aws_vpc" "own_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "own-vpc"
  }
}
# Create Subnets: Create at least two subnets in different availability zones to spread the load across multiple zones.
resource "aws_subnet" "public_subnet_x" {
  vpc_id                  = aws_vpc.own_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "own-public-subnet-x"
    "kubernetes.io/cluster/own-cluster" = "shared"
  }
}

resource "aws_subnet" "public_subnet_y" {
  vpc_id                  = aws_vpc.own_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "own-public-subnet-y"
    "kubernetes.io/cluster/own-cluster" = "shared"
  }
}
# Create Internet Gateway and Route Tables: Attach an internet gateway for external access and create a route table to allow traffic to flow from your VPC to the outside world.

resource "aws_internet_gateway" "own_igw" {
  vpc_id = aws_vpc.own_vpc.id
  tags = {
    Name = "own-igw"
  }
}

resource "aws_route_table" "own_public_rt" {
  vpc_id = aws_vpc.own_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.own_igw.id
  }
  tags = {
    Name = "own-public-rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc_x" {
  subnet_id      = aws_subnet.public_subnet_x.id
  route_table_id = aws_route_table.own_public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_y" {
  subnet_id      = aws_subnet.public_subnet_y.id
  route_table_id = aws_route_table.own_public_rt.id
}
# Create IAM Roles for Eks cluster role

resource "aws_iam_role" "own_eks_cluster_role" {
  name = "own-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the EKS cluster policy to the EKS cluster role
resource "aws_iam_role_policy_attachment" "own_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.own_eks_cluster_role.name
}
# Create EKS Cluster Resource: Once you have your networking and IAM setup, create the EKS cluster itself:

resource "aws_eks_cluster" "own_eks_cluster" {
  name     = "own-eks-cluster"
  role_arn = aws_iam_role.own_eks_cluster_role.arn
  version  = "1.27"
  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_x.id,
      aws_subnet.public_subnet_y.id
    ]
  }
  depends_on = [
    aws_iam_role_policy_attachment.own_eks_cluster_policy
  ]
}
# Define EKS Node Group: Define the node group that will contain the worker nodes for your EKS cluster. Ensure you link the node role and necessary IAM policies.

resource "aws_iam_role" "own_eks_node_role" {
  name = "own-eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "own_eks_worker_node_policy" {
  name = "own-eks-worker-node-custom-policy"
  description = "Custom IAM Policy for EKS Worker Nodes with least privileage"
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = [
                "eks:DescribeCluster",
                "eks:ListUpdates",
                "eks:DescribeUpdate",
                "eks:DescribeNodeGroup",
                "eks:ListNodeGroups"
            ]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "ec2:DescribeInstances",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DescribeKeyPairs"
            ]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupEgress"
            ]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetHealth"
            ]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeScheduledActions"
            ]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "ecr:GetAuthorizationToken",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability"
            ]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "iam:ListInstanceProfiles",
                "iam:GetInstanceProfile"
            ]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:GetMetricData",
                "cloudwatch:ListMetrics"
            ]
            Resource = "*"
        }
    ]
  })
}
 
resource "aws_iam_role_policy_attachment" "iam_role_custom_policy_attachment" {
  policy_arn = aws_iam_policy.own_eks_worker_node_policy.arn
  role = aws_iam_role.own_eks_node_role.name
}
 
resource "aws_iam_role_policy_attachment" "own_eks_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.own_eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "own_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.own_eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "own_eks_container_registry" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.own_eks_node_role.name
}

resource "aws_eks_node_group" "own_eks_nodes" {
  cluster_name    = aws_eks_cluster.own_eks_cluster.name
  node_group_name = "own-eks-nodes"
  node_role_arn   = aws_iam_role.own_eks_node_role.arn
  subnet_ids      = [
    aws_subnet.public_subnet_x.id,
    aws_subnet.public_subnet_y.id
  ]
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t2.medium"]
  depends_on = [
    aws_iam_role_policy_attachment.own_eks_node_policy,
    aws_iam_role_policy_attachment.own_eks_cni_policy,
    aws_iam_role_policy_attachment.own_eks_container_registry
  ]
}

output "own_eks_endpoint" {
  value = aws_eks_cluster.own_eks_cluster.endpoint
}

output "own_kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.own_eks_cluster.certificate_authority[0].data
}

