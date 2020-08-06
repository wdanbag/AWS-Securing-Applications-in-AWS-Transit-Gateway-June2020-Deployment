//This module creates bootstrap buckets
variable bucket {}
variable init_cfg_source {}
variable license_content {}


resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket
  acl           = "private"
  force_destroy = true

  tags = {
    Name = var.bucket
  }
}

#Create Folders and Upload Bootstrap Files

/* Not using bootstrap file currently
  resource "aws_s3_bucket_object" "bootstrap_xml" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
  key    = "config/bootstrap.xml"
  content = "bootstrap_files_inbound_a/bootstrap.xml"
}
*/
resource "aws_s3_bucket_object" "init-cft_txt" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
  key    = "config/init-cfg.txt"
  source = var.init_cfg_source
}

resource "aws_s3_bucket_object" "software" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
  key    = "software/"
  content = ""
}

resource "aws_s3_bucket_object" "license" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
  key    = "license/authcodes"
  content = var.license_content
}

resource "aws_s3_bucket_object" "content" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
  key    = "content/"
  content = ""
}

/* Roles, ACLs, Permissions, etc... */

resource "aws_iam_role" "bootstrap_role" {
  name = "ngfw_bootstrap_role__${var.bucket}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
      "Service": "ec2.amazonaws.com"
    },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bootstrap_policy_inbound_a" {
  name = "ngfw_bootstrap_policy_inbound_a"
  role = "${aws_iam_role.bootstrap_role.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.bucket}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${var.bucket}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bootstrap_profile" {
  name = "ngfw_bootstrap_profile__${var.bucket}"
  role = "${aws_iam_role.bootstrap_role.name}"
  path = "/"
}

output "iam_profile" {
  value = "${aws_iam_instance_profile.bootstrap_profile.id}"
}