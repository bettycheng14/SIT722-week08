variable "resource_group_name" {
  description = "Resource group that contains the AKS cluster and workspace"
  type        = string
  default     = "225294805-koalatech-week09-rg"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster created by the infrastructure root"
  type        = string
  default     = "225294805week09"
}

variable "github_repository" {
  description = "GitHub owner/repo allowed to federate for the canary workflow"
  type        = string
  default     = "bettycheng14/SIT722-week08"
}
