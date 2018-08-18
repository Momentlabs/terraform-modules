# GKE Cluster
resource "google_container_cluster" "cluster" {
    description = "${var.description}"
    name = "${var.cluster_name}"
    initial_node_count = "${var.initial_node_count}"

    node_config {
        machine_type = "${var.machine_type}"
        labels {
            cluster = "${var.cluster_name}"
        }
        oauth_scopes = "${node.permissions}"
    }

    # Let's set up the local kubectrl credentials for this once it's up.
    # Note: this will fail, of course, if gcloud isn't installed locally. 
    provisioner "local-exec" "kube-credentials" {
        command = "gcloud container clusters get-credentials --zone ${var.zone} ${var.cluster_name}"
    }
    
    # This will give system admin privelages to the provided user.
    # This fails if we don't have kubectl installed locally.
    provisioner "local-exec" "admin_clusterrolebinding" {
        command = "kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=${var.cluster_admin_user}"
    }

}
