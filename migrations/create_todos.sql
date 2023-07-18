CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
create table todos (
  id uuid DEFAULT uuid_generate_v4() primary key,
  subject text,
  done boolean,
  created_at timestamp not null default current_timestamp,
  updated_at timestamp not null default current_timestamp
);
CREATE UNIQUE INDEX subject_and_done ON todos (id, done);
