resource "null_resource" "setup_k8s_master" {
  connection {
    type        = "ssh"
    host        = var.host
    user        = var.user
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable\"",
      "sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "sudo systemctl enable docker.service",
      "sudo systemctl start docker.service",
      "sudo swapoff -a",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "sudo apt-add-repository \"deb http://apt.kubernetes.io/ kubernetes-xenial main\"",
      "sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl",
      "sudo kubeadm init --pod-network-cidr=10.244.0.0/16",
      "mkdir -p /home/${var.user}/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf /home/${var.user}/.kube/config",
      "sudo chown ${var.user}:${var.user} /home/${var.user}/.kube/config",
      "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
    ]
  }
}

resource "null_resource" "copy_kubeconfig" {
  depends_on = [null_resource.setup_k8s_master]

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.private_key_path} ${var.user}@${var.host}:/home/${var.user}/.kube/config ./kubeconfig"
  }
} 
