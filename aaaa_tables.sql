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


INSERT into t_team(team_location, team_name, team_league) VALUES('Arizona', 'Cardinals', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Atlanta','Falcons', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Baltimore','Ravens', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Buffalo','Bills', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Carolina','Panthers', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Chicago','Bears', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Cincinnati','Bengals', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Cleveland','Browns', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Dallas','Cowboys', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Denver','Broncos', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Detroit','Lions', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Green Bay','Packers', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Houston','Texans', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Indianapolis','Colts', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Jacksonville','Jaguars', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Kansas City','Chiefs', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Los Angeles','Chargers', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Los Angeles','Rams', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Miami','Dolphins', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Minnesota','Vikings', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('New England','Patriots', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('New Orleans','Saints', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('New York','Giants', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('New York','Jets', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Oakland','Raiders', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Philadelphia','Eagles', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Pittsburgh','Steelers', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('San Francisco','49ers', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Seattle','Seahawks', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Tampa Bay','Buccaneers', 'NFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Tennessee','Titans', 'AFC');
INSERT into t_team(team_location, team_name, team_league) VALUES('Washington','Redskins', 'NFC');

CREATE SEQUENCE t_game_game_id_seq start with 1001;

DROP TABLE IF EXISTS t_game;
CREATE TABLE IF NOT EXISTS t_game (
  team_id INTEGER,
  team_type CHAR(6),
  team_name_owner CHAR(40) NOT NULL,
  game_id INTEGER DEFAULT nextval('t_game_game_id_seq') NOT NULL,
  guid CHAR(36) NOT NULL,
  sha256 CHAR(70),
  game_date DATE NOT NULL,
  description VARCHAR(75) NOT NULL,
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

