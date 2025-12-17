# 🎮 Game Database Management System

Bu proje, **SQL (PostgreSQL)** kullanılarak geliştirilmiş bir **oyun veritabanı yönetim sistemi** örneğidir.  
Amaç; tablolar arası ilişkileri (1-to-Many, Many-to-Many), **JOIN**, **INSERT**, **UPDATE**, **DELETE**, **CASCADE** gibi temel veritabanı kavramlarını uygulamalı olarak göstermektir.

---

## 📌 Kullanılan Teknolojiler
- PostgreSQL
- SQL (DDL & DML)
- ERD (Entity Relationship Diagram)

---

## 🗂️ Veritabanı Modeli (ERD)

### Tablolar

#### 1️⃣ developers (Geliştiriciler)
| Kolon | Açıklama |
|------|---------|
| id | Benzersiz kimlik |
| company_name | Firma adı |
| country | Ülke |
| founded_year | Kuruluş yılı |

---

#### 2️⃣ games (Oyunlar)
| Kolon | Açıklama |
|------|---------|
| id | Benzersiz kimlik |
| title | Oyun adı |
| price | Fiyat |
| release_date | Çıkış tarihi |
| rating | Puan |
| developer_id | Geliştirici (FK) |

➡️ **1 developer → N game**

---

#### 3️⃣ genres (Türler)
| Kolon | Açıklama |
|------|---------|
| id | Benzersiz kimlik |
| name | Tür adı |
| description | Açıklama |

---

#### 4️⃣ games_genres (Ara Tablo)
| Kolon | Açıklama |
|------|---------|
| id | Benzersiz kimlik |
| game_id | Oyun (FK) |
| genre_id | Tür (FK) |

➡️ **Many-to-Many ilişki**

---

## 🧱 Veritabanı Kurulumu (DDL)

```sql
CREATE TABLE developers (
    id SERIAL PRIMARY KEY,
    company_name VARCHAR(100),
    country VARCHAR(50),
    founded_year INT
);

CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100),
    price DECIMAL(8,2),
    release_date DATE,
    rating DECIMAL(3,1),
    developer_id INT REFERENCES developers(id) ON DELETE CASCADE
);

CREATE TABLE genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(255)
);

CREATE TABLE games_genres (
    id SERIAL PRIMARY KEY,
    game_id INT REFERENCES games(id) ON DELETE CASCADE,
    genre_id INT REFERENCES genres(id) ON DELETE CASCADE
);
