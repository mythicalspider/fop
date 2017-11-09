----------==========< find wildcard >==========----------
create table* prop (
----------==========< find regex >==========----------
^ *, .*
----------==========< insert exact >==========----------
  , observation_frequency tinyint not null comment '0 means no auto observation. 10 means wait 10 seconds between observations, 20=100 secs, 30=1000 secs' 
  , max_severity int default 0 not null comment '0 means failure will never generate alerts, 1 means minor failure, 2 major, etc' 
----------==========< jump to end >==========----------
create table if not exists observation (
  observation_id int not null primary key
  , prop_id int not null
  , event_time datetime not null
  , observed_value varchar(255) not null
  , foreign key (prop_id) references prop(prop_id) on update cascade on delete cascade
);

create table if not exists observation_status (
  prop_id int not null primary key
  , wait_until datetime comment 'null means execute immediately'
  , last_observation_id int comment 'null means it has not been observed yet'
  , foreign key (last_observation_id) references observation(observation_id) on update cascade on delete set null
  , foreign key (prop_id) references prop(prop_id) on update cascade on delete cascade
);

delimiter $$
create trigger if not exists after_prop_inserted_insert_observation_status
  after insert on prop
  for each row begin
    insert into observation_status set
      prop_id=NEW.prop_id
    ;
  end
$$

create trigger if not exists after_observation_insert_update_observation_status
  after insert on observation
  for each row begin
    update observation_status set last_observation_id=NEW.observation_id
    where prop_id=NEW.prop_id
    ;
  end
$$
delimiter ;

