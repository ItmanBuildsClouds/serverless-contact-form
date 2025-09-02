resource "aws_s3_object" "upload_files" {
  for_each = fileset("${path.module}/../src", "**/*")

  bucket       = aws_s3_bucket.s3_form_bucket.id
  key          = each.value
  source       = "${path.module}/../src/${each.value}"
      content_type = lookup(
        {
            "html" = "text/html",
            "css" = "text/css"
            "js" = "application/javascript"
        },
        element(split(".", each.value), length(split(".", each.value)) - 1)
      )
        etag = filemd5("${path.module}/../src/${each.value}")


}