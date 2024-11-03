resource "random_string" "random_suffix" {
  for_each = { for member in var.invoker_members : member => member }
  length   = 4
  special  = false
  upper    = false
}

locals {
  security_definitions = { for member in var.invoker_members : 
    member == "firebase" ? "firebase" : "${split("@", member)[0]}_${random_string.random_suffix[member].result}" => member == "firebase" ? {
      authorizationUrl: ""
      flow: "implicit"
      type: "oauth2"
      x-google-issuer: "https://securetoken.google.com/${var.project_id}"
      x-google-jwks_uri: "https://www.googleapis.com/service_accounts/v1/metadata/x509/securetoken@system.gserviceaccount.com"
      x-google-audiences: var.project_id
    } : {
      authorizationUrl: ""
      flow: "implicit"
      type: "oauth2"
      x-google-issuer: member
      x-google-jwks_uri: "https://www.googleapis.com/robot/v1/metadata/x509/${member}"
    }
  }

  security_definitions_yaml = yamlencode({
    securityDefinitions = local.security_definitions
  })
}

locals {
  security = [for member in var.invoker_members : 
    { (member == "firebase" ? "firebase" : "${split("@", member)[0]}_${random_string.random_suffix[member].result}") = [] }
  ]
  security_yaml = yamlencode({
    security = local.security
  })
}

resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

locals {
  dns = "${var.name}-${random_string.random.result}.endpoints.${var.project_id}.cloud.goog"
}

resource "google_endpoints_service" "spec" {
  service_name   = "${local.dns}"
  project        = var.project_id
  openapi_config = <<EOF
  swagger: "2.0"
  info:
    description: "A proxy service for ${var.name}."
    title: "${var.name}"
    version: "1.0.0"
  host: "${local.dns}"
  x-google-endpoints:
  - name: "${local.dns}"
    target: "${var.loadbalancer_ip}"
    allowCors: True
  consumes:
  - "application/json"
  produces:
  - "application/json"
  schemes:
  - "http"
  ${indent(2,local.security_definitions_yaml)}
  paths:
    "/.well-known/acme-challenge/**":
      get:
        operationId: GetOpenAPIConfig
        responses:
          "200":
            description: GetOpenAPIConfig
          default:
            description: Error
    "/**":
      get:
        operationId: Get
        ${indent(8,local.security_yaml)}
        responses:
          "200":
            description: Get
          default:
            description: Error
      delete:
        operationId: Delete
        ${indent(8,local.security_yaml)}
        responses:
          "204":
            description: Delete
          default:
            description: Error
      patch:
        operationId: Patch
        ${indent(8,local.security_yaml)}
        responses:
          "200":
            description: Patch
          default:
            description: Error
      post:
        operationId: Post
        ${indent(8,local.security_yaml)}
        responses:
          "200":
            description: Post
          default:
            description: Error
      put:
        operationId: Put
        ${indent(8,local.security_yaml)}
        responses:
          "200":
            description: Put
          default:
            description: Error
EOF
}

resource "google_project_service" "enable-proxy" {
  project = var.project_id
  service = google_endpoints_service.spec.dns_address

  timeouts {
    create = "30m"
    update = "40m"
  }
  
  depends_on = [google_endpoints_service.spec]
}