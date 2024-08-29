resource "null_resource" "copy_charts" {
  count = length(var.charts)

  provisioner "local-exec" {
    command = <<EOT
    az acr helm repo add --name ${var.source_acr_server} --subscription ${var.acr_server_subscription}
    az acr helm pull --name ${var.source_acr_server} ${var.charts[count.index].chart_name} --version ${var.charts[count.index].chart_version}
    az acr helm push --name ${var.acr_server} ${var.charts[count.index].chart_name}-${var.charts[count.index].chart_version}.tgz
    EOT
    environment = {
      AZURE_CLIENT_ID     = var.source_acr_client_id
      AZURE_CLIENT_SECRET = var.source_acr_client_secret
    }
  }
}

resource "helm_release" "install_charts" {
  count = length(var.charts)

  name      = var.charts[count.index].chart_name
  namespace = var.charts[count.index].chart_namespace

  repository = "${var.acr_server}/${var.charts[count.index].chart_repository}"
  chart      = var.charts[count.index].chart_name
  version    = var.charts[count.index].chart_version

  set {
    for_each = { for value in var.charts[count.index].values : value.name => value }
    name  = each.key
    value = each.value.value
  }

  set_sensitive {
    for_each = { for value in var.charts[count.index].sensitive_values : value.name => value }
    name  = each.key
    value = each.value.value
  }

  depends_on = [null_resource.copy_charts]
}