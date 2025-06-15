resource "null_resource" "apply_k8s_yaml" {
  provisioner "local-exec" {
    command     = "kubectl apply -f deployment.yaml -f service.yaml -f ingress.yaml"
    working_dir = path.module
  }
}
