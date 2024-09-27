variable "zone" {
  description = "The zone where the instance group manager will be created."
  type        = string
}

variable "machine_type" {
  description = "List of machine types for the instances"
  type        = string
  default     = "e2-micro"
}

variable "name" {
  description = "Name to aply for all resources in stack"
  type        = string
}

variable "default_labels" {
  description = "value of the default labels to apply to all resources"
  type        = map(string)
}

variable "region" {
  description = "The region where the instance group manager will be created."
  type        = string
}

variable "project" {
  description = "The project ID where the resources will be created."
  type        = string
}
