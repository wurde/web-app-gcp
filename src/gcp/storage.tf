# Define Cloud Storage resources.
# https://cloud.google.com/storage

# https://www.terraform.io/docs/providers/google/r/storage_bucket.html
resource "google_storage_bucket" "domain" {
  # The name of the bucket.
  name = local.bucket_name

  # The GCS location.
  location = "US"

  # Enables Bucket Policy Only access to a bucket.
  bucket_policy_only = true

  # Configure your bucket as a static website.
  website {
    main_page_suffix = "index.html"
  }

  # Enable versioning.
  versioning {
    enabled = true
  }

  # The bucket's Lifecycle Rules configuration.
  lifecycle_rule {
    condition {
      # Minimum age of an object in days to satisfy this condition.
      age = "30"

      # Match to live and/or archived objects.
      with_state = "ARCHIVED"
    }

    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  lifecycle_rule {
    condition {
      # Minimum age of an object in days to satisfy this condition.
      age = "365"

      # Match to live and/or archived objects.
      with_state = "ARCHIVED"
    }

    action {
      type = "Delete"
    }
  }

  # All objects (including locked) are deleted when deleting a bucket.
  force_destroy = true
}

# https://www.terraform.io/docs/providers/google/r/storage_bucket_object.html
resource "google_storage_bucket_object" "dist" {
  for_each = fileset(var.dist_dir, "**")

  # The name of the object.
  name = each.value

  # The name of the containing bucket.
  bucket = google_storage_bucket.domain.name

  # A path to the data you want to upload.
  source = "${var.dist_dir}/${each.value}"

  # Content-Type of the object data. Defaults to "application/octet-stream".
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}

# https://www.terraform.io/docs/providers/google/r/storage_bucket_iam.html
resource "google_storage_bucket_iam_member" "all_users_viewers" {
  # Used to find the parent resource to bind the IAM policy to.
  bucket = google_storage_bucket.domain.name

  # The role that should be applied.
  role = "roles/storage.legacyObjectReader"

  # Identities that will be granted the privilege.
  member = "allUsers"
}
