#Get AWS account id
data "aws_caller_identity" "current" {

}

#Create IAM User
resource "aws_iam_user" "ci_wordpress" {
  name = "ci-${var.name}"
  tags = var.tags
}

#Create Key
resource "aws_iam_access_key" "aws_access_key" {
  user = aws_iam_user.ci_wordpress.name

  depends_on = [
    aws_iam_user.ci_wordpress
  ]
}

data "aws_iam_policy_document" "user_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:PutLifecyclePolicy",
      "ecr:PutImageTagMutability",
      "ecr:DescribeImageScanFindings",
      "ecr:StartImageScan",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetDownloadUrlForLayer",
      "ecr:ListTagsForResource",
      "ecr:UploadLayerPart",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UntagResource",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:TagResource",
      "ecr:DescribeRepositories",
      "ecr:StartLifecyclePolicyPreview",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetRepositoryPolicy",
      "ecr:GetLifecyclePolicy",
      "ecr:GetAuthorizationToken",
      "ecr:CompleteLayerUpload"
    ]

    resources = [aws_ecr_repository.ecr_repo.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]

    resources = ["*"]
  }
}

#Create policy from document
resource "aws_iam_user_policy" "user_policy" {
  name = "${var.name}-policy"
  user = aws_iam_user.ci_wordpress.name

  policy = data.aws_iam_policy_document.user_policy.json
}

#Create CircleCI Context
resource "circleci_context" "ci_user" {
  depends_on   = [aws_iam_user.ci_wordpress]
  name         = "${var.name}-${var.environment}"
  organization = var.organization
}

#Add the User to context
resource "circleci_context_environment_variable" "aws_access_key_id" {
  depends_on   = [circleci_context.ci_user]
  variable     = "AWS_ACCESS_KEY_ID"
  value        = aws_iam_access_key.aws_access_key.id
  context_id   = circleci_context.ci_user.id
  organization = var.organization
}

#Add the key to context
resource "circleci_context_environment_variable" "aws_secret_access_key" {
  depends_on   = [circleci_context.ci_user]
  variable     = "AWS_SECRET_ACCESS_KEY"
  value        = aws_iam_access_key.aws_access_key.secret
  context_id   = circleci_context.ci_user.id
  organization = var.organization
}

#Add the region to context
resource "circleci_context_environment_variable" "aws_default_region" {
  depends_on   = [circleci_context.ci_user]
  variable     = "AWS_DEFAULT_REGION"
  value        = var.region
  context_id   = circleci_context.ci_user.id
  organization = var.organization
}

#Add ECR URL to context
resource "circleci_context_environment_variable" "aws_ecr_account_url" {
  depends_on   = [circleci_context.ci_user]
  variable     = "AWS_ECR_ACCOUNT_URL"
  value        = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  context_id   = circleci_context.ci_user.id
  organization = var.organization
}
