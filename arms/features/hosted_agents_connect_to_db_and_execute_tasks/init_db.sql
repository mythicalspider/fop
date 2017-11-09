create table if not exists host (
  host_id int auto_increment not null primary key
  , name varchar(25) not null
  , primary_ip varchar(50) not null
);

create table if not exists script (
  script_id int auto_increment not null primary key
  , name varchar(50) not null
  , version int not null
  , parameters varchar(255) not null
  , content text not null comment 'should be immutable'
  , unique index (name, version)
);

create table if not exists output (
  output_id int auto_increment not null primary key
  , creation_time datetime not null
  , content text not null comment 'should be immutable'
  , index (creation_time)
);

create table if not exists task_request (
  task_request_id int auto_increment not null primary key
  , host_id int not null
  , wait_until datetime default null comment 'null means execute immediately'
  , script_id int not null
  , parameters varchar(255) not null
  , foreign key (host_id) references host(host_id) on update cascade on delete cascade
  , foreign key (script_id) references script(script_id) on update cascade on delete cascade
);

create table if not exists task_request_not_done (
  task_request_id int not null primary key
  , foreign key (task_request_id) references task_request(task_request_id) on update cascade on delete cascade
);

delimiter $$
create trigger if not exists after_task_request 
  after insert on task_request 
  for each row begin
    insert into task_request_not_done set
      task_request_id=NEW.task_request_id
    ;
  end
$$
delimiter ;

create table if not exists task_status_change (
  task_status_change_id int auto_increment not null primary key
  , task_request_id int not null
  , output_id int default null comment 'null means the output no longer exists, or it does not apply to this status'
  , error_id int default null comment 'null means the output no longer exists, or it does not apply to this status'
  , event_time datetime not null
  , new_status enum('started', 'done') not null
  , result enum('succeeded', 'failed') default null comment 'null if the result has not been determined yet'
  , foreign key (task_request_id) references task_request(task_request_id) on update cascade on delete cascade
  , foreign key (output_id) references output(output_id) on update cascade on delete set null
  , foreign key (error_id) references output(output_id) on update cascade on delete set null
);

delimiter $$
create trigger if not exists after_task_completed 
  after insert on task_status_change 
  for each row begin
    if NEW.new_status='done' then
      delete from task_request_not_done
      where task_request_id=NEW.task_request_id
      ;
    end if;
  end
$$
delimiter ;

