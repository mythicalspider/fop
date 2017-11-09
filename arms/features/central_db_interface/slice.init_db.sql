----------==========< insert template >==========----------
-- comment this out if you don't want to start from a clean slate
drop database if exists $central_db_name;
create database if not exists $central_db_name;
use $central_db_name;
set default_storage_engine=InnoDB;

