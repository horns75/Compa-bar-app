# Compa Bar Home Blender

Starter database and application structure for the Compa Bar home-blender workflow.

## Workflow
Inventory -> Blend Lab -> Barrel Room -> Batch Book -> Tasting Room -> Bottling -> Label / Barrel Passport

## Database
`compa_bar.db` is a working SQLite database.
`schema.sql` contains the schema so it can later be migrated to PostgreSQL/Supabase or another hosted database.

## Core entities
- spirits: source bottles/spirits and available volume
- recipes: blend recipes
- recipe_components: spirits used in each recipe
- barrels: physical barrel records
- barrel_events: fills, samples, transfers and other timeline events
- batches: official Compa Bar batch records
- tasting_notes: sensory history
- bottlings: final bottle runs
- labels: Compa Bar label/neck-tag information

## Important design choice
A blend is a recipe, while a batch is the actual production record. This lets you reuse a recipe while keeping each batch's barrel, tasting and bottling history separate.
