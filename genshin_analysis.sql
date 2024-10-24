-- Data Source: Kaggle (https://www.kaggle.com/datasets/sophiahealy/genshin-impact-character-data)
-- Note: This dataset is up until Version 4.2 (released on 08-Nov-2023), with Furina and Charlotte being the latest characters added. As of June 2024, Genshin Impact has been running until Version 4.7.
-- ** Code that will be used for visualisation

-- View all information in the database(genshin)
SELECT * 
FROM PortfolioProject..genshin

-- LIST OF ELEMENTS ("vision") AVAILABLE & CHARACTERS
-- Show the total of characters, their vision and their origin region**
SELECT region, character_name, vision
FROM PortfolioProject..genshin
GROUP BY region, character_name, vision
ORDER BY region

-- Show the number of characters in each region**
SELECT region, COUNT(region) AS character_count
FROM PortfolioProject..genshin
GROUP BY region
ORDER BY character_count DESC

-- Detail view of the characters which have no information/NA on region**
SELECT vision, region, character_name
FROM PortfolioProject..genshin
WHERE region = 'NA'

-- Show total number of characters in every vision/element
SELECT vision, COUNT(vision) AS character_count
FROM PortfolioProject..genshin
WHERE region != 'NA'
GROUP BY vision
ORDER BY character_count DESC
 
-- Shows the breakdown of each character's element and their origin location
SELECT vision, region, COUNT(region) AS character_count_per_region, STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
WHERE region != 'NA'
GROUP BY vision, region
ORDER BY region, vision


--- CHARACTERS AS PER THEIR ELEMENTS, WEAPON_TYPE & REGION
-- List of Anemo characters
SELECT region, weapon_type, STRING_AGG(character_name, ', ') as characters, COUNT(DISTINCT character_name) AS number_of_characters
FROM PortfolioProject..genshin
WHERE vision = 'Anemo' AND region != 'NA'
GROUP BY region, weapon_type
ORDER BY region

-- List of Cryo characters
SELECT region, weapon_type, STRING_AGG(character_name, ', ') as characters, COUNT(DISTINCT character_name) AS number_of_characters
FROM PortfolioProject..genshin
WHERE vision = 'Cryo' AND region != 'NA'
GROUP BY region, weapon_type
ORDER BY region

-- List of Dendro characters
SELECT region, weapon_type, STRING_AGG(character_name, ', ') as characters, COUNT(DISTINCT character_name) AS number_of_characters
FROM PortfolioProject..genshin
WHERE vision = 'Dendro' AND region != 'NA'
GROUP BY region, weapon_type
ORDER BY region

-- List of Electro characters
SELECT region, weapon_type, STRING_AGG(character_name, ', ') as characters, COUNT(DISTINCT character_name) AS number_of_characters
FROM PortfolioProject..genshin
WHERE vision = 'Electro' AND region != 'NA'
GROUP BY region, weapon_type
ORDER BY region

-- List of Geo characters
SELECT region, weapon_type, STRING_AGG(character_name, ', ') as characters, COUNT(DISTINCT character_name) AS number_of_characters
FROM PortfolioProject..genshin
WHERE vision = 'Geo' AND region != 'NA'
GROUP BY region, weapon_type
ORDER BY region

-- List of Hydro characters
SELECT region, weapon_type, STRING_AGG(character_name, ', ') as characters, COUNT(DISTINCT character_name) AS number_of_characters
FROM PortfolioProject..genshin
WHERE vision = 'Hydro' AND region != 'NA'
GROUP BY region, weapon_type
ORDER BY region

-- List of Pyro characters
SELECT region, weapon_type, STRING_AGG(character_name, ', ') as characters, COUNT(DISTINCT character_name) AS number_of_characters
FROM PortfolioProject..genshin
WHERE vision = 'Pyro' AND region != 'NA'
GROUP BY region, weapon_type
ORDER BY region

-- LIST OF WEAPON & CHARACTERS
-- Show the number of characters used each of the weapon**
SELECT weapon_type, COUNT(weapon_type) AS number_of_characters
FROM PortfolioProject..genshin
WHERE region != 'NA'
GROUP BY weapon_type
ORDER BY number_of_characters DESC

-- Shows the breakdown of characters and their types of weapon**
SELECT weapon_type, vision, COUNT(weapon_type) AS weapon_count, STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
WHERE region != 'NA'
GROUP BY weapon_type, vision
ORDER BY weapon_type DESC

-- Shows character with the highest weapon used in Genshin**
SELECT weapon_type, COUNT(weapon_type) AS weapon_count, STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
WHERE region != 'NA'
GROUP BY weapon_type
ORDER BY weapon_type DESC

-- MOST FREQUENT MODEL TYPE USED FOR CHARACTERS
-- Show how many types of model available in Genshin
SELECT DISTINCT model
FROM PortfolioProject..genshin

-- Show the most frequent model type used for Genshin Impact characters**
SELECT model, COUNT(model) AS model_type_count
FROM PortfolioProject..genshin
WHERE region != 'NA'
GROUP BY model
ORDER BY model_type_count DESC

-- Add column for gender to analyse the characters' gender
ALTER TABLE PortfolioProject..genshin
ADD gender nvarchar(50);

-- Fill in data in the new column
UPDATE PortfolioProject..genshin
	SET gender = CASE
	WHEN model = 'Medium Female' THEN 'Female'
	WHEN model = 'Medium Male' THEN	'Male'
	WHEN model = 'Short Female' THEN  'Female'
	WHEN model = 'Tall Female' THEN 'Female'
	WHEN model = 'Tall Male' THEN 'Male'
	ELSE gender
END
WHERE model IN (
	'Medium Female',
	'Medium Male',
	'Short Female',
	'Tall Female',
	'Tall Male'
);

-- Show gender for all of the characters**
SELECT gender, COUNT(gender) AS gender_count
FROM PortfolioProject..genshin
WHERE region != 'NA'
GROUP BY gender

-- Character Rarity according to gender **
SELECT gender, rarity, COUNT(rarity) AS character_count
FROM PortfolioProject..genshin
WHERE region != 'NA'
GROUP BY rarity, gender
ORDER BY rarity, character_count DESC

-- Breakdown of character rarity according to gender**
SELECT character_name, vision, gender, rarity
FROM PortfolioProject..genshin
WHERE region != 'NA'
GROUP BY rarity, gender, character_name, vision
ORDER BY vision

-- [Additional] Analysis on the 'arkhe' column
-- Show which characters can use Arkhe. Result: Most of the characters can't use Arkhe
SELECT arkhe, COUNT(arkhe) AS characters_count
FROM PortfolioProject..genshin
GROUP BY arkhe

-- Details of characters who can use Arkhe
SELECT arkhe, COUNT(arkhe) AS characters_count, region, STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
WHERE arkhe != 'N/A' AND region != 'NA'
GROUP BY arkhe, region

-- [Additional] Analysis on the 'birthday' column
-- Check if there is any characters in genshin share same birthday. Result: Only Klee and Kuki Shinobu shared same birthday on random basis. The rest are twins
SELECT birthday, COUNT(birthday) AS character_count, STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
GROUP by birthday
HAVING COUNT(birthday) > 1

-- [Additional] Analysis on the 'affiliation' column
-- Show how many affliation in Genshin
SELECT DISTINCT affiliation
FROM PortfolioProject..genshin

-- Show the affiliation with the highest member_count in Genshin. However, the first code shows "None" as the highest member count. 
-- This is incorrect as Traveler who has different elements were counted multiple times.
SELECT affiliation, COUNT(affiliation) AS member_count, STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
GROUP by affiliation
ORDER BY member_count DESC

-- Removing 'Traveler' to get more accurate analysis
SELECT region, affiliation, COUNT(affiliation) AS member_count, STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
WHERE character_name NOT LIKE 'Traveler%'
GROUP by affiliation, region
HAVING COUNT(affiliation) > 1
ORDER BY member_count DESC


-- ASCENSION MATERIALS
-- Rename the column 'ascension_boss' to 'char_levelup_material'
EXEC sp_rename 'dbo.genshin.ascension_boss', 'char_levelup_material', 'COLUMN';

-- Show the total items in 'char_levelup_material' column
SELECT DISTINCT char_levelup_material
FROM PortfolioProject..genshin

-- Add a new column for 'ascension_boss'
ALTER TABLE PortfolioProject..genshin
ADD ascension_boss nvarchar(100); 

-- Fill in data in the new column
UPDATE PortfolioProject..genshin
	SET ascension_boss = CASE
	WHEN char_levelup_material = '"Tourbillon Device"' THEN 'Prototype Cal. Breguet'
	WHEN char_levelup_material = 'Artificed Spare Clockwork Component - Coppelia' THEN 'Icewind Suite'
	WHEN char_levelup_material = 'Artificed Spare Clockwork Component - Coppelius' THEN 'Icewind Suite'
	WHEN char_levelup_material = 'Basalt Pillar' THEN 'Geo Hypostasis'
	WHEN char_levelup_material = 'Cleansing Heart' THEN 'Rhodeia of Loch'
	WHEN char_levelup_material = 'Crystalline Bloom' THEN 'Cryo Hypostasis'
	WHEN char_levelup_material = 'Dew of Repudation' THEN 'Hydro Hypostasis'
	WHEN char_levelup_material = 'Dragonheir''s False Fin' THEN 'Coral Defenders'
	WHEN char_levelup_material = 'Emperor''s Resolution' THEN 'Emperor of Fire and Iron'
	WHEN char_levelup_material = 'Everflame Seed' THEN 'Pyro Regisvine'
	WHEN char_levelup_material = 'Evergloom Ring' THEN 'Iniquitous Baptist'
	WHEN char_levelup_material = 'Fontemer Unihorn' THEN 'Millennial Pearl Seahorse'
	WHEN char_levelup_material = 'Hoarfrost Core' THEN 'Electro Hypostasis'
	WHEN char_levelup_material = 'Hurricane Seed' THEN 'Anemo Hypostasis'
	WHEN char_levelup_material = 'Juvenile Jade' THEN 'Primo Geovishap'
	WHEN char_levelup_material = 'Light Guiding Tetrahedron' THEN 'Algorithm of Semi-Intransient Matrix of Overseer Network'
	WHEN char_levelup_material = 'Lightning Prism' THEN 'Electro Hypostasis'
	WHEN char_levelup_material = 'Majestic Hooked Beak' THEN 'Jadeplume Terrorshroom'
	WHEN char_levelup_material = 'Marionette Core' THEN 'Maguu Kenki'
	WHEN char_levelup_material = 'None' THEN 'None'
	WHEN char_levelup_material = 'Perpetual Caliber' THEN 'Aeonblight Drake'
	WHEN char_levelup_material = 'Perpetual Heart' THEN 'Perpetual Mechanical Array'
	WHEN char_levelup_material = 'Pseudo-Stamens' THEN 'Setekh Wenut'
	WHEN char_levelup_material = 'Quelled Creeper' THEN 'Dendro Hypostasis'
	WHEN char_levelup_material = 'Riftborn Regalia' THEN 'Golden Wolflord'
	WHEN char_levelup_material = 'Runic Fang' THEN 'Ruin Serpent'
	WHEN char_levelup_material = 'Smoldering Pearl' THEN 'Pyro Hypostasis'
	WHEN char_levelup_material = 'Storm Beads' THEN 'Thunder Manifestation'
	WHEN char_levelup_material = 'Thunderclap Fruitcore' THEN 'Electro Regisvine'
	WHEN char_levelup_material = 'Water That Failed To Transcend' THEN 'Hydro Tulpa'
	ELSE ascension_boss 
END
WHERE char_levelup_material IN (
	'"Tourbillon Device"',
	'Artificed Spare Clockwork Component - Coppelia',
	'Artificed Spare Clockwork Component - Coppelius',
	'Basalt Pillar',
	'Cleansing Heart',
	'Crystalline Bloom',
	'Dew of Repudation',
	'Dragonheir''s False Fin',
	'Emperor''s Resolution',
	'Everflame Seed',
	'Evergloom Ring',
	'Fontemer Unihorn',
	'Hoarfrost Core',
	'Hurricane Seed',
	'Juvenile Jade',
	'Light Guiding Tetrahedron',
	'Lightning Prism',
	'Majestic Hooked Beak',
	'Marionette Core',
	'None',
	'Perpetual Caliber',
	'Perpetual Heart',
	'Pseudo-Stamens',
	'Quelled Creeper',
	'Riftborn Regalia',
	'Runic Fang',
	'Smoldering Pearl',
	'Storm Beads',
	'Thunderclap Fruitcore',
	'Water That Failed To Transcend'
);

-- Character Level-Up materials for characters in Genshin, except for Traveler
SELECT ascension_boss, char_levelup_material, COUNT(ascension_boss) AS characters_count, STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
WHERE character_name NOT LIKE 'Traveler%'
GROUP BY ascension_boss, char_levelup_material
ORDER BY characters_count DESC, ascension_boss

-- Character Level-Up materials only for Traveler
SELECT ascension_boss, char_levelup_material, COUNT(ascension_boss) AS characters_count, STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
WHERE character_name LIKE 'Traveler%'
GROUP BY ascension_boss, char_levelup_material
ORDER BY characters_count DESC, ascension_boss

-- WEEKLY BOSS 
-- To check how many items in the 'talent_weekly' column
SELECT DISTINCT talent_weekly
FROM PortfolioProject..genshin

-- Add a new column for 'weekly_boss'
ALTER TABLE PortfolioProject..genshin
ADD weekly_boss nvarchar(100);

UPDATE PortfolioProject..genshin
	SET weekly_boss = CASE
	WHEN talent_weekly = 'Ashen Heart' THEN 'La Signora'
	WHEN talent_weekly = 'Bloodjade Branch' THEN 'Azhdaha'
	WHEN talent_weekly = 'Daka''s Bell' THEN 'Everlasting Lord of Arcane Wisdom'
	WHEN talent_weekly = 'Dragon Lord''s Crown' THEN 'Azhdaha'
	WHEN talent_weekly = 'Dvalin''s Claw' THEN 'Stormterror Dvalin'
	WHEN talent_weekly = 'Dvalin''s Plume' THEN 'Stormterror Dvalin'
	WHEN talent_weekly = 'Dvalin''s Sigh' THEN 'Stormterror Dvalin'
	WHEN talent_weekly = 'Everamber' THEN 'Guardian of Apep''s Oasis'
	WHEN talent_weekly = 'Gilded Scale' THEN 'Azhdaha'
	WHEN talent_weekly = 'Hellfire Butterfly' THEN 'La Signora'
	WHEN talent_weekly = 'Lightless Mass' THEN 'All-Devouring Narwhal'
	WHEN talent_weekly = 'Lightless Silk String' THEN 'All-Devouring Narwhal'
	WHEN talent_weekly = 'Mirror of Mushin' THEN 'Everlasting Lord of Arcane Wisdom'
	WHEN talent_weekly = 'Molten Moment' THEN 'La Signora'
	WHEN talent_weekly = 'Mudra of the Malefic General' THEN 'Magatsu Mitake Narukami no Mikoto'
	WHEN talent_weekly = 'Primordial Greenbloom' THEN 'Guardian of Apep''s Oasis'
	WHEN talent_weekly = 'Puppet Strings' THEN 'Everlasting Lord of Arcane Wisdom'
	WHEN talent_weekly = 'Ring of Boreas' THEN 'Andrius'
	WHEN talent_weekly = 'Shadow of the Warrior' THEN 'Childe'
	WHEN talent_weekly = 'Shard of a Foul Legacy' THEN 'Childe'
	WHEN talent_weekly = 'Spirit Locket of Boreas' THEN 'Andrius'
	WHEN talent_weekly = 'Tail of Boreas' THEN 'Andrius'
	WHEN talent_weekly = 'Tears of the Calamitous God' THEN 'Magatsu Mitake Narukami no Mikoto'
	WHEN talent_weekly = 'The Meaning of Aeons' THEN 'Magatsu Mitake Narukami no Mikoto'
	WHEN talent_weekly = 'Tusk of Monoceros Caeli' THEN 'Childe'
	WHEN talent_weekly = 'Worldspan Fern' THEN 'Guardian of Apep''s Oasis'
	ELSE weekly_boss
END
WHERE talent_weekly IN (
	'Ashen Heart',
	'Bloodjade Branch',
	'Daka''s Bell',
	'Dragon Lord''s Crown',
	'Dvalin''s Claw',
	'Dvalin''s Plume',
	'Dvalin''s Sigh',
	'Everamber',
	'Gilded Scale',
	'Hellfire Butterfly',
	'Lightless Mass',
	'Lightless Silk String',
	'Mirror of Mushin',
	'Molten Moment',
	'Mudra of the Malefic General',
	'Primordial Greenbloom',
	'Puppet Strings',
	'Ring of Boreas',
	'Shadow of the Warrior',
	'Shard of a Foul Legacy',
	'Spirit Locket of Boreas',
	'Tail of Boreas',
	'Tears of the Calamitous God',
	'The Meaning of Aeons',
	'Tusk of Monoceros Caeli',
	'Worldspan Fern'
);

-- Weekly boss for characters in Genshin, except for Traveler
SELECT weekly_boss, talent_weekly, COUNT(weekly_boss) AS character_count, STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
WHERE character_name NOT LIKE 'Traveler%'
GROUP BY weekly_boss, talent_weekly
ORDER BY character_count DESC, weekly_boss

-- Weekly boss ONLY FOR Traveler
SELECT weekly_boss, talent_weekly, COUNT(weekly_boss) AS character_count, STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
WHERE character_name LIKE 'Traveler%'
GROUP BY weekly_boss, talent_weekly
ORDER BY character_count DESC

-- HP,ATK,DEF (For Characters Level 90)**
--Highest HP
SELECT TOP 10 hp_90_90, atk_90_90, def_90_90, vision,STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
GROUP BY hp_90_90, atk_90_90, def_90_90, vision
ORDER BY hp_90_90 DESC
--ORDER BY atk_90_90 DESC
--ORDER BY def_90_90 DESC

--Highest Attack
SELECT TOP 10 hp_90_90, atk_90_90, def_90_90, vision,STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
GROUP BY hp_90_90, atk_90_90, def_90_90, vision
--ORDER BY hp_90_90 DESC
ORDER BY atk_90_90 DESC
--ORDER BY def_90_90 DESC

--Highest Defense
SELECT TOP 10 hp_90_90, atk_90_90, def_90_90, vision,STRING_AGG(character_name, ', ') AS characters
FROM PortfolioProject..genshin
GROUP BY hp_90_90, atk_90_90, def_90_90, vision
--ORDER BY hp_90_90 DESC
--ORDER BY atk_90_90 DESC
ORDER BY def_90_90 DESC

SELECT hp_90_90, atk_90_90, def_90_90, vision, character_name, region
FROM PortfolioProject..genshin
WHERE region != 'NA'

