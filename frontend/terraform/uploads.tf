data "fileset" "website_files" {
    path = "${path.module}/../src/**/*"
}

resource "aws_s3_object" "upload_files" {
    for_each = data.fileset.website_files.file
    bucket = aws_s3_bucket.s3_form_bucket.id
    key = each.key
    source = "${path.module}/../src/${each.key}"
    content_type = lookup(
        {
            "html" = "text/html",
            "js" = "application/javascript"
        },
        fileext(each.key)

    )
    etag = filemd5("${path.module}/../src/${each.key}")
}