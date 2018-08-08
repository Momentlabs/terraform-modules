#
# Variables
#
variable "cluster_description" {
    default = "General purpose container execution for IT experiments and services"
}

variable "cluster_name" {
    default = "momentlabs-it"
}

variable "cluster_project" {
    default = "momentlabs-it"
}
variable "cluster_zone" {
    default = "us-west1-a"
}

variable "cluster_machine_type" {
    default = "f1-micro"
}
variable "cluster_initial_node_count" {
    default = 3
}

variable "cluster_admin_user" {
    default = "david@momentlabs.io"
}
variable "enable_helm" {
    description = "Install helm in to the cluster if enabled."
    default = true
}

#
# Resources
#
provider "google" {
    credentials = "${file("account.json")}"
    project = "${var.cluster_project}"
    zone = "${var.cluster_zone}"
}

# I can't seem to get the certs to work when taken from the module or the data source.
# I've checked and the ones that are returned from the module are
# the sames ones that are in the kubectl config file. Go figure?
provider "kubernetes" {
    host = "${module.gke.endpoint}"
    // // client_certificate = "${module.gke.client_cert}"
    // client_key = "${module.gke.client_key}"
    // cluster_ca_certificate = "${module.gke.cluster_ca_cert}"
}
#
# Create the cluster
#
module "gke" {
    source = "./gke"
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
# Set the cluster up for Helm use
# 


# # This create a service account for Helm tiller, then
# # using the account it provisions the cluster with Helm.
# # This is dependent on the cluster above having sucessfully
# # downloaded credentials for the cluster into kubectl.
# resource "kubernetes_service_account" "tiller_sa" {
#     count = "${var.enable_helm ? 1 : 0}"
#     metadata{ 
#         name = "tiller"
#         namespace =  "kube-system"
#     }
    
#     # First set up the binding to this role enable tiller to do it's thing ...
#     provisioner "local-exec" "cluster_role_bindings" {
#         command = "kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller"
#     }

#     # ... then install tiller on the cluster
#     provisioner "local-exec" "helm_install" {
#         command = "helm init --service-account tiller"
#     }
# }


#
# Outputs
#

# output "cluster_name" {
#     value = "${data.google_container_cluster.new_cluster.name}"
# }

# output "description" {
#     value = "${data.google_container_cluster.new_cluster.description}"
# }

# It's completely unclear to me why this doesn't work in the case
# where we have no cluster at first, but the others ones (e.g. machine_type) do.
# output "zone" {
#     value = "${data.google_container_cluster.new_cluster.zone}"
# }

# output "machine_type" {
#     value = "${data.google_container_cluster.new_cluster.node_config.0.machine_type}"
# }

# output "initial_node_count" {
#     value = "${data.google_container_cluster.new_cluster.initial_node_count}"
# }

# output "endpoint" {
#     value = "${data.google_container_cluster.new_cluster.endpoint}"
# }

// output "access_token" {
//     value = "${data.google_client_config.default.access_token}"
// }

// output "output_client_cert" {
//     value = "${module.gke.client_cert}"
// }

// output "output_client_key" {
//     value = "${module.gke.client_key}"
// }
// output "output_cluster_ca_certificate" {
//     value = "${module.gke.cluster_ca_cert}"
// }

// output "data_client_cert" {
//     value = "${data.google_container_cluster.new_cluster.master_auth.0.client_certificate}"
// }

// output "data_client_key" {
//     value = "${data.google_container_cluster.new_cluster.master_auth.0.client_key}"
// }

// output "data_cluster_ca_cert" {
//     value = "${data.google_container_cluster.new_cluster.master_auth.0.cluster_ca_certificate}"
// }