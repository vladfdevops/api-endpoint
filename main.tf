resource "aws_iam_role" "lambda_execution_role" {
  name = "LambdaExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_lambda_function" "epoch_time_function" {
  filename      = "lambda_function_payload.zip"
  function_name = "EpochTimeFunction"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
}

resource "aws_api_gateway_rest_api" "epoch_time_api" {
  name        = "EpochTimeAPI"
  description = "API to return the current epoch time"
}

resource "aws_api_gateway_resource" "epoch_time_resource" {
  rest_api_id = aws_api_gateway_rest_api.epoch_time_api.id
  parent_id   = aws_api_gateway_rest_api.epoch_time_api.root_resource_id
  path_part   = "epoch"
}

resource "aws_api_gateway_method" "epoch_time_method" {
  rest_api_id   = aws_api_gateway_rest_api.epoch_time_api.id
  resource_id   = aws_api_gateway_resource.epoch_time_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.epoch_time_api.id
  resource_id = aws_api_gateway_resource.epoch_time_resource.id
  http_method = aws_api_gateway_method.epoch_time_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.epoch_time_function.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.epoch_time_function.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_deployment" "prod" {
  rest_api_id = aws_api_gateway_rest_api.epoch_time_api.id
  stage_name  = "prod"

  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]
}
