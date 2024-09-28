# Terraform GCP Managed Instance Group

Based on examples elsewhere on my GitHub, e.g. [pulumi-aws-asg](https://github.com/joshuamkite/pulumi-aws-asg) but here with the GCP equivalents. This example does not feature a DNS entry or cert

# Breakdown of replacement:

- **AWS Auto Scaling Group (ASG)** in GCP becomes **Managed Instance Groups (MIG)**.
- The equivalent of **Launch Configuration** becomes **Instance Templates** in GCP.
- **Scaling Policies** in GCP are managed via **autoscalers**.

The autoscaler automatically adjusts the size of the Managed Instance Group based on conditions (like CPU utilization):

This configuration sets up the equivalent resources for an Auto Scaling Group in AWS, using GCP's Managed Instance Group and Autoscaler resources.

In GCP, the equivalent of **user data** for instances (as in AWS EC2) is handled through **startup scripts** in the instance templates. 

### Load Balancer Requirements
GCP HTTP Load Balancer, requires several resources:

1. A **backend service** that points to the Managed Instance Group.
2. A **URL map** and **target HTTP proxy**.
3. A **global forwarding rule** to direct traffic to the proxy.
4. A **Health Check** to ensurre targets are available to rteceive traffic via load balancer
   
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >=3.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_autoscaler.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_autoscaler) | resource |
| [google_compute_backend_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_firewall.allow_health_check](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_global_forwarding_rule.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_http_health_check.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_http_health_check) | resource |
| [google_compute_instance_group_manager.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group_manager) | resource |
| [google_compute_instance_template.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template) | resource |
| [google_compute_target_http_proxy.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_url_map.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | The name of the bucket to store the terraform state file. | <pre>object({<br/>    name   = string<br/>    prefix = string<br/>  })</pre> | n/a | yes |
| <a name="input_default_labels"></a> [default\_labels](#input\_default\_labels) | value of the default labels to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | List of machine types for the instances | `string` | `"e2-micro"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to aply for all resources in stack | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project ID where the resources will be created. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where the instance group manager will be created. | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone where the instance group manager will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip"></a> [ip](#output\_ip) | n/a |
