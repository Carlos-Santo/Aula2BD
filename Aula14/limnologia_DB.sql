DROP TABLE IF EXISTS serie_temporal CASCADE;
DROP TABLE IF EXISTS parametro CASCADE;
DROP TABLE IF EXISTS reservatorio CASCADE;

-- Tabela de reservatórios
CREATE TABLE reservatorio (
    id_reservatorio SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL
);

-- Tabela de parâmetros ambientais
CREATE TABLE parametro (
    id_parametro SERIAL PRIMARY KEY,
    nome_parametro VARCHAR(150) NOT NULL
);

-- Série temporal (medições)
CREATE TABLE serie_temporal (
    id_serie SERIAL PRIMARY KEY,
    id_reservatorio INT NOT NULL REFERENCES reservatorio(id_reservatorio),
    id_parametro INT NOT NULL REFERENCES parametro(id_parametro),
    valor NUMERIC(12,4) NOT NULL,
    data_hora TIMESTAMP NOT NULL
);

-- =============================================================
-- INSERTS NOS RESERVATÓRIOS
-- =============================================================
INSERT INTO reservatorio (nome)
VALUES ('Jaguari'),
       ('Paraibuna'),
       ('Cachoeira do França'),
       ('Santa Branca');

-- =============================================================
-- INSERTS DOS PARÂMETROS (AGORA COM TURBIDEZ)
-- =============================================================
INSERT INTO parametro (nome_parametro)
VALUES ('pH'),
       ('Oxigênio Dissolvido'),
       ('Temperatura'),
       ('Turbidez');

-- =============================================================
-- INSERTS NAS MEDIÇÕES
-- =============================================================

-- Jaguari (tem todos os parâmetros)
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora)
VALUES 
    ((SELECT id_reservatorio FROM reservatorio WHERE nome='Jaguari'),
     (SELECT id_parametro FROM parametro WHERE nome_parametro='Temperatura'),
     22.5, '2025-01-10 09:00:00'),

    ((SELECT id_reservatorio FROM reservatorio WHERE nome='Jaguari'),
     (SELECT id_parametro FROM parametro WHERE nome_parametro='Turbidez'),
     7.8, '2025-01-10 09:02:00'),

    ((SELECT id_reservatorio FROM reservatorio WHERE nome='Jaguari'),
     (SELECT id_parametro FROM parametro WHERE nome_parametro='Oxigênio Dissolvido'),
     6.80, '2025-01-10 09:05:00'),

    ((SELECT id_reservatorio FROM reservatorio WHERE nome='Jaguari'),
     (SELECT id_parametro FROM parametro WHERE nome_parametro='pH'),
     7.20, '2025-01-10 09:10:00');

-- Paraibuna (tem turbidez baixa)
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora)
VALUES
    ((SELECT id_reservatorio FROM reservatorio WHERE nome='Paraibuna'),
     (SELECT id_parametro FROM parametro WHERE nome_parametro='Turbidez'),
     3.2, '2025-02-20 10:00:00'),

    ((SELECT id_reservatorio FROM reservatorio WHERE nome='Paraibuna'),
     (SELECT id_parametro FROM parametro WHERE nome_parametro='pH'),
     6.90, '2025-02-20 10:05:00');

-- Cachoeira do França (somente turbidez alta)
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora)
VALUES
    ((SELECT id_reservatorio FROM reservatorio WHERE nome='Cachoeira do França'),
     (SELECT id_parametro FROM parametro WHERE nome_parametro='Turbidez'),
     8.5, '2025-03-15 11:00:00'),

    ((SELECT id_reservatorio FROM reservatorio WHERE nome='Cachoeira do França'),
     (SELECT id_parametro FROM parametro WHERE nome_parametro='pH'),
     7.60, '2025-03-15 11:05:00');

-- Santa Branca (tem diversos parâmetros)
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora)
VALUES
    ((SELECT id_reservatorio FROM reservatorio WHERE nome='Santa Branca'),
     (SELECT id_parametro FROM parametro WHERE nome_parametro='Oxigênio Dissolvido'),
     7.00, '2025-04-01 08:00:00'),

    ((SELECT id_reservatorio FROM reservatorio WHERE nome='Santa Branca'),
     (SELECT id_parametro FROM parametro WHERE nome_parametro='Temperatura'),
     23.1, '2025-04-01 08:05:00'),

    ((SELECT id_reservatorio FROM reservatorio WHERE nome='Santa Branca'),
     (SELECT id_parametro FROM parametro WHERE nome_parametro='Turbidez'),
     4.9, '2025-04-01 08:10:00');

CREATE OR REPLACE VIEW vw_media_temperatura_reservatorio AS
SELECT 
    r.nome AS nome_reservatorio,
    AVG(s.valor) AS media_temperatura
FROM serie_temporal s
JOIN reservatorio r ON r.id_reservatorio = s.id_reservatorio
JOIN parametro p ON p.id_parametro = s.id_parametro
WHERE p.nome_parametro = 'Temperatura'
GROUP BY r.nome;

CREATE OR REPLACE VIEW vw_eventos_reservatorio AS
SELECT 
    r.nome AS nome_reservatorio,
    p.nome_parametro,
    s.valor,
    s.data_hora
FROM serie_temporal s
JOIN reservatorio r ON r.id_reservatorio = s.id_reservatorio
JOIN parametro p ON p.id_parametro = s.id_parametro
ORDER BY r.nome, s.data_hora;


CREATE OR REPLACE VIEW vw_turbidez_acima_5 AS
SELECT 
    r.nome AS nome_reservatorio,
    AVG(s.valor) AS media_turbidez
FROM serie_temporal s
JOIN reservatorio r ON r.id_reservatorio = s.id_reservatorio
JOIN parametro p ON p.id_parametro = s.id_parametro
WHERE p.nome_parametro = 'Turbidez'
GROUP BY r.nome
HAVING AVG(s.valor) > 5;

SELECT * FROM vw_media_temperatura_reservatorio;
SELECT * FROM vw_eventos_reservatorio;
SELECT * FROM vw_turbidez_acima_5;

DROP VIEW IF EXISTS vw_eventos_reservatorio;
