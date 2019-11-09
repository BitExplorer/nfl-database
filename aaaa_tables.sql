CREATE DATABASE nfl_db;
GRANT ALL PRIVILEGES ON DATABASE nfl_db TO henninb;
\connect nfl_db;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SEQUENCE t_team_team_id_seq START WITH 1001;

DROP TABLE IF EXISTS t_team;
CREATE TABLE IF NOT EXISTS t_team(
  team_id INTEGER DEFAULT nextval('t_team_team_id_seq') NOT NULL,
  team_location CHAR(40) NOT NULL,
  team_name CHAR(20), -- NULL for now
  team_short_name CHAR(4), -- NULL for now
  team_league CHAR(4), -- NULL for now
  date_updated TIMESTAMP DEFAULT TO_TIMESTAMP(0),
  date_added TIMESTAMP DEFAULT TO_TIMESTAMP(0)
);

CREATE UNIQUE INDEX team_name_owner_idx on t_team(team_name_owner);

CREATE OR REPLACE FUNCTION fn_upd_ts_team() RETURNS TRIGGER AS
$$
DECLARE
BEGIN
  RAISE NOTICE 'fn_upd_ts_team';
  NEW.date_updated := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS tr_upd_ts_team on t_team;
CREATE TRIGGER tr_upd_ts_team BEFORE UPDATE ON t_team FOR EACH ROW EXECUTE PROCEDURE fn_upd_ts_team();

CREATE OR REPLACE FUNCTION fn_ins_ts_team() RETURNS TRIGGER AS
$$
BEGIN
  RAISE NOTICE 'fn_ins_ts_team';
  NEW.date_added := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS tr_ins_ts_team on t_team;
CREATE TRIGGER tr_ins_ts_team BEFORE INSERT ON t_team FOR EACH ROW EXECUTE PROCEDURE fn_ins_ts_team();


INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Arizona', 'Cardinals', 'NFC', 'ARI');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Atlanta','Falcons', 'NFC', 'ATL');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Baltimore','Ravens', 'AFC', 'BAL');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Buffalo','Bills', 'AFC', 'BUF');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Carolina','Panthers', 'NFC', 'CAR');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Chicago','Bears', 'NFC', 'CHI');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Cincinnati','Bengals', 'AFC', 'CIN');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Cleveland','Browns', 'AFC','CLE');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Dallas','Cowboys', 'NFC', 'DAL');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Denver','Broncos', 'AFC', 'DEN');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Detroit','Lions', 'NFC', 'DET');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Green Bay','Packers', 'NFC', 'GB');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Houston','Texans', 'AFC', 'HOU');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Indianapolis','Colts', 'AFC', 'IND');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Jacksonville','Jaguars', 'AFC', 'JAX');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Kansas City','Chiefs', 'AFC','KC');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Los Angeles','Chargers', 'AFC', 'LAC');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Los Angeles','Rams', 'NFC', 'LAR');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Miami','Dolphins', 'AFC', 'MIA');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Minnesota','Vikings', 'NFC','MIN');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('New England','Patriots', 'AFC','NE');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('New Orleans','Saints', 'NFC','NO');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('New York','Giants', 'NFC', 'NYG');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('New York','Jets', 'AFC','NYJ');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Oakland','Raiders', 'AFC','OAK');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Philadelphia','Eagles', 'NFC','PHI');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Pittsburgh','Steelers', 'AFC','PIT');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('San Francisco','49ers', 'NFC','SF');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Seattle','Seahawks', 'NFC','SEA');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Tampa Bay','Buccaneers', 'NFC','TB');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Tennessee','Titans', 'AFC','TEN');
INSERT into t_team(team_location, team_name, team_league,team_short_name) VALUES('Washington','Redskins', 'NFC', 'WSH');

--ARI ATL BAL BUF CAR CHI CIN CLE DAL DEN DET GB HOU IND JAX KC LAR LAC MIA MIN NE NO NYG NYJ OAK PHI PIT SF SEA TB TEN WSH

CREATE SEQUENCE t_game_game_id_seq start with 1001;

DROP TABLE IF EXISTS t_game;
CREATE TABLE IF NOT EXISTS t_game (
  team1 CHAR(4),
  team1_score INTEGER,
  team2 CHAR(4),
  team2_score INTEGER,
  game_id INTEGER DEFAULT nextval('t_game_game_id_seq') NOT NULL,
  date_updated TIMESTAMP DEFAULT TO_TIMESTAMP(0),
  date_added TIMESTAMP DEFAULT TO_TIMESTAMP(0)
);

--ALTER TABLE t_game ADD CONSTRAINT game_constraint UNIQUE (team_name_owner, game_date, description, category, amount, notes);

CREATE UNIQUE INDEX guid_idx ON t_game(guid);

CREATE OR REPLACE FUNCTION fn_ins_ts_game() RETURNS TRIGGER AS
$$
DECLARE
BEGIN
  RAISE NOTICE 'fn_ins_ts_game';
  NEW.date_added := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS tr_ins_ts_games on t_game;
CREATE TRIGGER tr_ins_ts_games BEFORE INSERT ON t_game FOR EACH ROW EXECUTE PROCEDURE fn_ins_ts_game();

CREATE OR REPLACE FUNCTION fn_upd_ts_game() RETURNS TRIGGER AS
$$
DECLARE
BEGIN
  RAISE NOTICE 'fn_upd_ts_game';
  NEW.date_updated := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS tr_upd_ts_games on t_game;
CREATE TRIGGER tr_upd_ts_games BEFORE UPDATE ON t_game FOR EACH ROW EXECUTE PROCEDURE fn_upd_ts_game();

select conrelid::regclass AS table_from, conname, pg_get_constraintdef(c.oid) from pg_constraint c join pg_namespace n ON n.oid = c.connamespace where  contype in ('f', 'p','c','u') order by contype;

