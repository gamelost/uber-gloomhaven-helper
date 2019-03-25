DROP TABLE IF EXISTS monster_deck;
CREATE TABLE monster_deck(
  id INTEGER PRIMARY KEY,
  class TEXT NOT NULL UNIQUE
);

DROP TABLE IF EXISTS macro;
CREATE TABLE macro(
  id INTEGER PRIMARY KEY,
  macro TEXT NOT NULL UNIQUE,
  description TEXT,
  image_path TEXT NOT NULL,
  is_element BOOLEAN DEFAULT false,
  is_area_of_effect BOOLEAN DEFAULT false,
  is_boss BOOLEAN DEFAULT false
);

DROP TABLE IF EXISTS scenario;
CREATE TABLE scenario(
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  number INTEGER NOT NULL UNIQUE,
  image_path TEXT NOT NULL,
  x INTEGER,
  y INTEGER
);

DROP TABLE IF EXISTS scenario_route;
CREATE TABLE scenario_route(
  id INTEGER PRIMARY KEY,
  scenario_source INTEGER NOT NULL,
  scenario_target INTEGER NOT NULL,
  type TEXT CHECK(type IN ('unlocks','links to','blocks','required by')) NOT NULL,
  FOREIGN KEY(scenario_source) REFERENCES scenario(id),
  FOREIGN KEY(scenario_target) REFERENCES scenario(id)
);

DROP TABLE IF EXISTS scenario_treasure;
CREATE TABLE scenario_treasure(
  id INTEGER PRIMARY KEY,
  scenario_id INTEGER NOT NULL,
  treasure_id INTEGER NOT NULL,
  treasure_description TEXT NOT NULL,
  FOREIGN KEY(scenario_id) REFERENCES scenario(id)
);

DROP TABLE IF EXISTS scenario_reference;
CREATE TABLE scenario_reference(
  id INTEGER PRIMARY KEY,
  scenario_id INTEGER NOT NULL,
  reference_page INTEGER NOT NULL,
  FOREIGN KEY(scenario_id) REFERENCES scenario(id)
);

DROP TABLE IF EXISTS monster;
CREATE TABLE monster(
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  deck_id INTEGER NOT NULL,
  number INTEGER NOT NULL,
  FOREIGN KEY(deck_id) REFERENCES monster_deck(id)
);

DROP TABLE IF EXISTS scenario_monster;
CREATE TABLE scenario_monster(
  id INTEGER PRIMARY KEY,
  scenario_id INTEGER NOT NULL,
  monster_id INTEGER NOT NULL,
  FOREIGN KEY(scenario_id) REFERENCES scenario(id),
  FOREIGN KEY(monster_id) REFERENCES monster(id)
);

DROP TABLE IF EXISTS monster_ability;
CREATE TABLE monster_ability(
  card_number INTEGER PRIMARY KEY,
  monster_id INTEGER NOT NULL,
  shuffle BOOLEAN NOT NULL DEFAULT false,
  initiative INTEGER NOT NULL,
  attacks JSON NOT NULL,
  FOREIGN KEY(monster_id) REFERENCES monster(id)
);

DROP TABLE IF EXISTS monster_ability_card;
CREATE TABLE monster_ability_card(
  id INTEGER PRIMARY KEY,
  monster_id INTEGER NOT NULL,
  monster_ability_id INTEGER,
  image_path TEXT NOT NULL,
  image_back BOOLEAN NOT NULL DEFAULT false,
  FOREIGN KEY(monster_id) REFERENCES monster(id),
  FOREIGN KEY(monster_ability_id) REFERENCES monster_ability(card_number)
);

DROP TABLE IF EXISTS monster_stat;
CREATE TABLE monster_stat(
  id INTEGER PRIMARY KEY,
  monster_id INTEGER NOT NULL,
  level INTEGER NOT NULL,
  type TEXT CHECK(type IN ('normal','elite','boss')) NOT NULL,
  health TEXT NOT NULL,
  attack TEXT NOT NULL,
  move INTEGER NOT NULL DEFAULT 0,
  range INTEGER NOT NULL DEFAULT 0,
  monster_attributes JSON,
  boss_special1 JSON,
  boss_special2 JSON,
  boss_immunities JSON,
  FOREIGN KEY(monster_id) REFERENCES monster(id)
);

DROP TABLE IF EXISTS monster_stat_card;
CREATE TABLE monster_stat_card(
  id INTEGER PRIMARY KEY,
  monster_id INTEGER NOT NULL,
  monster_stat_id INTEGER,
  image_path TEXT NOT NULL,
  image_rotation INTEGER,
  image_back BOOLEAN NOT NULL DEFAULT false,
  FOREIGN KEY(monster_id) REFERENCES monster(id),
  FOREIGN KEY(monster_stat_id) REFERENCES monster_stat(id)
);
