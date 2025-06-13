resource "aws_ecr_repository" "flask_app" {
  name = "flask-app-repo"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.environment}-flask-app"
  }
}

