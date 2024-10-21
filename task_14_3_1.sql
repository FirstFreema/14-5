-- Создание таблиц

CREATE TABLE instructors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    section_id INT
);

CREATE TABLE sections (
    id SERIAL PRIMARY KEY,
    section_name VARCHAR(100),
    schedule TIME
);

CREATE TABLE visitors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    mobile_operator VARCHAR(100)
);

CREATE TABLE visits (
    id SERIAL PRIMARY KEY,
    visitor_id INT,
    section_id INT,
    visit_date DATE,
    FOREIGN KEY (visitor_id) REFERENCES visitors(id),
    FOREIGN KEY (section_id) REFERENCES sections(id)
);

-- Запрос 1: Вывести количество инструкторов по каждой секции

SELECT s.section_name, COUNT(i.id) AS instructor_count
FROM instructors i
JOIN sections s ON i.section_id = s.id
GROUP BY s.section_name;

-- Запрос 2: Показать количество людей, которые должны заниматься в определенный момент времени

SELECT s.section_name, COUNT(v.id) AS visitor_count
FROM visits v
JOIN sections s ON v.section_id = s.id
WHERE s.schedule = '10:00:00' -- Время можно поменять на нужное
GROUP BY s.section_name;

-- Запрос 3: Вывести количество посетителей фитнес-клуба, которые пользуются услугами определенного мобильного оператора

SELECT mobile_operator, COUNT(id) AS visitor_count
FROM visitors
WHERE mobile_operator = 'МТС' -- Можно заменить на нужного оператора
GROUP BY mobile_operator;

-- Запрос 4: Получить количество посетителей, у которых фамилия совпадает с фамилиями из списка

SELECT last_name, COUNT(id) AS visitor_count
FROM visitors
WHERE last_name IN ('Иванов', 'Петров', 'Сидоров') -- Добавьте нужные фамилии
GROUP BY last_name;

-- Запрос 5: Показать количество людей с одинаковыми именами, которые занимаются у определенного инструктора

SELECT v.first_name, COUNT(v.id) AS visitor_count
FROM visitors v
JOIN visits vi ON v.id = vi.visitor_id
JOIN instructors i ON i.id = vi.section_id
WHERE i.first_name = 'Алексей' -- Имя инструктора можно заменить
GROUP BY v.first_name;

-- Запрос 6: Информация о людях, которые посетили фитнес-зал минимальное количество раз

SELECT v.first_name, v.last_name, COUNT(vi.id) AS visit_count
FROM visitors v
JOIN visits vi ON v.id = vi.visitor_id
GROUP BY v.first_name, v.last_name
HAVING COUNT(vi.id) = (
    SELECT MIN(visit_count)
    FROM (
        SELECT COUNT(id) AS visit_count
        FROM visits
        GROUP BY visitor_id
    ) AS visit_counts
);

-- Запрос 7: Количество посетителей, которые занимались в определенной секции за первую половину текущего года

SELECT COUNT(v.id) AS visitor_count
FROM visitors v
JOIN visits vi ON v.id = vi.visitor_id
WHERE vi.section_id = 1 -- Замените на нужный ID секции
AND vi.visit_date BETWEEN '2024-01-01' AND '2024-06-30';

-- Запрос 8: Определить общее количество людей, посетивших фитнес-зал за прошлый год

SELECT COUNT(DISTINCT visitor_id) AS total_visitors
FROM visits
WHERE visit_date BETWEEN '2023-01-01' AND '2023-12-31';
