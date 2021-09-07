-- This sql script is for getting all of the total played in every town
SELECT TOWN.id,
  TOWN.name,
  COUNT(VMG.id) total_played
FROM talentumehs_valle_open_location.towns TOWN
  JOIN headquarters HQ ON TOWN.id = HQ.town_id
  JOIN talentumehs_valle_magico.game_users GU ON HQ.id = GU.headquarter_id
  LEFT JOIN talentumehs_valle_magico.game_user_records GUR ON GU.id = GUR.game_user_id
  LEFT JOIN (
    SELECT MG.id,
      MG.name,
      MG.grade_id
    FROM talentumehs_valle_magico.mini_games MG
      JOIN talentumehs_valle_magico.subject_mini_game SBM ON MG.id = SBM.mini_game_id
  ) VMG ON GUR.mini_game_id = VMG.id
  AND VMG.grade_id = GU.grade_id
WHERE TOWN.department_id = 1
GROUP BY (TOWN.id)
ORDER BY (TOWN.name)

-- How many headquarters every town has
SELECT
  TOWNS.name as 'Town',
  IT.name as 'Institution',
  COUNT(IT.name) as 'Institution'
  FROM talentumehs_valle_open_location.departments DEP
    JOIN talentumehs_valle_open_location.towns TOWNS
      ON DEP.id = TOWNS.department_id
    JOIN talentumehs_valle_open_location.headquarters HQ
      ON TOWNS.id = HQ.town_id
    JOIN talentumehs_valle_open_location.institutions IT  
      ON HQ.institution_id = IT.id
  WHERE TOWNS.name NOT LIKE '%- DOCENTES'
  GROUP BY (IT.name), (TOWNS.name)  
  ORDER BY TOWNS.name ASC

-- Get every student from every institution in every town of the department
SELECT 
    DEP.name as Department, 
	  HQ.town_id as 'Town ID', 
    TOWNS.name as Town, 
    IT.id as 'Institution ID',
    IT.name as 'Institution',
    HQ.id as 'Headquarter ID',
    HQ.name as Headquarter, 
    GU.first_name as 'First Name', 
    GU.second_name as 'Second Name', 
    GU.first_surname as 'First Surname', 
    GU.second_surname as 'Second Surname', 
    GU.username as 'Username',
    GU.grade_id as 'Grade'
  FROM talentumehs_valle_open_location.departments DEP
    JOIN talentumehs_valle_open_location.towns TOWNS
      ON TOWNS.department_id = DEP.id
    JOIN talentumehs_valle_open_location.headquarters HQ
      ON HQ.town_id = TOWNS.id
    JOIN talentumehs_valle_open_location.institutions IT
      ON IT.id = HQ.institution_id
    JOIN talentumehs_valle_magico.game_users GU
      ON GU.headquarter_id = HQ.id
    WHERE DEP.id = 1
    ORDER BY (IT.name)

-- Get every grade from every headquarter, from every institution, from every town
SELECT 
	TOWNS.name as 'Town', 
    IT.name as 'Institution', 
    HQ.name as 'Headquarter', 
    GU.grade_id as 'Grade' 
    	FROM talentumehs_valle_open_location.departments DEP 
        JOIN talentumehs_valle_open_location.towns TOWNS 
        	ON DEP.id = TOWNS.department_id 
        JOIN talentumehs_valle_open_location.headquarters HQ 
        	ON TOWNS.id = HQ.town_id 
        JOIN talentumehs_valle_open_location.institutions IT 
        	ON HQ.institution_id = IT.id 
        JOIN talentumehs_valle_magico.game_users GU 
        	ON HQ.id = GU.headquarter_id 
        WHERE TOWNS.name NOT LIKE '%- DOCENTES' 
        GROUP BY (TOWNS.name), (IT.name), (HQ.name), (GU.grade_id) 
        ORDER BY (TOWNS.name), (IT.name), (HQ.name), (GU.grade_id) ASC

-- Get every subjects averages by DP.id
SELECT 
  S.name, 
  ROUND(AVG(GUR.total_score), 2) as 'Average' 
  FROM talentumehs_valle_open_location.departments DP 
  JOIN talentumehs_valle_open_location.towns TW 
    ON TW.department_id = DP.id 
  JOIN talentumehs_valle_open_location.headquarters HQ 
    ON HQ.town_id = TW.id 
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
  WHERE DP.id = 1 
  GROUP BY (S.name) 
  ORDER BY (S.name)

-- Get every intelligence averages by DP.id
SELECT
  I.name as 'Name',
  ROUND(AVG(GUI.percentage_value), 2) as 'Average'
  FROM talentumehs_valle_open_location.departments DP 
  JOIN talentumehs_valle_open_location.towns TW 
    ON TW.department_id = DP.id 
  JOIN talentumehs_valle_open_location.headquarters HQ 
    ON HQ.town_id = TW.id 
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
  WHERE DP.id = 1
  GROUP BY (I.id)
  ORDER BY (I.name)

-- Get every style averages by DP.id
SELECT
  GU.id,
  COUNT(GUI.id) as 'total_by_area'
  FROM talentumehs_valle_open_location.departments DP 
  JOIN talentumehs_valle_open_location.towns TW 
    ON TW.department_id = DP.id 
  JOIN talentumehs_valle_open_location.headquarters HQ 
    ON HQ.town_id = TW.id 
  JOIN talentumehs_valle_magico.game_users GU 
    ON GU.headquarter_id = HQ.id
  JOIN talentumehs_valle_magico.game_user_records GUR
    ON GUR.game_user_id = GU.id
  JOIN talentumehs_valle_magico.gu_record_intelligence_ind_desc_styles GUI
    ON GUI.game_user_record_id = GUR.id
  JOIN talentumehs_valle_magico.description_styles DS
    ON GUI.description_style_id = DS.id
  WHERE DP.id = 1
  GROUP BY (GU.id), (DS.style_id)

SELECT
  GU.id as 'game_user_id',
  DS.style_id as 'style',
  COUNT(GUI.id) as 'total_by_area'
  FROM talentumehs_valle_open_location.departments DP 
  JOIN talentumehs_valle_open_location.towns TW 
    ON TW.department_id = DP.id 
  JOIN talentumehs_valle_open_location.headquarters HQ 
    ON HQ.town_id = TW.id 
  JOIN talentumehs_valle_magico.game_users GU 
    ON GU.headquarter_id = HQ.id
  JOIN talentumehs_valle_magico.game_user_records GUR
    ON GUR.game_user_id = GU.id
  JOIN talentumehs_valle_magico.gu_record_intelligence_ind_desc_styles GUI
    ON GUI.game_user_record_id = GUR.id
  JOIN talentumehs_valle_magico.description_styles DS
    ON GUI.description_style_id = DS.id
  WHERE DP.id = 1
  GROUP BY (DS.style_id), (GU.id) 

  
SELECT 
  S.name,
  ROUND(AVG(TSBUS.total_by_area/TSBU.total_by_user), 2) * 100 as 'Average'
  FROM (
    SELECT
      GU.id as 'game_user_id',
      DS.style_id as 'style',
      COUNT(GUI.id) as 'total_by_area'
      FROM talentumehs_valle_open_location.departments DP 
      JOIN talentumehs_valle_open_location.towns TW 
        ON TW.department_id = DP.id 
      JOIN talentumehs_valle_open_location.headquarters HQ 
        ON HQ.town_id = TW.id 
      JOIN talentumehs_valle_magico.game_users GU 
        ON GU.headquarter_id = HQ.id
      JOIN talentumehs_valle_magico.game_user_records GUR
        ON GUR.game_user_id = GU.id
      JOIN talentumehs_valle_magico.gu_record_intelligence_ind_desc_styles GUI
        ON GUI.game_user_record_id = GUR.id
      JOIN talentumehs_valle_magico.description_styles DS
        ON GUI.description_style_id = DS.id
      WHERE DP.id = 1
      GROUP BY (DS.style_id), (GU.id) 
  ) AS TSBUS
  JOIN (
    SELECT
      GU.id,
      COUNT(GUI.id) as 'total_by_user'
      FROM talentumehs_valle_open_location.departments DP 
      JOIN talentumehs_valle_open_location.towns TW 
        ON TW.department_id = DP.id 
      JOIN talentumehs_valle_open_location.headquarters HQ 
        ON HQ.town_id = TW.id 
      JOIN talentumehs_valle_magico.game_users GU 
        ON GU.headquarter_id = HQ.id
      JOIN talentumehs_valle_magico.game_user_records GUR
        ON GUR.game_user_id = GU.id
      JOIN talentumehs_valle_magico.gu_record_intelligence_ind_desc_styles GUI
        ON GUI.game_user_record_id = GUR.id
      JOIN talentumehs_valle_magico.description_styles DS
        ON GUI.description_style_id = DS.id
      WHERE DP.id = 1
      GROUP BY (GU.id)
  ) AS TSBU 
    ON TSBUS.game_user_id = TSBU.id
  JOIN talentumehs_valle_magico.styles S
    ON TSBUS.style = S.id
  GROUP BY (TSBUS.style)
  ORDER BY (S.name)

--Get every vocation by DP.id
SELECT
  I.id,
  ROUND(AVG(GUI.percentage_value), 2) as 'average'
  FROM talentumehs_valle_open_location.departments DP 
  JOIN talentumehs_valle_open_location.towns TW 
    ON TW.department_id = DP.id 
  JOIN talentumehs_valle_open_location.headquarters HQ 
    ON HQ.town_id = TW.id 
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
  GROUP BY (I.id)
  ORDER BY (average) DESC

--Get all the grade averages per subject of an specific student
SELECT 
  G.name as 'Grade',
  S.name as 'Subject',
  ROUND(AVG(GUR.total_score), 2) as 'Average'
  FROM talentumehs_valle_magico.game_users GU 
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
  RIGHT JOIN talentumehs_valle_magico.grades G
    ON MG.grade_id = G.id
  WHERE DP.id = 1 
    AND TW.id = 1 
  GROUP BY (G.id), (S.id)
  ORDER BY (G.id), (S.name) 

