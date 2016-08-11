class RaceInfoDao

  create_table_sql <<-EOS
create table if not exists race_info (
  id integer primary key autoincrement,
  race_name     text    not null,
  surface       text    not null,
  distance      integer not null,
  weather       text    not null,
  surface_state text    not null,
  race_start    text    not null,
  race_number   integer not null,
  surface_score integer,
  date          text    not null,
  place_detail  text    not null,
  race_class    text    not null
);
  EOS

  create_date_idx_sql <<-EOS
create index
  date_idx
on
  race_info(date);
  EOS

  create_id_date_idx_sql <<-EOS
create index
  id_date_idx
on
  race_info (id, date);
  EOS
  def createTable session

  end
end
