output "certificate_arn" {
    value = data.terraform_remote_state.certificate_global.outputs.certificate_arn
}

output "debug_certificate_arn_from_remote_state" {
  description = "DEBUG: This shows the exact ARN being read from the global certificate state."
  value       = data.terraform_remote_state.certificate_global.outputs.certificate_arn
}