resource "google_service_account" "sa" {
  account_id   = var.name
  display_name = var.display_name
  description  = var.description
}

resource "google_project_iam_member" "iam" {
  for_each = toset(var.iam_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.sa.email}"
  depends_on = [
    google_service_account.sa
  ]
}

resource "google_service_account_iam_binding" "wis" {
  count              = length(var.workload_identity_user_members) > 0 ? 1 : 0

  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = var.workload_identity_user_members

  depends_on = [
    google_service_account.sa
  ]
}