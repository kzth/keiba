create table payoffs(
  race_id      integer not null,
  ticket_type  integer not null check(ticket_type between 0 and 7),
  horse_number text    not null,
  payoff       real    not null check(payoff >= 0),
  popularity   integer not null check(popularity >= 0),
  primary key (race_id, ticket_type, horse_number),
  foreign key (race_id) references race_info (id)
);
