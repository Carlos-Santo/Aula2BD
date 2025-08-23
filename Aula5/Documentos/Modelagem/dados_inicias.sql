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

-- Tipos de Evento
INSERT INTO tipo_evento (nome, descricao) VALUES
('Queimada', 'Incêndio florestal em área de vegetação'),
('Enchente', 'Acúmulo excessivo de água causado por chuvas'),
('Deslizamento', 'Desmoronamento de terra em áreas inclinadas'),
('Tempestade', 'Fenômeno climático com ventos fortes e chuva intensa');

-- Estados
INSERT INTO estado (sigla_estado, nome_estado) VALUES
('SP', 'São Paulo'),
('RJ', 'Rio de Janeiro'),
('MG', 'Minas Gerais');

-- Localizações
INSERT INTO localizacao (latitude, longitude, cidade, sigla_estado) VALUES
(-23.550520, -46.633308, 'São Paulo', 'SP'),
(-22.906847, -43.172896, 'Rio de Janeiro', 'RJ'),
(-19.916681, -43.934493, 'Belo Horizonte', 'MG');

-- Usuários
INSERT INTO usuario (nome, email, senha_hash) VALUES
('Ana Silva', 'ana.silva@email.com', 'hashsenha1'),
('Bruno Lima', 'bruno.lima@email.com', 'hashsenha2'),
('Carlos Souza', 'carlos.souza@email.com', 'hashsenha3');

-- Telefones
INSERT INTO telefone (numero, id_usuario) VALUES
('11999999999', 1),
('21988888888', 2),
('31977777777', 3);

-- Eventos
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao) VALUES
('Foco de queimada em parque estadual', 'Área com fumaça densa e fogo visível', '2025-08-20 15:30:00', 'Ativo', 1, 1),
('Alagamento em zona urbana', 'Ruas completamente inundadas', '2025-08-21 10:00:00', 'Em Monitoramento', 2, 2),
('Deslizamento de terra em morro', 'Parte do morro desceu após chuva forte', '2025-08-19 08:15:00', 'Resolvido', 3, 3);

-- Relatos
INSERT INTO relato (texto, data_hora, id_evento, id_usuario) VALUES
('Fumaça visível a quilômetros de distância.', '2025-08-20 16:00:00', 1, 1),
('Carros submersos até a metade.', '2025-08-21 10:15:00', 2, 2),
('Terreno cedeu próximo às casas.', '2025-08-19 09:00:00', 3, 3);

-- Alertas
INSERT INTO alerta (mensagem, data_hora, nivel, id_evento) VALUES
('Evacuação imediata recomendada.', '2025-08-20 16:30:00', 'Crítico', 1),
('Evite transitar na área afetada.', '2025-08-21 10:30:00', 'Alto', 2),
('Situação sob controle, área liberada.', '2025-08-19 11:00:00', 'Médio', 3);

-- ========================================
-- CONSULTAS
-- ========================================

-- Eventos Ativos
SELECT titulo, status 
FROM evento 
WHERE status = 'Ativo';

-- Eventos Em Monitoramento
SELECT titulo, data_hora, status 
FROM evento
WHERE status = 'Em Monitoramento';

-- Telefones do usuário 1
SELECT numero 
FROM telefone
WHERE id_usuario = 1;
