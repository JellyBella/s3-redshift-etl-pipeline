variable "s3_bucket_destination_name" {
  description = "glue crawler destination bucket"
  type        = string
}
variable "s3_glue_catalog_database_name" {
  description = "glue catalog database"
  type        = string
}

variable "s3_glue_crawler_name" {
  description = "glue crawler name"
  type        = string
}
variable "s3_bucket_source_name" {
  description = "glue crawler source bucket"
  type        = string
}
#############################
## Application - Variables ##
#############################

# Application definition

variable "app_name" {
  type        = string
  description = "Application name"
}

#########################
## Network - Variables ##
#########################

# Network configuration

variable "redshift_serverless_vpc_cidr" {
  type        = string
  description = "VPC IPv4 CIDR"
}

variable "redshift_serverless_subnet_1_cidr" {
  type        = string
  description = "IPv4 CIDR for Redshift subnet 1"
}

variable "redshift_serverless_subnet_2_cidr" {
  type        = string
  description = "IPv4 CIDR for Redshift subnet 2"
}

variable "redshift_serverless_subnet_3_cidr" {
  type        = string
  description = "IPv4 CIDR for Redshift subnet 3"
}

#####################################
## Redshift Serverless - Variables ##
#####################################

variable "redshift_serverless_namespace_name" {
  type        = string
  description = "Redshift Serverless Namespace Name"
}

variable "redshift_serverless_database_name" {
  type        = string
  description = "Redshift Serverless Database Name"
}

variable "redshift_serverless_admin_username" {
  type        = string
  description = "Redshift Serverless Admin Username"
}

variable "redshift_serverless_admin_password" {
  type        = string
  description = "Redshift Serverless Admin Password"
}

variable "redshift_serverless_workgroup_name" {
  type        = string
  description = "Redshift Serverless Workgroup Name"
}

variable "redshift_serverless_base_capacity" {
  type        = number
  description = "Redshift Serverless Base Capacity"
  default     = 32 // 32 RPUs to 512 RPUs in units of 8 (32,40,48...512)
}

variable "redshift_serverless_publicly_accessible" {
  type        = bool
  description = "Set the Redshift Serverless to be Publicly Accessible"
  default     = false
}

###################################
## Glue Redshift Variables ##
###################################
variable "glue_jdbc_conn_name" {
  type        = string
  description = "redshift to glue jdbc connector"
}
variable "redshift_glue_catalog_database_name" {
  type        = string
  description = "redshift to glue catalog database name"
}
variable "redshift_glue_crawler_name" {
  type        = string
  description = "redshift to glue catalog crawler name"
}
###################################
## Glue Job Variables ##
###################################
variable "s3_utils_name" {
  type        = string
  description = "s3 bucket for glue script"
}
variable "s3_utils_key" {
  type        = string
  description = "path to glue script in s3"
}
variable "glue_src_path" {
  type        = string
  description = "s3 bucket for glue script"
  default     = "../etl_scripts/"
}
variable "s3_to_redshift_glue_job_name" {
  type        = string
  description = "glue job name"
}

variable "timeout" {
  description = "timeout"
  type        = number
}

# variable "iam_glue_arn" {
#   description = "iam glue arn"
#   type        = string
# }

variable "glue_version" {
  description = "glue version"
  type        = string
}
variable "number_of_workers" {
  description = "glue number of workers"
  type        = number
}
variable "class" {
  description = "argument glue class"
  type        = string
}

variable "enable-job-insights" {
  description = "argument enable job insights"
  type        = string
}

variable "enable-auto-scaling" {
  description = "argument enable job scaling"
  type        = string
}

variable "enable-glue-datacatalog" {
  description = "argument enable glue datacatalog"
  type        = string
}

variable "job-language" {
  description = "argument job language"
  type        = string
}

variable "job-bookmark-option" {
  description = "argument job bookmark option"
  type        = string
}

variable "datalake-formats" {
  description = "argument job datalake formats"
  type        = string
}

variable "conf" {
  description = "argument conf"
  type        = string
}
variable "glue_trigger_name" {
  description = "glue trigger name"
  type        = string
}
variable "glue_trigger_schedule_value" {
  description = "glue trigger schedule value"
  type        = string
}
variable "glue_trigger_schedule_type" {
  description = "glue trigger schedule type"
  type        = string
}
