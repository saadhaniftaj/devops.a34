resource "aws_iam_user" "terraform_user" {
  name = var.iam_user_name
  path = "/"

  tags = {
    Name = var.iam_user_name
  }
}

resource "aws_iam_access_key" "terraform_user_key" {
  user = aws_iam_user.terraform_user.name
}

resource "aws_iam_user_policy_attachment" "admin_policy" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_login_profile" "terraform_user_console" {
  user                    = aws_iam_user.terraform_user.name
  password_reset_required = true

  lifecycle {
    ignore_changes = [password_reset_required]
  }
}
