USE serials_base;

-- Users view

CREATE OR REPLACE VIEW users_info AS
	SELECT
		u.id,
		CONCAT(firstname,' ', lastname) as 'Name',
		u.phone as 'Phone',
		r.c as 'Количество обзоров',
		f.c as 'Количество избранных сериалов'
	FROM users as u
	LEFT JOIN (SELECT 
				COUNT(id) AS c,
				users_id
				FROM reviews
				GROUP BY users_id
				) r ON u.id = r.users_id
	LEFT JOIN (SELECT
				COUNT(serials_id) as c,
				users_id
				FROM favorities
				GROUP BY users_id
				) f ON u.id = f.users_id
	WHERE is_deleted = 0
	ORDER BY u.id;

-- Serials view

CREATE OR REPLACE VIEW serials_info AS
	SELECT 
		s.id,
		s.name,
		g.name as 'Жанр',
		s.country as 'Страна производства',
		s.short_description as 'Краткое описание',
		e.sc as 'Количество сезонов',
		e_e.ec as 'Количество серий',
		n.c as 'Количество новостей',
		f.c as 'Избранный сериал у пользователя'
	FROM serials as s
	LEFT JOIN genres as g
		ON s.genres_id = g.id
	LEFT JOIN (SELECT DISTINCT 
				max(n_season) as sc,
				serials_id
				FROM episodes
				GROUP BY serials_id
				) e ON s.id = e.serials_id
	LEFT JOIN (SELECT 
				COUNT(n_episode) as ec,
				serials_id
				FROM episodes
				GROUP BY serials_id
				) e_e ON s.id = e_e.serials_id
	LEFT JOIN (SELECT
				COUNT(serials_id) as c,
				serials_id
				FROM news
				GROUP BY serials_id
				) n ON s.id = n.serials_id
	LEFT JOIN (SELECT
				COUNT(serials_id) as c,
				serials_id
				FROM favorities
				WHERE is_disliked = 0
				GROUP BY serials_id 
				) f ON s.id = f.serials_id
	ORDER BY s.id;


	