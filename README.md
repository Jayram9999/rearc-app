A nodejs webapp hosting on Kubernetes using terraform and AWS Cloud.

Following tools/technologies are used for infra:
- Terraform
- AWS EKS
- External-dns
- AWS Load Balancer Controller

============

Overview:

- Terraform 

1. Source main.tf in infra directory, is calling the VPC and EKS resources for creation
2. Used terraform-aws-vpc module for VPC and individual EKS resources are created. 
3. subnet_ids and vpc_ids generated from the VPC module are shared as a input to EKS module to create the EKS cluster.

Reference: https://github.com/GovardhanMundlur/rearc-app/blob/9731711542fbe0c1b41b8768b43d785a95ce81cf/infra/main.tf#L12

- External-dns

External-dns is used to register the ALB with route53 record and the configuration is provided in ingress.

Reference: 

- AWS Load Balancer Controller

AWS Load Balancer controller is setup using the AWS doc, below link for reference.
https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html

- Ingress

Ingress is configured with annnotations of AWS Load Balancer Controller to provision, register with target group and also create a record in Route53 (external-dns).

========================

How to deploy?

Prerequisite: 
- Install Terraform, Kubectl and AWS cli
- Setup IAM role or Access key based authenticaton (preferrable use IAM Role, if not session based token)
- Linux Server to execute the script

1. Initiate the deployment of infra by executing the command:
   `terraform init`
  
2. Run `terraform plan` to verify the infrastructure resources

3. Execute `terraform apply` to create the resources. Resource creation takes approximately 20-25mins, wait till the deployment completes.

4. Once the AWS infra resources are created, execute the shell script to deploy the Kubernetes objects.

Improvements: 

- Dynamically update the docker image tag for K8s deployment file every time the script is run. This can be achieved by using simple shell script such as yq and increment the tag version number by fetching the last tag details from the ECR. (In progress)
- Setup ArgoCD with a application.yaml file for the deployment of the app
