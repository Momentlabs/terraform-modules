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
        oauth_scopes = [
            "https://www.googleapis.com/auth/compute"
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
        ]
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
