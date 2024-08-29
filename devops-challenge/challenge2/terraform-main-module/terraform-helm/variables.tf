variable "acr_server" {
  description = "El servidor del registro de ACR de destino (instancia)."
  type        = string
}

variable "acr_server_subscription" {
  description = "El ID de la suscripción de Azure donde reside el ACR de destino."
  type        = string
}

variable "source_acr_client_id" {
  description = "El ID de cliente (Client ID) para acceder al ACR de referencia."
  type        = string
}

variable "source_acr_client_secret" {
  description = "El secreto de cliente (Client Secret) para acceder al ACR de referencia."
  type        = string
  sensitive   = true
}

variable "source_acr_server" {
  description = "El servidor del registro de ACR de referencia."
  type        = string
}

variable "charts" {
  description = "Una lista de objetos que describen los charts a importar e instalar."
  type = list(object({
    chart_name      = string
    chart_namespace = string
    chart_repository = string
    chart_version    = string
    values           = list(object({
      name  = string
      value = string
    }))
    sensitive_values = list(object({
      name  = string
      value = string
    }))
  }))
}