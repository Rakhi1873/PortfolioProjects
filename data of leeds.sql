-- display youngsters in the roaster.
select * from players
where age < 25;

-- Players who play in forward
select name, position from players
where position = "FWD";

-- no of players play in midfield
select count(*) from players
where position = "MID";

-- Total no of youngsters in the roaster.
select count(*) from players
where age < 25;

-- Players earning less than 20,000 per week.
select Name, Wages_per_week 
from players
where Wages_per_week < 20000;

-- youngsters earning less than 20,000 per week
select Name, Wages_per_week, age 
from players
where Wages_per_week < 20000 and age < 25;

-- checking who is the highest valued player in Leeds united.
select * from players 
where value = (select max(value) from players); -- displays Raphina

-- checking who is the least valued player in Leeds united.
select * from players 
where value = (select min(value) from players); -- displays Jack Jenkis

-- checking what is the average value of Leeds united's Roaster.
select avg(value)
from players;

-- checking who has the most goals.
select * from players 
where goals = (select max(goals) from players); -- Patrick Bamford with 17 goals

-- checking who has the most assists.
select * from players 
where assists = (select max(assists) from players); -- Raphina with 9 assists

-- adding a new colun for total contributaions made by a player.
Alter table players
add column Total_cont int;
update players
set Total_cont = goals + assists;
select * from players;

-- most contributions by a player
select * from players 
where Total_cont = (select max(Total_cont) from players); -- Patrick Bamford with 24 contributions.

-- total value of the roaster
select sum(value)
from players; 

-- total wages payed by the club per year.
select sum(Wages_per_week) * 54 as salary
from players; 

-- total wages earned by highly contributed player of roaster.
select Wages_per_week * 54 as salary
from players
where Jrsy_no = 9; 

-- player with yellow cards
select count(*) from players
where yellowcards != 0; -- 18 players has been in books in 2019-2020 season

-- player with red cards
select count(*) from players
where redcards != 0; -- 2 players over the season has recieved the red.

-- player who played most games
select * from players
where GamesPlayed = (select max(GamesPlayed) from players); -- 38 games by Luke Ayling, Patrick Bamford and stuart Dallas.

-- toatl MOM's for the 3 most played players.
select sum(MOM) from players
where GamesPlayed = (select max(GamesPlayed) from players); -- 7 Times won Mom by 3 players.

-- total MOM
select sum(MOM) from players; -- 19

-- total salary paid for the players won MOM
select sum(Wages_per_week) * 54 as salary from players
where MOM != 0;

-- total no of players represnting ENGLAND
select count(*)
from players
where Nation = "ENG"; -- 14

-- Players and Nations
select Count(Name), Nation
from players
group by Nation;
-- FRA = 1, ENG = 14, GER = 1, SCO = 1, NMA = 1, WAL = 2, SPA = 4, NIR = 1, POR = 1, BRA = 1, NED = 3, ITA = 1, SWZ = 1, POL = 1.

-- Players who are eng and youngster earning more than 6k salary.
select * from players
where age < 25 and Wages_per_week > 6000 and Nation = "ENG";

-- Players who are english and youngster who contributed in this season.
select * from players
where age < 25 and Total_cont <> 0 and Nation = "ENG";

-- young players breaking through.
select * from players
where age < 25 and Total_cont <> 0;

-- youngster who contributed in this season other than english players.
select * from players
where age < 25 and Total_cont <> 0 and Nation <> "ENG";

select * from leeds;