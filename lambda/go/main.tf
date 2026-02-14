module "lambda" {
  source = "../standard"

  function_name = var.function_name
  handler       = "bootstrap"
  runtime       = "provided.al2023"
  source_file   = var.source_file

  memory_size        = var.memory_size
  timeout            = var.timeout
  log_retention_days = var.log_retention_days

  environment_variables = var.environment_variables
  policy_statements     = var.policy_statements
  tags                  = var.tags
}
