CREATE TABLE AquaCrestParameters (
	Yield TEXT NOT NULL,
	Amount INTEGER NOT NULL
);

INSERT INTO AquaCrestParameters (Yield, Amount)
VALUES	('CULTURE', 1), ('SCIENCE', 1), ('PRODUCTION', 1),
		('CULTURE', 2), ('SCIENCE', 2), ('PRODUCTION', 2),
		('CULTURE', 3), ('SCIENCE', 3), ('PRODUCTION', 3);

INSERT INTO TraitModifiers (TraitType, ModifierId)							--"ModifierId" = "AQUA_CREST_<type>_YIELD_#"
SELECT 'TRAIT_LEADER_AQUA_CREST', 'AQUA_CREST_' || Yield || '_' || Amount
FROM	AquaCrestParameters;

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)	--"ModifierType" = "MODIFIER_PLAYER_ADJUST_PLOT_YIELD"
SELECT	ModifierId, 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 'PLOT_HAS_' || ModifierId
FROM	TraitModifiers
WHERE	ModifierId LIKE 'AQUA_CREST_%';

INSERT INTO ModifierArguments (ModifierId, Name, Value)						--"YieldType" = "YIELD_<type>"
SELECT	'AQUA_CREST_' || Yield || '_' || Amount, 'YieldType', 'YIELD_' || Yield
FROM	AquaCrestParameters;

INSERT INTO ModifierArguments (ModifierId, Name, Value)						--"Amount" = 1
SELECT	ModifierId, 'Amount', 1
FROM	Modifiers
WHERE	ModifierId LIKE 'AQUA_CREST_%';

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)			--"RequirementSetId" = "PLOT_HAS_AQUA_CREST_<type>_#"
SELECT	SubjectRequirementSetId, 'REQUIREMENTSET_TEST_ALL'
FROM	Modifiers
WHERE	SubjectRequirementSetId LIKE 'PLOT_HAS_AQUA_CREST_%';

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)	--"RequirementId" 1 = "REQUIRES_PLOT_HAS_AQUA_CREST_ENABLED"
SELECT	SubjectRequirementSetId, 'REQUIRES_PLOT_HAS_AQUA_CREST_ENABLED'
FROM	Modifiers
WHERE	SubjectRequirementSetId LIKE 'PLOT_HAS_AQUA_CREST_%';

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)	--"RequirementId" 2 = "REQUIRES_PLOT_HAS_AQUA_CREST_<type>_#"
SELECT	SubjectRequirementSetId, 'REQUIRES_' || SubjectRequirementSetId
FROM	Modifiers
WHERE	SubjectRequirementSetId LIKE 'PLOT_HAS_AQUA_CREST_%';

INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)			--"RequirementType" = "REQUIREMENT_PLOT_PROPERTY_MATCHES"
SELECT	RequirementId, 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
FROM	RequirementSetRequirements
WHERE	RequirementId LIKE 'REQUIRES_PLOT_HAS_AQUA_CREST_%';

INSERT INTO RequirementArguments (RequirementId, Name, Value)
VALUES	('REQUIRES_PLOT_HAS_AQUA_CREST_ENABLED', 'PropertyName', 'PROPERTY_AQUA_CREST'),
		('REQUIRES_PLOT_HAS_AQUA_CREST_ENABLED', 'PropertyMinimum', 1);

INSERT INTO RequirementArguments (RequirementId, Name, Value)				--"PropertyName" = "PROPERTY_AQUA_CREST_<type>"
SELECT	'REQUIRES_PLOT_HAS_AQUA_CREST_' || Yield || '_' || Amount,
		'PropertyName', 'PROPERTY_AQUA_CREST_' || Yield
FROM	AquaCrestParameters;

INSERT INTO RequirementArguments (RequirementId, Name, Value)				--"PropertyMinimum" = #
SELECT	'REQUIRES_PLOT_HAS_AQUA_CREST_' || Yield || '_' || Amount,
		'PropertyMinimum', Amount
FROM	AquaCrestParameters;

DROP TABLE AquaCrestParameters;

--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE AquaFlockParameters (
	Yield TEXT,
	Stack INTEGER NOT NULL
);

INSERT INTO AquaFlockParameters (Stack)
VALUES	( 1),( 2),( 3),( 4),( 5),( 6),( 7),( 8),( 9),(10),
		(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
		(21),(22),(23),(24),(25),(26),(27),(28),(29),(30);

UPDATE AquaFlockParameters SET Yield = 'CULTURE';

INSERT INTO AquaFlockParameters (Yield, Stack)
SELECT	'SCIENCE', Stack
FROM	AquaFlockParameters
WHERE	Yield = 'CULTURE';

INSERT INTO AquaFlockParameters (Yield, Stack)
SELECT	'PRODUCTION', Stack
FROM	AquaFlockParameters
WHERE	Yield = 'CULTURE';

INSERT INTO TraitModifiers (TraitType, ModifierId)							--"ModifierId" = "AQUA_FLOCK_ADJUST_CITY_<type>_#"
SELECT 'TRAIT_LEADER_SUMMER_AQUA_FLOCK', 'AQUA_FLOCK_ADJUST_CITY_' || Yield || Stack
FROM	AquaFlockParameters;

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)	--"ModifierType" = "MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER"
SELECT	'AQUA_FLOCK_ADJUST_CITY_' || Yield || Stack,
		'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'CITY_HAS_AQUA_FLOCK_STACK_' || Stack
FROM	AquaFlockParameters;

INSERT INTO Modifiers (ModifierId, ModifierType)							--"ModifierType" = "MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER"
SELECT	'AQUA_FLOCK_ADJUST_CITY_' || Yield || '_MODIFIER',
		'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER'
FROM	AquaFlockParameters
WHERE	Stack = 1;

INSERT INTO ModifierArguments (ModifierId, Name, Value)						--"ModifierId" = "AQUA_FLOCK_ADJUST_CITY_<type>_MODIFIER"
SELECT	'AQUA_FLOCK_ADJUST_CITY_' || Yield || Stack,
		'ModifierId', 'AQUA_FLOCK_ADJUST_CITY_' || Yield || '_MODIFIER'
FROM	AquaFlockParameters;

INSERT INTO ModifierArguments (ModifierId, Name, Value)						--"YieldType" = "YIELD_<type>"
SELECT	'AQUA_FLOCK_ADJUST_CITY_' || Yield || '_MODIFIER',
		'YieldType', 'YIELD_' || Yield
FROM	AquaFlockParameters
WHERE	Stack = 1;

INSERT INTO ModifierArguments (ModifierId, Name, Value)						--"Amount" = 3
SELECT	'AQUA_FLOCK_ADJUST_CITY_' || Yield || '_MODIFIER', 'Amount', 3
FROM	AquaFlockParameters
WHERE	Stack = 1;

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)			--"RequirementSetId" = "CITY_HAS_AQUA_FLOCK_STACK_#"
SELECT	'CITY_HAS_AQUA_FLOCK_STACK_' || Stack, 'REQUIREMENTSET_TEST_ALL'
FROM	AquaFlockParameters
WHERE	Yield = 'CULTURE';

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)	--"RequirementId" = "REQUIRES_AQUA_FLOCK_STACK_#"
SELECT	'CITY_HAS_AQUA_FLOCK_STACK_' || Stack, 'REQUIRES_AQUA_FLOCK_STACK_' || Stack
FROM	AquaFlockParameters
WHERE	Yield = 'CULTURE';

INSERT INTO Requirements (RequirementId, RequirementType)					--"RequirementType" = "REQUIREMENT_PLOT_PROPERTY_MATCHES"
SELECT	RequirementId, 'REQUIREMENT_PLOT_PROPERTY_MATCHES'
FROM	RequirementSetRequirements
WHERE	RequirementId LIKE 'REQUIRES_AQUA_FLOCK_STACK_%';

INSERT INTO RequirementArguments (RequirementId, Name, Value)				--"PropertyName" = "PROPERTY_AQUA_FLOCK_STACK"
SELECT	RequirementId, 'PropertyName', 'PROPERTY_AQUA_FLOCK_STACK'
FROM	RequirementSetRequirements
WHERE	RequirementId LIKE 'REQUIRES_AQUA_FLOCK_STACK_%';

INSERT INTO RequirementArguments (RequirementId, Name, Value)				--"PropertyMinimum" = #
SELECT	'REQUIRES_AQUA_FLOCK_STACK_' || Stack, 'PropertyMinimum', Stack
FROM	AquaFlockParameters
WHERE	Yield = 'CULTURE';

DROP TABLE AquaFlockParameters;

--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE AquaFlock_UnitTags(
	Tag TEXT NOT NULL,
	Attacker BOOLEAN NOT NULL
);

INSERT INTO AquaFlock_UnitTags (Tag, Attacker)
VALUES	('CLASS_RECON',0),			('CLASS_MELEE',0),			('CLASS_RANGED',1),			('CLASS_SIEGE',0),
		('CLASS_HEAVY_CAVALRY',0),	('CLASS_LIGHT_CAVALRY',0),	('CLASS_RANGED_CAVALRY',0),	('CLASS_ANTI_CAVALRY',0),
		('CLASS_HEAVY_CHARIOT',0),	('CLASS_LIGHT_CHARIOT',0),	('CLASS_NAVAL_MELEE',0),	('CLASS_NAVAL_RANGED',0),
		('CLASS_NAVAL_RAIDER',0),	('CLASS_NAVAL_CARRIER',0),	('CLASS_WARRIOR_MONK',0),	('CLASS_AIRCRAFT',0);

INSERT INTO TypeTags (Type, Tag)
SELECT 'ABILITY_AQUA_FLOCK', Tag
FROM	AquaFlock_UnitTags WHERE Attacker = 1;

INSERT INTO TypeTags (Type, Tag)
SELECT	'ABILITY_AQUA_FLOCK_DEBUFF', Tag
FROM	AquaFlock_UnitTags;

INSERT INTO TypeTags (Type, Tag)
SELECT	'ABILITY_AQUA_FLOCK_COUNTER', Tag
FROM	AquaFlock_UnitTags;

DROP TABLE AquaFlock_UnitTags;