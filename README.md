# Epoch Time API Deployment with Terraform

## Prerequisites
- Install [Terraform](https://www.terraform.io/downloads.html)
- AWS CLI configured with appropriate credentials and default region.

## Deployment Steps
1. Ensure your `main.tf` file and `lambda_function_payload.zip` are in the same directory.
2. Open a terminal and navigate to the directory containing your Terraform files.
3. Run the following commands in sequence:

```
terraform init
terraform apply
```

4. Confirm the deployment when prompted by typing `yes`.

## Usage
After successful deployment, Terraform will provision AWS Lambda and API Gateway resources. You can find your API endpoint in the AWS Console under API Gateway.

## Test API Endpoint by:

CLI:
```
https://<api-id>.execute-api.<region>.amazonaws.com/<stage>/epoch

```
AWS Console:

API Gateway -> APIs -> EpochTimeAPI -> GET -> Test -> Test

## Cleanup
To destroy the provisioned infrastructure, run:

```
terraform destroy
```

Confirm destruction when prompted by typing `yes`.
