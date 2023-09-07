# ----------------------------------
# OBSERVACOES

# CRIAR ROLE PARA O GLUE COM AS PERMISSOES
    # CRIAR PERMISSAO S3 FULL ACCESS (AmazonS3FullAccess)
    # CRIAR PERMISSAO CLOUDWATCHFULL ACCESS (CloudWatchFullAccess)
    # ADICIONAR PERMISSAO PARA O GLUE (AWSGlueServiceNotebookRole)


# CRIAR GLUE JOB
# ESCREVER A URL DO S3 COM UMA '/' NO FIM

# CRIAR UM CRAWLER PARA LER AS TABELAS DELTA
# ----------------------------------

resource "aws_iam_role" "aws_glue_role" {
  name = "aws_glue_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    description = "allow glue to access s3 bucket, write cloudwatch logs"
  }
}

resource "aws_iam_policy_attachment" "s3_policy_attachment" {
  name       = "my-glue-role-s3-policy-attachment"
  roles      = [aws_iam_role.aws_glue_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "cloudwatch_policy_attachment" {
  name       = "my-glue-role-cloudwatch-policy-attachment"
  roles      = [aws_iam_role.aws_glue_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_policy_attachment" "glue_notebook_policy_attachment" {
  name       = "my-glue-role-glue-notebook-policy-attachment"
  roles      = [aws_iam_role.aws_glue_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceNotebookRole"
}
