INSERT INTO LocalizedText (Language, Tag, Text) VALUES
/*('en_US', 'LOC_TRAIT_LEADER_AURORA_SANCTUARY_DESCRIPTION', 'Placeholder'),
('en_US', 'LOC_TRAIT_CIVILIZATION_LANDSOL_KOKKORO_PRINCESS_DESCRIPTION', 'Placeholder'),*/
('zh_Hans_CN', 'LOC_TRAIT_LEADER_AURORA_SANCTUARY_DESCRIPTION', '建设于冻土、雪地、冻土丘陵、雪地丘陵的城市+1魅力，在解锁“保护地球”市政后再额外+1魅力。图书馆、古罗马剧场、市场、神社、工坊、灯塔为本城市魅力为“迷人”的未改良单元格+1相应产出，魅力为“惊艳”的单元格加成翻倍。单位若位于魅力为“迷人”的单元格，每回合可多恢复5点生命值，位于魅力为“惊艳”的单元格时加成翻倍。'),
('zh_Hans_CN', 'LOC_TRAIT_CIVILIZATION_LANDSOL_KOKKORO_PRINCESS_DESCRIPTION', '为可可萝（公主）增加一个额外的领袖特性“{LOC_TRAIT_LEADER_AURORA_SANCTUARY_NAME}”：{LOC_TRAIT_LEADER_AURORA_SANCTUARY_DESCRIPTION}');
	

UPDATE LocalizedText SET Text = '只用一半时间即可建成保护区。保护区建筑的效果延伸到本城市的所有未改良单元格。建设于冻土、雪地、冻土丘陵、雪地丘陵的城市+1魅力，在解锁“保护地球”市政后再额外+1魅力。单位若位于魅力为“迷人”的单元格，每回合可多恢复5点生命值，位于魅力为“惊艳”的单元格时则该项加成翻倍。' WHERE EXISTS (SELECT * FROM LocalizedText WHERE Tag = 'LOC_CIVILIZATION_VIETNAM_NAME') AND Tag = 'LOC_TRAIT_LEADER_AURORA_SANCTUARY_DESCRIPTION' AND Language = 'zh_Hans_CN';

UPDATE LocalizedText SET Text = '为可可萝（公主）增加一个额外的领袖特性“{LOC_TRAIT_LEADER_AURORA_SANCTUARY_NAME}”：{LOC_TRAIT_LEADER_AURORA_SANCTUARY_DESCRIPTION}' WHERE EXISTS (SELECT * FROM LocalizedText WHERE Tag = 'LOC_CIVILIZATION_VIETNAM_NAME') AND Tag = 'LOC_TRAIT_CIVILIZATION_LANDSOL_KOKKORO_PRINCESS_DESCRIPTION' AND Language = 'zh_Hans_CN';