-- Get every subjects averages by DP.id
SELECT 
  S.name, 
  ROUND(AVG(GUR.total_score), 2) as 'Average' 
  FROM talentumehs_valle_open_location.towns TOWNS
  JOIN talentumehs_valle_open_location.headquarters HQ
    ON HQ.town_id = TOWNS.id
  JOIN talentumehs_valle_magico.game_users GU
    ON GU.headquarter_id = HQ.id
  JOIN talentumehs_valle_magico.game_user_records GUR 
    ON GUR.game_user_id = GU.id 
  JOIN talentumehs_valle_magico.mini_games MG 
    ON GUR.mini_game_id = MG.id 
    AND GU.grade_id = MG.grade_id 
  JOIN talentumehs_valle_magico.subject_mini_game SMG 
    ON SMG.mini_game_id = MG.id 
  RIGHT JOIN talentumehs_valle_magico.subjects S 
    ON SMG.subject_id = S.id 
  WHERE TOWNS.id = 1
  GROUP BY (S.name) 
  ORDER BY (S.name)

-- Get every intelligence averages by DP.id
SELECT 
  I.name as 'Name',
  ROUND(AVG(GUI.percentage_value), 2) as 'Average'
  FROM talentumehs_valle_open_location.towns TOWNS
  JOIN talentumehs_valle_open_location.headquarters HQ
    ON HQ.town_id = TOWNS.id
  JOIN talentumehs_valle_magico.game_users GU
    ON GU.headquarter_id = HQ.id
  JOIN talentumehs_valle_magico.game_user_records GUR
    ON GUR.game_user_id = GU.id
  JOIN talentumehs_valle_magico.gu_record_intelligence_ind_desc_styles GUI
    ON GUI.game_user_record_id = GUR.id
  RIGHT JOIN talentumehs_valle_magico.intelligence_indicators II
    ON GUI.intelligence_indicator_id = II.id
  RIGHT JOIN talentumehs_valle_magico.intelligences I
    ON II.intelligence_id = I.id
  WHERE TOWNS.id = 1
  GROUP BY (I.id)
  ORDER BY (I.name)

-- Get every style averages by DP.id
SELECT
  GU.id,
  COUNT(GUI.id) as 'total_by_user'
  FROM talentumehs_valle_open_location.towns TOWNS
  JOIN talentumehs_valle_open_location.headquarters HQ
    ON HQ.town_id = TOWNS.id
  JOIN talentumehs_valle_magico.game_users GU
    ON GU.headquarter_id = HQ.id
  JOIN talentumehs_valle_magico.game_user_records GUR
    ON GUR.game_user_id = GU.id
  JOIN talentumehs_valle_magico.gu_record_intelligence_ind_desc_styles GUI
    ON GUI.game_user_record_id = GUR.id
  JOIN talentumehs_valle_magico.description_styles DS
    ON GUI.description_style_id = DS.id
  WHERE TOWNS.id = 1
  GROUP BY (GU.id)

SELECT
  GU.id as 'game_user_id',
  DS.style_id as 'style',
  COUNT(GUI.id) as 'total_by_area'
  FROM talentumehs_valle_open_location.towns TOWNS
  JOIN talentumehs_valle_open_location.headquarters HQ
    ON HQ.town_id = TOWNS.id
  JOIN talentumehs_valle_magico.game_users GU
    ON GU.headquarter_id = HQ.id
  JOIN talentumehs_valle_magico.game_user_records GUR
    ON GUR.game_user_id = GU.id
  JOIN talentumehs_valle_magico.gu_record_intelligence_ind_desc_styles GUI
    ON GUI.game_user_record_id = GUR.id
  JOIN talentumehs_valle_magico.description_styles DS
    ON GUI.description_style_id = DS.id
  WHERE TOWNS.id = 1
  GROUP BY (DS.style_id), (GU.id) 

  
SELECT 
  S.name,
  ROUND(AVG(TSBUS.total_by_area/TSBU.total_by_user), 2) * 100 as 'Average'
  FROM (
    SELECT
      GU.id as 'game_user_id',
      DS.style_id as 'style',
      COUNT(GUI.id) as 'total_by_area'
      FROM talentumehs_valle_open_location.towns TOWNS
      JOIN talentumehs_valle_open_location.headquarters HQ
        ON HQ.town_id = TOWNS.id
      JOIN talentumehs_valle_magico.game_users GU
        ON GU.headquarter_id = HQ.id
      JOIN talentumehs_valle_magico.game_user_records GUR
        ON GUR.game_user_id = GU.id
      JOIN talentumehs_valle_magico.gu_record_intelligence_ind_desc_styles GUI
        ON GUI.game_user_record_id = GUR.id
      JOIN talentumehs_valle_magico.description_styles DS
        ON GUI.description_style_id = DS.id
      WHERE TOWNS.id = 1
      GROUP BY (DS.style_id), (GU.id) 
  ) AS TSBUS
  JOIN (
    SELECT
      GU.id,
      COUNT(GUI.id) as 'total_by_user'
      FROM talentumehs_valle_open_location.towns TOWNS
      JOIN talentumehs_valle_open_location.headquarters HQ
        ON HQ.town_id = TOWNS.id
      JOIN talentumehs_valle_magico.game_users GU
        ON GU.headquarter_id = HQ.id
      JOIN talentumehs_valle_magico.game_user_records GUR
        ON GUR.game_user_id = GU.id
      JOIN talentumehs_valle_magico.gu_record_intelligence_ind_desc_styles GUI
        ON GUI.game_user_record_id = GUR.id
      JOIN talentumehs_valle_magico.description_styles DS
        ON GUI.description_style_id = DS.id
      WHERE TOWNS.id = 1
      GROUP BY (GU.id)
  ) AS TSBU 
    ON TSBUS.game_user_id = TSBU.id
  JOIN talentumehs_valle_magico.styles S
    ON TSBUS.style = S.id
  GROUP BY (TSBUS.style)
  ORDER BY (S.name)