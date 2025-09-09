-- Criação do Banco de Dados
CREATE DATABASE clima_alerta;


-- ========================================
-- DROP DAS TABELAS (NA ORDEM CERTA)
-- ========================================
DROP TABLE IF EXISTS alerta;
DROP TABLE IF EXISTS relato;
DROP TABLE IF EXISTS evento;
DROP TABLE IF EXISTS telefone;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS localizacao;
DROP TABLE IF EXISTS estado;
DROP TABLE IF EXISTS tipo_evento;

-- ========================================
-- CRIAÇÃO DAS TABELAS
-- ========================================

-- Tabela de Tipos de Evento
CREATE TABLE tipo_evento (
    id_tipo_evento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- Tabela de Estados
CREATE TABLE estado (
    sigla_estado CHAR(2) PRIMARY KEY,
    nome_estado VARCHAR(100) NOT NULL
);

-- Tabela de Localização
CREATE TABLE localizacao (
    id_localizacao SERIAL PRIMARY KEY,
    latitude NUMERIC(9,6) NOT NULL,
    longitude NUMERIC(9,6) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    sigla_estado CHAR(2) NOT NULL REFERENCES estado(sigla_estado)
);

-- Tabela de Usuários
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL
);

-- Tabela de Telefones do Usuário
CREATE TABLE telefone (
    id_telefone SERIAL PRIMARY KEY,
    numero VARCHAR(20) NOT NULL,
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

-- Tabela de Eventos
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_hora TIMESTAMP NOT NULL,
    status VARCHAR(30) CHECK (status IN ('Ativo','Em Monitoramento','Resolvido')),
    id_tipo_evento INT NOT NULL REFERENCES tipo_evento(id_tipo_evento),
    id_localizacao INT NOT NULL REFERENCES localizacao(id_localizacao)
);

-- Tabela de Relatos
CREATE TABLE relato (
    id_relato SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    id_evento INT NOT NULL REFERENCES evento(id_evento),
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

-- Tabela de Alertas
CREATE TABLE alerta (
    id_alerta SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    nivel VARCHAR(20) CHECK (nivel IN ('Baixo','Médio','Alto','Crítico')),
    id_evento INT NOT NULL REFERENCES evento(id_evento)
);

-- ========================================
-- INSERÇÃO DE DADOS
-- ========================================

-- Inserir o tipo de evento "Queimada"
INSERT INTO tipo_evento (nome, descricao)
VALUES ('Queimada', 'Incêndio florestal ou queimada em área urbana ou rural.');

-- Inserir o estado Tocantins
INSERT INTO estado (sigla_estado, nome_estado)
VALUES ('TO', 'Tocantins');

-- Inserir a localização em Palmas - TO
INSERT INTO localizacao (latitude, longitude, cidade, sigla_estado)
VALUES (-10.1852, -48.3336, 'Palmas', 'TO');

-- Inserir dois eventos do tipo "Queimada" em Palmas
-- Supondo que o id_tipo_evento para "Queimada" seja 1 e id_localizacao de Palmas seja 1
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao)
VALUES 
('Foco de Queimada na Zona Rural', 'Incêndio de média proporção identificado por satélite.', '2025-08-20 13:45:00', 'Em Monitoramento', 1, 1),
('Queimada próxima à BR-153', 'Fumaça visível na rodovia, risco à visibilidade de veículos.', '2025-08-22 16:20:00', 'Ativo', 1, 1);

-- ========================================
-- CONSULTAS
-- ========================================

-- Consulta: eventos do tipo "Queimada" ordenados por data/hora
SELECT * FROM evento
WHERE id_tipo_evento = 1
ORDER BY data_hora DESC;

-- Consulta: os 3 eventos de queimada mais recentes
SELECT * FROM evento
WHERE id_tipo_evento = 1
ORDER BY data_hora DESC
LIMIT 3;
