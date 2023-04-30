create table service
(
	id int generated always as identity primary key,
	name_s text,
	founding_date int,
	quality text,
	place text
);

create table cars
(
	id int generated always as identity primary key,
	name text,
	date_of_manufacture int,
	rating numeric,
	review text,
	driving_style text,
	quantity int,
	fuel text
);

create table service_cooperator
(
	id int generated always as identity primary key,
	service_id int references service on delete set null,
	function text,
	wage int,
	prize int
);

create table cars_to_service
(
	service_id int references service on delete cascade,
	cars_id int references cars on delete cascade,
	primary key (service_id, cars_id)
);

insert into service(name_s, founding_date, quality, place)
values  ('Сервис Hundai', 1993, 'Качество ниже среднего', 'Корея'),
		('Сервис BMW', 1983, 'Среднее качество', 'Германия'),
		('Сервис Mersedes', 1948, 'Высокое качество', 'Германия'),
		('Сервис LADA', 1953, 'Низкое качество', 'Россия'),
		('Сервис Audi', 1999, 'Очень высокое качество', 'Франция');

insert into cars (name, date_of_manufacture, rating, review, driving_style, quantity, fuel)
values  ('Hundai Solaris', 1995, 5.5, 'Очень экономная машина', 'Для очень плавного вождения', 7000 , 'Бензин'),
		('Hundai Sonata', 2002, 7.8, 'Отличный вид', 'Для плавной езды', 350, 'Гибрид'),
		('BMW X5', 2020, 9.0, 'Хорошая машина но часто ломается', 'Для дрифта', 500, 'Бензин'),
		('BMW Z4', 2022, 10.0, 'Отличная машина', 'Для прогулочных поездок', 600, 'Бензин'),
		('Mercedes-Benz Mayscach', 1999, 100, 'Самая комфортная машина', 'Для комфортых поездок', 99, 'Гибрид'),
		('Mercedes-Benz C-Class', 2010, 8.4, 'Удобная машина', 'Для агресивной езды', 900, 'Бензин'),
		('Lada Vesta', 2022, 5.6, 'Хорошая дешёвая машина', 'Для поездок с семьёй', 9999, 'Гибрид'),
		('Lada Priora', 2009, 7.7, 'Неплохая машина', 'Для душевных поездок', 3000, 'Бензин'),
		('Audi Q8', 2008, 9.9, 'Cамая красивая машина', 'Для планого вождения', 499, 'Бензин'),
		('Audi RS7', 2021, 9.6, 'Самая быстрая машина', 'Для агрисивного вождения', 700, 'Электричество');


insert into service_cooperator (service_id, function, wage, prize)
values  (1, 'Директор', 70000, 23000),
		(1, 'Консультант', 17800, 4999),
		(1, 'Продавец', 23500, 8500),
		(1, 'Менеджер', 55000, 13999),
		(1, 'Руководитель отдела продаж', 66000, 18999),
		(2, 'Директор', 50000, 20000),
		(2, 'Консультант', 13800, 3999),
		(2, 'Продавец', 17500, 5500),
		(2, 'Менеджер', 44990, 7999),
		(2, 'Руководитель отдела продаж', 42500, 15999),
		(3, 'Директор', 90000, 29000),
		(3, 'Консультант', 27800, 9999),
		(3, 'Продавец', 37500, 14500),
		(3, 'Менеджер', 66000, 18499),
		(3, 'Руководитель отдела продаж', 80000, 25999),
		(4, 'Директор', 30000, 11000),
		(4, 'Консультант', 17800, 6999),
		(4, 'Продавец', 9500, 4500),
		(4, 'Менеджер', 13000, 8999),
		(4, 'Руководитель отдела продаж', 21210, 10000),
		(5, 'Директор', 70000, 23000),
		(5, 'Консультант', 34331, 4999),
		(5, 'Продавец', 9999, 3000),
		(5, 'Менеджер', 15000, 8999),
		(5, 'Руководитель отдела продаж', 33121, 19999);

insert into cars_to_service (service_id, cars_id)
values (1, 1),
	   (1, 2),
	   (2, 3),
	   (2, 4),
	   (3, 5),
	   (3, 6),
	   (4, 7),
	   (4, 8),
	   (5, 9),
	   (5, 10);
	   