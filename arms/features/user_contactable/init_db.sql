create table if not exists contact_method (
  contact_method_id int auto_increment not null primary key
  , name varchar(25) not null comment 'example: email, slack, text_message'
  , code text not null comment 'bash script which takes parameters: {user full name} {address defined in user_to_contact_method table} {severity level 0-3} {short message} {long message which may include newlines}'
  , unique index (name)
);

create table if not exists user_to_contact_method (
  user_id int not null
  , contact_method_id int not null
  , address varchar(255) not null comment 'possibly email address, phone number, etc, specific to the contact method. Will be passed into the contact method script'
  , min_severity int not null default 0 comment 'will not use this contact method unless the message has a minimum severity level of this number'
  , primary key (user_id, contact_method_id, address)
);
