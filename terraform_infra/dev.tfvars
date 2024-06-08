s3_glue_catalog_database_name = "nsw_properties_s3_database"
#database names are using underscore instead of dash
s3_glue_crawler_name       = "nsw-properties-s3-crawler"
s3_bucket_source_name      = "nsw-properties-source-bucket"
s3_bucket_destination_name = "nsw-properties-crawler-dest-bucket"
##########################
# Application Definition # 
##########################
app_name = "nsw-properties" # Do NOT enter any spaces
#########################
# Network Configuration #
#########################
redshift_serverless_vpc_cidr      = "10.20.0.0/16"
redshift_serverless_subnet_1_cidr = "10.20.1.0/24"
redshift_serverless_subnet_2_cidr = "10.20.2.0/24"
redshift_serverless_subnet_3_cidr = "10.20.3.0/24"

###################################
## Redshift Serverless Variables ##
###################################
redshift_serverless_namespace_name      = "nsw-properties-namespace"
redshift_serverless_database_name       = "dev" //must contain only lowercase alphanumeric characters, underscores, and dollar signs
redshift_serverless_admin_username      = "admin"
redshift_serverless_admin_password      = "opBD0dCy5dA8dbma06Xd"
redshift_serverless_workgroup_name      = "nsw-properties-workgroup"
redshift_serverless_base_capacity       = 32   // 32 RPUs to 512 RPUs in units of 8 (32,40,48...512)
redshift_serverless_publicly_accessible = true # for testing, set to false after testing

###################################
## Glue Redshift Variables ##
###################################
glue_jdbc_conn_name                 = "nsw-properties-jdbc-connector"
redshift_glue_catalog_database_name = "nsw_properties_redshift_database"
redshift_glue_crawler_name          = "nsw-properties-redshift-crawler"

###################################
## Glue Job Variables ##
###################################
s3_utils_name                = "nsw-properties-utils"
s3_utils_key                 = "../etl_scripts/etl.py"
s3_to_redshift_glue_job_name = "nsw-properties-s3-to-redshift-job"
glue_version                 = "4.0"
# worker_type                  = "G.1X"
number_of_workers       = 2
timeout                 = 2880
class                   = "GlueApp"
enable-job-insights     = "true"
enable-auto-scaling     = "false"
enable-glue-datacatalog = "true"
job-language            = "python"
job-bookmark-option     = "job-bookmark-disable"
datalake-formats        = "iceberg"
conf                    = "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions  --conf spark.sql.catalog.glue_catalog=org.apache.iceberg.spark.SparkCatalog  --conf spark.sql.catalog.glue_catalog.warehouse=s3://tnt-erp-sql/ --conf spark.sql.catalog.glue_catalog.catalog-impl=org.apache.iceberg.aws.glue.GlueCatalog  --conf spark.sql.catalog.glue_catalog.io-impl=org.apache.iceberg.aws.s3.S3FileIO"

###################################
## Glue Trigger Variables ##
###################################
glue_trigger_name           = "nsw-properties-gluejob-trigger"
glue_trigger_schedule_value = "cron(15 12 * * ? *)"
glue_trigger_schedule_type  = "SCHEDULED"
