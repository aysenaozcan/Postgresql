CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    customer_surname VARCHAR(50) NOT NULL,
    customer_email VARCHAR(50) NOT NULL UNIQUE,
	customer_city VARCHAR(50) NOT NULL,
	customer_country VARCHAR(50) NOT NULL,
	registration_date DATE NOT NULL
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    category_id INT NOT NULL,
	purchase_price DECIMAL(10,2) NOT NULL,
    sale_price DECIMAL(10,2) NOT NULL,
	stock_quantity INT NOT NULL,
	
	CONSTRAINT fk_categories
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE CASCADE
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    shipping_company VARCHAR(50),
    status VARCHAR(30) NOT NULL,

    CONSTRAINT fk_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

CREATE TABLE order_items (
    detail_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,

    CONSTRAINT fk_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT
);


TRUNCATE TABLE customers RESTART IDENTITY CASCADE;

INSERT INTO categories (category_name) VALUES
('Elektronik'),
('Bilgisayar & Tablet'),
('Telefon & Aksesuar'),
('Televizyon & Ses Sistemleri'),
('Beyaz Eşya'),
('Küçük Ev Aletleri'),
('Giyim'),
('Kadın Giyim'),
('Erkek Giyim'),
('Çocuk Giyim'),
('Ayakkabı'),
('Çanta & Aksesuar'),
('Spor Giyim'),
('Spor & Outdoor'),
('Fitness & Kondisyon'),
('Ev & Yaşam'),
('Mobilya'),
('Dekorasyon'),
('Mutfak Gereçleri'),
('Banyo Ürünleri'),
('Ev Tekstili'),
('Aydınlatma'),
('Bahçe & Balkon'),
('Kitap'),
('Ders Kitapları'),
('Roman & Edebiyat'),
('Kırtasiye'),
('Ofis Malzemeleri'),
('Oyuncak'),
('Bebek Ürünleri'),
('Anne & Bebek'),
('Kozmetik'),
('Cilt Bakımı'),
('Makyaj'),
('Parfüm'),
('Saç Bakımı'),
('Kişisel Bakım'),
('Sağlık Ürünleri'),
('Gıda & İçecek'),
('Atıştırmalık'),
('Organik Ürünler'),
('Evcil Hayvan Ürünleri'),
('Hobi & El Sanatları'),
('Müzik Aletleri'),
('Oyun & Konsol'),
('Bilgisayar Oyunları'),
('Film & Dizi'),
('Dijital Ürünler'),
('Hediyelik Eşyalar');

INSERT INTO categories (category_id, category_name)
VALUES (50, 'Takı & Aksesuar');


select * from categories;

--customers
DO $$
DECLARE
    i INT;
    base INT;
    names TEXT[] := ARRAY[
        'Ali','Ayşe','Mehmet','Zeynep','Can','Elif','Mert','Selin','Burak','Derya',
        'Emre','Seda','Hakan','İrem','Kaan','Ece','Ozan','Pınar','Cem','Nisa',
        'Kerem','Aslı','Bora','Gizem','Yusuf','Melis','Onur','Büşra','Umut','Sıla'
    ];
    surnames TEXT[] := ARRAY[
        'Yılmaz','Kaya','Demir','Çelik','Aydın','Koç','Arslan','Şahin','Yıldız','Güneş',
        'Doğan','Kurt','Öztürk','Polat','Aksoy','Eren','Kılıç','Çetin','Kaplan','Taş',
        'Yalçın','Karaca','Bayram','Bulut','Avcı','Kara','Işık','Sönmez','Yavuz','Acar'
    ];
    cities TEXT[] := ARRAY[
        'İstanbul','Ankara','İzmir','Bursa','Antalya','Adana','Konya','Gaziantep','Mersin','Eskişehir',
        'Kayseri','Samsun','Trabzon','Diyarbakır','Kocaeli','Sakarya','Muğla','Tekirdağ','Manisa','Balıkesir'
    ];
BEGIN
    -- Mevcut max ID’yi alıp email’lerde çakışmayı engelliyoruz
    SELECT COALESCE(MAX(customer_id), 0) INTO base FROM customers;

    FOR i IN 1..250 LOOP
        INSERT INTO customers (
            customer_name,
            customer_surname,
            customer_email,
            customer_city,
            customer_country,
            registration_date
        )
        VALUES (
            names[((base + i - 1) % array_length(names, 1)) + 1],
            surnames[((base + i - 1) % array_length(surnames, 1)) + 1],
            'customer' || (base + i) || '@mail.com',
            cities[((base + i - 1) % array_length(cities, 1)) + 1],
            'Türkiye',
            CURRENT_DATE - ((base + i) % 365)
        );
    END LOOP;
END $$;

--products
DO $$
DECLARE
    i INT;
    base INT;
    cat_id INT;
    p NUMERIC(10,2);
    s NUMERIC(10,2);

    adjectives TEXT[] := ARRAY[
        'Pro','Max','Mini','Ultra','Smart','Classic','Premium','Eco','Plus','Lite',
        'Advanced','Prime','Elite','Compact','Air','Power','Flex','Nova','Urban','Sport'
    ];
    nouns TEXT[] := ARRAY[
        'Laptop','Telefon','Kulaklik','Klavye','Mouse','Monitor','Tablet','Kamera','Saat','Hoparlor',
        'Blender','Kettle','TostMakinesi','Firin','Supurge','Utu','Termos','SirtCanta','Ayakkabi','Mont'
    ];
BEGIN
    -- Mevcut en büyük product_id (varsa) -> isim çakışması olmasın diye
    SELECT COALESCE(MAX(product_id), 0) INTO base FROM products;

    FOR i IN 1..1000 LOOP
        cat_id := ((base + i - 1) % 50) + 1;

        -- alış fiyatı: 50 - 4050 arası (yaklaşık)
        p := ROUND((50 + (RANDOM() * 4000))::NUMERIC, 2);

        -- satış fiyatı: alıştan yüksek olacak şekilde %10 - %60 arası marj
        s := ROUND((p * (1 + (0.10 + RANDOM() * 0.50)))::NUMERIC, 2);

        INSERT INTO products (
            product_name,
            category_id,
            purchase_price,
            sale_price,
            stock_quantity
        )
        VALUES (
            adjectives[((base + i - 1) % array_length(adjectives, 1)) + 1] || ' ' ||
            nouns[((base + i - 1) % array_length(nouns, 1)) + 1] || ' #' || (base + i),
            cat_id,
            p,
            s,
            (RANDOM() * 200)::INT
        );
    END LOOP;
END $$;

SELECT * FROM products;

TRUNCATE TABLE orders RESTART IDENTITY CASCADE;

--orders
SELECT * FROM orders;
DO $$
DECLARE
    i INT;
    cust_min INT;
    cust_max INT;

    ship TEXT[] := ARRAY[
        'Yurtiçi Kargo', 'Aras Kargo', 'MNG Kargo', 'Sürat Kargo',
        'PTT Kargo', 'UPS', 'DHL', 'FedEx', 'Hepsijet', 'Trendyol Express'
    ];

    st TEXT;
    ship_name TEXT;
    cid INT;
    d DATE;
BEGIN
    SELECT MIN(customer_id), MAX(customer_id)
    INTO cust_min, cust_max
    FROM customers;

    IF cust_min IS NULL OR cust_max IS NULL THEN
        RAISE EXCEPTION 'customers tablosu bos. Once customers tablosuna veri eklemelisin.';
    END IF;

    FOR i IN 1..10000 LOOP
        cid := cust_min + floor(random() * (cust_max - cust_min + 1))::int;
        d := CURRENT_DATE - floor(random() * 365)::int;

        CASE
            WHEN random() < 0.60 THEN st := 'teslim_edildi';
            WHEN random() < 0.80 THEN st := 'kargoda';
            WHEN random() < 0.95 THEN st := 'hazirlaniyor';
            ELSE st := 'iptal';
        END CASE;

        IF st = 'iptal' THEN
            ship_name := NULL;
        ELSE
            ship_name := ship[floor(random() * array_length(ship, 1))::int + 1];
        END IF;

        INSERT INTO orders (customer_id, order_date, shipping_company, status)
        VALUES (cid, d, ship_name, st);
    END LOOP;
END $$;

select * from order_items;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM orders;

DO $$
DECLARE
    i INT;
    o_min INT; o_max INT;
    p_min INT; p_max INT;

    oid INT;
    pid INT;
    qty INT;
    disc NUMERIC(5,2);
    price NUMERIC(10,2);
BEGIN
    SELECT MIN(order_id), MAX(order_id) INTO o_min, o_max FROM orders;
    SELECT MIN(product_id), MAX(product_id) INTO p_min, p_max FROM products;

    IF o_min IS NULL OR o_max IS NULL THEN
        RAISE EXCEPTION 'orders tablosu bos.';
    END IF;

    IF p_min IS NULL OR p_max IS NULL THEN
        RAISE EXCEPTION 'products tablosu bos.';
    END IF;

    FOR i IN 1..4000 LOOP
        oid := o_min + floor(random() * (o_max - o_min + 1))::int;
        pid := p_min + floor(random() * (p_max - p_min + 1))::int;

        qty := (floor(random() * 5)::int + 1); -- 1-5 adet

        disc := CASE
            WHEN random() < 0.70 THEN 0
            WHEN random() < 0.90 THEN 5
            ELSE 10
        END;

        SELECT sale_price INTO price
        FROM products
        WHERE product_id = pid;

        INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount)
        VALUES (oid, pid, qty, price, disc);
    END LOOP;
END $$;

