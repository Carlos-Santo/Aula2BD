-- ====================================================
-- BANCO DE DADOS: LIMNOLOGIA_DB (ABP)
-- ====================================================

-- Drop das tabelas
DROP TABLE IF EXISTS serie_temporal CASCADE;
DROP TABLE IF EXISTS parametro CASCADE;
DROP TABLE IF EXISTS reservatorio CASCADE;

-- Tabela reservatório
CREATE TABLE reservatorio (
    id_reservatorio SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL
);

-- Tabela parâmetro ambiental
CREATE TABLE parametro (
    id_parametro SERIAL PRIMARY KEY,
    nome_parametro VARCHAR(150) NOT NULL
);

-- Tabela série temporal de medições
CREATE TABLE serie_temporal (
    id_serie SERIAL PRIMARY KEY,
    id_reservatorio INT NOT NULL REFERENCES reservatorio(id_reservatorio),
    id_parametro INT NOT NULL REFERENCES parametro(id_parametro),
    valor NUMERIC(12,4) NOT NULL,
    data_hora TIMESTAMP NOT NULL
);

-- Inserts de reservatórios
INSERT INTO reservatorio (nome) VALUES
('Jaguari'), ('Paraibuna'), ('Cachoeira do França'), ('Santa Branca');

-- Inserts de parâmetros
INSERT INTO parametro (nome_parametro) VALUES
('pH'), ('Oxigênio Dissolvido'), ('Temperatura');

-- Inserts de medições exemplo
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora) VALUES
((SELECT id_reservatorio FROM reservatorio WHERE nome = 'Jaguari'),
 (SELECT id_parametro FROM parametro WHERE nome_parametro = 'Oxigênio Dissolvido'),
 6.80, '2025-01-10 09:00:00'),

((SELECT id_reservatorio FROM reservatorio WHERE nome = 'Jaguari'),
 (SELECT id_parametro FROM parametro WHERE nome_parametro = 'pH'),
 7.20, '2025-01-10 09:05:00'),

((SELECT id_reservatorio FROM reservatorio WHERE nome = 'Paraibuna'),
 (SELECT id_parametro FROM parametro WHERE nome_parametro = 'pH'),
 6.90, '2025-02-20 10:00:00'),

((SELECT id_reservatorio FROM reservatorio WHERE nome = 'Cachoeira do França'),
 (SELECT id_parametro FROM parametro WHERE nome_parametro = 'pH'),
 7.60, '2025-03-15 11:00:00'),

((SELECT id_reservatorio FROM reservatorio WHERE nome = 'Santa Branca'),
 (SELECT id_parametro FROM parametro WHERE nome_parametro = 'Oxigênio Dissolvido'),
 7.00, '2025-04-01 08:00:00');

-- ====================================================
-- STORED PROCEDURES DO ABP
-- ====================================================

-- SP 1: Cadastrar reservatório
CREATE OR REPLACE PROCEDURE sp_cadastrar_reservatorio(
    p_nome VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO reservatorio (nome)
    VALUES (p_nome);

    RAISE NOTICE 'Reservatório % cadastrado.', p_nome;
END;
$$;

-- SP 2: Cadastrar parâmetro ambiental
CREATE OR REPLACE PROCEDURE sp_cadastrar_parametro(
    p_nome_parametro VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO parametro (nome_parametro)
    VALUES (p_nome_parametro);

    RAISE NOTICE 'Parâmetro % cadastrado.', p_nome_parametro;
END;
$$;

-- SP 3: Registrar medição
CREATE OR REPLACE PROCEDURE sp_registrar_medicao(
    p_id_reservatorio INT,
    p_id_parametro INT,
    p_valor NUMERIC,
    p_data_hora TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO serie_temporal (
        id_reservatorio, id_parametro, valor, data_hora
    ) VALUES (
        p_id_reservatorio, p_id_parametro, p_valor, p_data_hora
    );

    RAISE NOTICE 'Medição registrada para reservatório %, parâmetro %.',
        p_id_reservatorio, p_id_parametro;
END;
$$;

-- SP BÔNUS: Registrar medição com validação
CREATE OR REPLACE PROCEDURE sp_registrar_medicao_validada(
    p_id_reservatorio INT,
    p_id_parametro INT,
    p_valor NUMERIC,
    p_data_hora TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validação de valor negativo
    IF p_valor < 0 THEN
        RAISE EXCEPTION 'ERRO: valor negativo não permitido. Valor enviado: %', p_valor;
    END IF;

    INSERT INTO serie_temporal (
        id_reservatorio, id_parametro, valor, data_hora
    ) VALUES (
        p_id_reservatorio, p_id_parametro, p_valor, p_data_hora
    );

    RAISE NOTICE 'Medição validada registrada com sucesso.';
END;
$$;

-- ====================================================
-- FIM DO ARQUIVO LIMNOLOGIA
-- ====================================================
