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

variable "cluster_admin_user" {
    description = "create a system-admin clusterrolebinding for this user and the cluster."
}

variable "enable_helm" {
    description = "Set up and provision helm in the cluster."
    default = false
}
variable "node_permissions" {
    description = "OAuth scopes for acess to google services."
    default = [
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring"
    ]
}
