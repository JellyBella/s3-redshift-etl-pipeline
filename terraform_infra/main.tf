

# create iam role for glue crawler
module "iam_for_glue" {
  source = "./modules/glue_iam"
}
#create s3 catalog database
resource "aws_glue_catalog_database" "s3_catalog_database" {
  name = var.s3_glue_catalog_database_name
}

#create s3 to glue crawler
resource "aws_glue_crawler" "s3_glue_crawler" {
  database_name = var.s3_glue_catalog_database_name
  name          = var.s3_glue_crawler_name
  role          = module.iam_for_glue.glue_iam_arn
  # schedule      = "cron(0 1 * * ? *)" # the cron job runs at 1am everyday
  s3_target {
    path = format("s3://%s", var.s3_bucket_source_name)
  }
}

#create jdbc connection
resource "aws_glue_connection" "glue_jdbc_conn" {
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:redshift://${aws_redshiftserverless_workgroup.serverless.endpoint[0].address}:${aws_redshiftserverless_workgroup.serverless.port}/dev" #TO BE checked, 5439 is default port ${aws_redshiftserverless_workgroup.serverless.port}
    PASSWORD            = var.redshift_serverless_admin_password
    USERNAME            = var.redshift_serverless_admin_username
  }
  name = var.glue_jdbc_conn_name
  physical_connection_requirements {
    availability_zone = aws_subnet.redshift-serverless-subnet-az1.availability_zone
    security_group_id_list = [
      aws_security_group.redshift-serverless-security-group.id,
    ]
    subnet_id = aws_subnet.redshift-serverless-subnet-az1.id
  }
}
#create redshift catalog database
resource "aws_glue_catalog_database" "redshift_catalog_database" {
  name = var.redshift_glue_catalog_database_name
}
#create redshift to glue crawler
resource "aws_glue_crawler" "redshift_crawler" {
  database_name = var.redshift_glue_catalog_database_name
  name          = var.redshift_glue_crawler_name
  role          = module.iam_for_glue.glue_iam_arn
  jdbc_target {
    connection_name = aws_glue_connection.glue_jdbc_conn.name
    path            = "dev/public/nsw_properties"
  }
}
#create s3 bucket
resource "aws_s3_bucket" "s3_utils_bucket" {
  bucket = var.s3_utils_name
}
#add glue scripts to s3 bucket
resource "aws_s3_object" "add_script" {
  depends_on = [aws_s3_bucket.s3_utils_bucket]
  bucket     = var.s3_utils_name
  key        = var.s3_utils_key
  source     = "${var.glue_src_path}etl.py"
  etag       = filemd5("${var.glue_src_path}etl.py")
}
#create a glue job for ETL
resource "aws_glue_job" "s3_to_redshift_glue_job" {
  name         = var.s3_to_redshift_glue_job_name
  role_arn     = module.iam_for_glue.glue_iam_arn
  glue_version = var.glue_version #"4.0"
  #worker_type  = var.worker_type #"G.1X"
  number_of_workers = var.number_of_workers #2
  timeout           = var.timeout
  connections = [
    var.glue_jdbc_conn_name,
  ]
  command {
    script_location = "s3://${var.s3_utils_name}/${var.s3_utils_key}"
  }
  default_arguments = {
    "--class"                   = var.class                   #"GlueApp"
    "--enable-job-insights"     = var.enable-job-insights     #"true"
    "--enable-auto-scaling"     = var.enable-auto-scaling     #"false"
    "--enable-glue-datacatalog" = var.enable-glue-datacatalog #"true"
    "--job-language"            = var.job-language            #"python"
    "--job-bookmark-option"     = var.job-bookmark-option     #"job-bookmark-disable"
    "--datalake-formats"        = var.datalake-formats        #"iceberg"
    "--conf"                    = var.conf                    #"spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions  --conf spark.sql.catalog.glue_catalog=org.apache.iceberg.spark.SparkCatalog  --conf spark.sql.catalog.glue_catalog.warehouse=s3://tnt-erp-sql/ --conf spark.sql.catalog.glue_catalog.catalog-impl=org.apache.iceberg.aws.glue.GlueCatalog  --conf spark.sql.catalog.glue_catalog.io-impl=org.apache.iceberg.aws.s3.S3FileIO"
  }

}
#create a trigger for glue crawlers
resource "aws_glue_trigger" "glue_trigger" {
  name     = var.glue_trigger_name
  schedule = var.glue_trigger_schedule_value #"cron(15 12 * * ? *)"
  type     = var.glue_trigger_schedule_type  #"SCHEDULED"

  actions {
    job_name = var.s3_to_redshift_glue_job_name
  }
}
