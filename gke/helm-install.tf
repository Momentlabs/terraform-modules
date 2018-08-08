# This creates a service account for Helm tiller in the cluster
# as provisioneed by the Kubernetes provider (this means that the kubernetes provider
# needs to be pointing at the cluster where tiller should be installed.
# It then goes on to create a rolebinding for this new service account to cluster-admin.
# Finally it installs tiller into the cluster by execing: helm init
# This requires both kubectl and helm is installed locally.
# 
resource "kubernetes_service_account" "tiller_sa" {
    count = "${var.enable_helm ? 1 : 0}"
    metadata{ 
        name = "tiller"
        namespace =  "kube-system"
    }
    
    # First bind cluster-admin role  to this role enable tiller to do it's thing ...
    provisioner "local-exec" "cluster_role_bindings" {
        command = "kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller"
    }


    # ... then install tiller on the cluster ...
    provisioner "local-exec" "helm_install" {
        command = "helm init --service-account tiller --wait"
    }

    # ... ensure that the automountServiceAccountToken is set to true on the tiller deployment ....
    # This seems to come from a bug? in the terraform provider implementation that sets this to false.
    provisioner "local-exec" "automountServiceAccountToken" {
        command = "kubectl -n kube-system patch deployment tiller-deploy -p '{\"spec\": {\"template\": {\"spec\": {\"automountServiceAccountToken\": true}}}}'"
    }

    # .. finally let's secure the tiller again, I'm not completely sure what's why this is so important
    # but it does come highly recommended.
    provisioner "local-exec" "secure_tiller" {
        command = "kubectl --namespace=kube-system patch deployment tiller-deploy --type=json --patch='[{\"op\": \"add\", \"path\": \"/spec/template/spec/containers/0/command\", \"value\": [\"/tiller\", \"--listen=localhost:44134\"]}]'"
    }
}
