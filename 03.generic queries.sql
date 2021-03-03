USE serials_base;

-- TV series distribution by genre

SELECT 
	a.name as 'Жанр',
	COUNT(*) as 'Количество сериалов'
	FROM genres as a
	JOIN serials as b
	ON a.id = b.genres_id
	GROUP BY a.name;

-- 5 most beloved TV shows

 SELECT 
 	a.name as 'Название сериала',
 	COUNT(*)
 	FROM serials as a
 	JOIN favorities as b
	ON a.id = b.serials_id
	GROUP BY a.name
	ORDER BY COUNT(*) DESC
	LIMIT 5;

-- distribution of ratings 5 ​​by series

SELECT
	c.name,
	COUNT(*) as 'Количество оценок 5'
	FROM users_ratings as a
	JOIN episodes as b ON a.episodes_id = b.id
	JOIN serials as c ON b.serials_id = c.id
	WHERE a.rating = 5
	GROUP BY c.name
	ORDER BY COUNT(*) DESC;
	
-- average date of creation of the series

SELECT
	AVG(TIMESTAMPDIFF(YEAR, serials.created_at , NOW())) as 'Среднее количество лет с даты создания сериала'
	FROM serials;

-- Most viewed episode

SELECT
	s.name as 'Название сериала',
	e.name as 'Название эпизода',
	e.n_season as 'Номер сезона',
	e.n_episode as 'Номер эпизода',
	COUNT(*) as 'Количество просмотров'
	FROM serials as s
	JOIN episodes as e ON s.id = e.serials_id
	JOIN view_counter as vc ON vc.episodes_id = e.id
	GROUP BY s.name, e.name, e.n_season, e.n_episode
	ORDER BY COUNT(*) DESC
	LIMIT 1;

-- Five most liked reviews
SELECT	
	reviews_id,
	avg(rating) as 'Средний рейтинг'
	FROM reviews_ratings
	GROUP BY reviews_id
	ORDER BY avg(rating) DESC
	LIMIT 5;
	



	   