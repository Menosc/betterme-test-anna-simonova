variable "candidate_name" {
  description = "Candidate name"
  type        = string
  default     = "anna"
}   
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}       
variable "project_name" {
  description = "Project name"
  type        = string
  default     = "betterme"
}   
variable "environment" {
  description = "Environment"
  type        = string
  default     = "test"
}
    
variable "ip_cidr" {
  description = "IP CIDR"
  type        = string
  default     = "0.0.0.0/0"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}
variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}
