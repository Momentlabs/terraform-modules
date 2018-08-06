output "cluster_name" {
    value = "${google_container_cluster.cluster.name}"
}

output "endpoint" {
    value = "${google_container_cluster.cluster.endpoint}"
}

output "client_cert" {
    value = "${google_container_cluster.cluster.master_auth.0.client_certificate}"
}

output "client_key" {
    value = "${google_container_cluster.cluster.master_auth.0.client_key}"
}

output "cluster_ca_cert" {
    value = "${google_container_cluster.cluster.master_auth.0.cluster_ca_certificate}"
}

