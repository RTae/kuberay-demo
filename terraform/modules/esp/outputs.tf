output "dns" {
  value       = google_endpoints_service.spec.dns_address
  description = "The URL of the Cloud Run service"
}