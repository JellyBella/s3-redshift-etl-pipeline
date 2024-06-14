# Create a Security Group for Redshift Serverless
resource "aws_security_group" "redshift-serverless-security-group" {
  depends_on = [aws_vpc.redshift-serverless-vpc]

  name        = "${var.app_name}-redshift-serverless-security-group"
  description = "${var.app_name}-redshift-serverless-security-group"

  vpc_id = aws_vpc.redshift-serverless-vpc.id

  ingress {
    description = "all traffic"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-redshift-serverless-security-group"
  }
}
#create end point gateway to to allow traffic between s3 and redshift VPC
resource "aws_vpc_endpoint" "s3_redshift" {
  vpc_id            = aws_vpc.redshift-serverless-vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_vpc.redshift-serverless-vpc.default_route_table_id]
}
