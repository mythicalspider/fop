create table if not exists prop_class (
  prop_class_id int auto_increment not null primary key
  , name varchar(50) not null
  , unique index (name)
);

create table if not exists prop (
  prop_id int auto_increment not null primary key
  , name varchar(50) not null
  , prop_class_id int not null
  , host_id int not null comment 'immutable: should be set at creation time and never changed'
  , active enum('yes', 'no') default 'yes' comment 'set to no when this prop is retired. Record is kept so history is consistent'
  , index (name)
  , foreign key (prop_class_id) references prop_class(prop_class_id) on update cascade on delete cascade
  , foreign key (host_id) references host(host_id) on update cascade on delete cascade
);

