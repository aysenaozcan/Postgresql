/*4 adet ilişkili tablo oluştur.*/

/*TABLE developers;*/
CREATE TABLE developers (
    id SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    founded_year INT
);

/***********************************************/
/*TABLE games;*/
CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    price DECIMAL(8,2),
    release_date DATE,
    rating DECIMAL(3,1),
    developer_id INT,

    CONSTRAINT fk_developer
        FOREIGN KEY (developer_id)
        REFERENCES developers(id)
        ON DELETE CASCADE
);

/***********************************************/
/*TABLE genres;*/
CREATE TABLE genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

/***********************************************/
/*TABLE games_genres;*/
CREATE TABLE games_genres (
    id SERIAL PRIMARY KEY,
    game_id INT,
    genre_id INT,

    CONSTRAINT fk_game
        FOREIGN KEY (game_id)
        REFERENCES games(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_genre
        FOREIGN KEY (genre_id)
        REFERENCES genres(id)
        ON DELETE CASCADE
);

/***********************************************/
/*Developers tablosuna veri eklenir;*/
INSERT INTO developers (company_name, country, founded_year) VALUES
('CD Projekt Red', 'Poland', 2002),
('Rockstar Games', 'USA', 1998),
('Bethesda', 'USA', 1986),
('Ubisoft', 'France', 1986),
('Valve', 'USA', 1996);

/***********************************************/
/*Genres tablosuna veri eklenir;*/
INSERT INTO genres (name, description) VALUES
('RPG', 'Role Playing Game'),
('Open World', 'Open world exploration'),
('Horror', 'Scary and suspenseful games'),
('FPS', 'First Person Shooter'),
('Sports', 'Sports based games');

/***********************************************/
/*Games tablosuna veri eklenir;*/
INSERT INTO games (title, price, release_date, rating, developer_id) VALUES
('The Witcher 3', 29.99, '2015-05-19', 9.5, 1),
('Cyberpunk 2077', 39.99, '2020-12-10', 8.0, 1),
('GTA V', 29.99, '2013-09-17', 9.8, 2),
('Red Dead Redemption 2', 59.99, '2018-10-26', 9.7, 2),
('Skyrim', 19.99, '2011-11-11', 9.6, 3),
('Fallout 4', 19.99, '2015-11-10', 8.7, 3),
('Assassins Creed Valhalla', 49.99, '2020-11-10', 8.5, 4),
('Far Cry 6', 39.99, '2021-10-07', 8.1, 4),
('Half-Life 2', 9.99, '2004-11-16', 9.9, 5),
('Counter-Strike 2', 0.00, '2023-09-27', 8.9, 5);

/***********************************************/
/*Games_genres tablosuna veri eklenir;*/
INSERT INTO games_genres (game_id, genre_id) VALUES
-- The Witcher 3
(1, 1), -- RPG
(1, 2), -- Open World

-- Cyberpunk 2077
(2, 1),
(2, 2),

-- GTA V
(3, 2),
(3, 4),

-- RDR 2
(4, 2),

-- Skyrim
(5, 1),
(5, 2),

-- Fallout 4
(6, 1),
(6, 3),

-- AC Valhalla
(7, 1),
(7, 2),

-- Far Cry 6
(8, 4),
(8, 2),

-- Half-Life 2
(9, 4),

-- CS 2
(10, 4);

/*Tüm oyunların fiyatını %10 düşüren bir güncelleme sorgusu yazın.*/
UPDATE games SET price = price * 0.90;
/*Bir oyunun puanını (rating) güncelleyin (Örn: 8.5'i 9.0 yapın).*/
UPDATE games SET rating = 9.0 WHERE rating = 8.5;

-- Önce ara tablodan sil
DELETE FROM games_genres
WHERE game_id = 3;

-- Sonra oyunu sil
DELETE FROM games
WHERE id = 3;

-- Tüm Oyunlar Listesi: Oyunun adı, Fiyatı ve Geliştirici Firmanın Adını yan yana getirin.
SELECT 
    g.title AS oyun_adi,
    g.price AS fiyat,
    d.company_name AS gelistirici_firma
FROM games g
JOIN developers d
    ON g.developer_id = d.id;
	
--  Sadece "RPG" türündeki oyunların adını ve puanını listeleyin.
SELECT
    g.title  AS oyun_adi,
    g.rating AS puan
FROM games g
JOIN games_genres gg
    ON g.id = gg.game_id
JOIN genres gr
    ON gg.genre_id = gr.id
WHERE gr.name = 'RPG';

--  Fiyatı 500 TL üzerinde olan oyunları pahalıdan ucuza doğru sıralayın.
SELECT
    title AS oyun_adi,
    price AS fiyat
FROM games
WHERE price > 500
ORDER BY price DESC;

--İçinde "War" kelimesi geçen oyunları bulun.
SELECT
    title AS oyun_adi,
    price,
    rating
FROM games
WHERE title LIKE '%War%';









