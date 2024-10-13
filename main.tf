terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
    }
  }
}

provider "snowflake" {
 # alias = "sys_admin"
 # role = "SYSADMIN"

  alias = "acc_admin"
  role = "ACCOUNTADMIN"
}


resource "snowflake_warehouse" "warehouse" {
  provider = snowflake.acc_admin
  name        = "DRT_WH"
  comment     = "DRT Warehouse"
  warehouse_size = "XSMALL"
  auto_suspend = 60
  auto_resume  = true
  min_cluster_count = 1
  max_cluster_count = 3
  initially_suspended = true
}


resource "snowflake_database" "drt_database" { 
  provider = snowflake.acc_admin 
  name = "DRT_PROD_DB" 
} 

  

resource "snowflake_schema" "drt_schema" { 
  provider = snowflake.acc_admin 
  name = "DRT_STAGE" 
  database = snowflake_database.drt_database.name 
} 


resource "snowflake_user" "DRT_TEST_USER" {
  provider = snowflake.acc_admin
  name  = "DRT_TEST_USER"
  login_name = "DRT_TEST_USER"
  default_role = "SYSADMIN"
}


resource "snowflake_account_role" "complete" {
  provider = snowflake.acc_admin
  name    = "DRT_TEST_ROLE"
  comment = "my account role"
}

