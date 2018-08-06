# GKE module variables
variable "cluster_name" {
    description = "Name appearing in GCP for the cluster."
}

variable "description" {
    description = "Short description of how this cluster is used."
}

variable "zone" {
    description = "GCP zone where the clusters nodes are instanced."
}

variable "machine_type" {
    description = "Machine type for the nodes in the cluster."
}

variable "initial_node_count" {
    description = "Number of nodes to start the cluster with"
}
