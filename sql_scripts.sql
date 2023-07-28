# что больше всего влияет на количество лайков: 
#                   -  время суток публикации, 
#                   -  день недели, 
#                   -  промежуток между постами.


--День недели--
-- Мы имеем кол-во постов и кол-во лайков под каждым постом - следовательно,
-- необходимо найти среднее кол-во лайков за каждый пост в определенный день недели

select date_part('isodow', date::timestamp) as day_of_week, -- где числа от 1 до 7 обозначают дни недели
		sum(likes)::real / count(post_id) as mean_ -- среднее значение (сумма лайков / кол-во постов)
from vk v 
group by day_of_week
order by mean_ desc

-- Отсюда следует вывод, что в субботу посты больше набирают лайков

--Время суток публикации
-- Будем считать, что утро продолжается с 4.00 до 11.00 включительно. 
-- День – с 12.00 до 16.00, вечер – с 17.00 до 23.00, ночь – с 0 до 3.00. 

--  необходимо найти среднее кол-во лайков за каждый пост в определенное время дня

select  sum(likes), count(likes), sum(likes)::real / count(likes) as mean_,
case 
	when date::time between '04:00:00' and '12:00:00' then 'Morning'
	when date::time between '12:00:00' and '17:00:00' then 'Afternoon'
	when date::time between '17:00:00' and '24:00:00' then 'Evening'
	else 'Night'
end as times_of_day
from vk v 
group by times_of_day
order by mean_ desc

-- Отсюда следует вывод, что средние показатели отличаются друг от друга незначительно
--(оценить влияние времени суток проблематично)


-- Промежуток между постами
-- Используя оконнную функцию lag, которая находит значение относительно предыдущей строки,
-- находим интервалы и сортируем по кол-ву лайков в порядке убывания

select *, date::timestamp - lag(date::timestamp) over (order by "date") as interval_
from vk v 
order by likes desc

--Вывод: самое большое кол-во лайков набрал пост, который был выложен после 641 дней паузы
-- В целом показатели перемешаны, чтобы сделать какой-либо точный вывод
-- Считаю, что необходимо оценивать влияние содержания и контента поста на кол-во лайков
