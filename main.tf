#
# Variables
#
variable "cluster_description" {
    description = "Short text string describing use of cluster (e.g. staging notebooks cluster.)"
    default = "General purpose container execution for IT experiments and services"
}

variable "cluster_name" {
    description = "Descriptive name for cluster (e.g athenaeum-notebooks-production-1)"
    default = "momentlabs-it"
}

variable "cluster_project" {
    description = "Google cloud project name where cluster will run. (eg. momentlabs-jupyter)"
    default = "momentlabs-it"
}

variable "cluster_zone" {
    description = "google cloude zone where cluster will run (e.g. us-west1-a)"
    default = "us-west1-a"
}

variable "cluster_machine_type" {
    description = "machine type for the default node pool (e.g. f1-micro or n1-standard or n1-standard-4)"
    default = "f1-micro"
}

variable "cluster_initial_node_count" {
    description = "Number of initial nodes in the node pool"
    default = 3
}

variable "cluster_admin_user" {
    description = "google cloud user name to use for creating the cluster."
    default = "david@momentlabs.io"
}

variable "google_creds_file" {
    description = "Location of file with gcloud credentials (e.g account.json)"
    default = "account.json"
}

variable "enable_helm" {
    description = "Install helm in to the cluster if enabled. (takes on of 'true' or 'fase')"
    default = false
}


#
# Resources
#
provider "google" {
    credentials = "${file("${var.google_creds_file}")}"
    project = "${var.cluster_project}"
    zone = "${var.cluster_zone}"
}

# TODO: It probably makes more sense to move this somewhere
# internal so it can try and get the cluster variables right after the cluster
# is created rather than pull them from kubectl config as set up by gcloud. 
provider "kubernetes" {
    host = "${module.gke.endpoint}"
    # client_certificate
    # client_key
    # cluster_ca_certificate
}
#
# Create the cluster
#
module "gke" {
    # source = "./gke"
    source = "git@github.com:Momentlabs/terraform-modules.git//gke"
    cluster_name = "${var.cluster_name}"
    description = "${var.cluster_description}"
    zone = "${var.cluster_zone}"
    machine_type = "${var.cluster_machine_type}"
    initial_node_count = "${var.cluster_initial_node_count}"
    cluster_admin_user = "${var.cluster_admin_user}"
    enable_helm = "${var.enable_helm}"
}

# data "google_client_config" "default" {}
data "google_container_cluster" "new_cluster" {
    name = "${module.gke.cluster_name}"
}


#
# Outputs
#

output "cluster_name" {
    value = "${data.google_container_cluster.new_cluster.name}"
}

output "description" {
    value = "${data.google_container_cluster.new_cluster.description}"
}

# It's completely unclear to me why this doesn't work in the case
# where we have no cluster at first, but the others ones (e.g. machine_type) do.
# output "zone" {
#     value = "${data.google_container_cluster.new_cluster.zone}"
# }

output "machine_type" {
    value = "${data.google_container_cluster.new_cluster.node_config.0.machine_type}"
}

output "initial_node_count" {
    value = "${data.google_container_cluster.new_cluster.initial_node_count}"
}

output "cluster_endpoint" {
    value = "${data.google_container_cluster.new_cluster.endpoint}"
}
