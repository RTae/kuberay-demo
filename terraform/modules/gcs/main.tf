resource "google_storage_bucket" "bucket" {
  name          = var.name
  location      = var.location
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "iam" {
  for_each    = { for ou in var.bucket_members : ou.member => ou }

  bucket = google_storage_bucket.bucket.name
  role   = each.value.role
  member = each.value.member

  depends_on = [
    google_storage_bucket.bucket
  ]
}