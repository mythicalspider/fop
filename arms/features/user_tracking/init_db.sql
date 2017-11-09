create table if not exists user (
  user_id int auto_increment not null primary key
  , name varchar(25) not null
  , full_name varchar(50) not null
  , unique index (name)
);

replace into user
    (user_id, name   , full_name     ) values
    (1      , 'auto' , 'Auto Mation' )
  , (2      , 'admin', 'System Admin')
  ;
