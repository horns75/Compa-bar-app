
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS spirits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'Bourbon',
  proof REAL NOT NULL CHECK(proof >= 0 AND proof <= 200),
  volume_l REAL NOT NULL DEFAULT 0 CHECK(volume_l >= 0),
  source TEXT,
  age_years REAL,
  cost REAL,
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS recipes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  batch_number TEXT,
  target_volume_l REAL,
  final_proof REAL,
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS recipe_components (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recipe_id INTEGER NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  spirit_id INTEGER REFERENCES spirits(id),
  spirit_name TEXT NOT NULL,
  volume_l REAL NOT NULL CHECK(volume_l >= 0),
  proof REAL NOT NULL CHECK(proof >= 0 AND proof <= 200)
);

CREATE TABLE IF NOT EXISTS barrels (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  barrel_number TEXT NOT NULL UNIQUE,
  barrel_type TEXT,
  char_level TEXT,
  spirit_type TEXT,
  fill_volume_l REAL,
  fill_proof REAL,
  fill_date TEXT,
  status TEXT NOT NULL DEFAULT 'Aging',
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS barrel_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  barrel_id INTEGER NOT NULL REFERENCES barrels(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL,
  event_date TEXT NOT NULL,
  volume_l REAL,
  proof REAL,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS batches (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  batch_number TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  recipe_id INTEGER REFERENCES recipes(id),
  barrel_id INTEGER REFERENCES barrels(id),
  blend_date TEXT,
  bottle_date TEXT,
  final_proof REAL,
  final_volume_l REAL,
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tasting_notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  batch_id INTEGER NOT NULL REFERENCES batches(id) ON DELETE CASCADE,
  tasting_date TEXT NOT NULL,
  nose TEXT,
  palate TEXT,
  finish TEXT,
  rating REAL CHECK(rating >= 0 AND rating <= 5),
  notes TEXT
);

CREATE TABLE IF NOT EXISTS bottlings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  batch_id INTEGER NOT NULL REFERENCES batches(id) ON DELETE CASCADE,
  bottle_size_ml INTEGER NOT NULL,
  bottle_count INTEGER NOT NULL DEFAULT 0,
  proof REAL,
  bottling_date TEXT,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS labels (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  batch_id INTEGER NOT NULL REFERENCES batches(id) ON DELETE CASCADE,
  label_name TEXT,
  series TEXT,
  neck_tag_text TEXT,
  front_label_notes TEXT,
  back_label_notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_recipe_components_recipe ON recipe_components(recipe_id);
CREATE INDEX IF NOT EXISTS idx_barrel_events_barrel ON barrel_events(barrel_id);
CREATE INDEX IF NOT EXISTS idx_tasting_batch ON tasting_notes(batch_id);
CREATE INDEX IF NOT EXISTS idx_batches_barrel ON batches(barrel_id);
