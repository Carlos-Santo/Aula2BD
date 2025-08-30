-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- --
-- -=-=-=-=-=-=-=         Drop table         -=-=-=-=-=-=-=-=-=-=-= --
-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- --

-- Remover tabelas antigas se já existirem
DROP TABLE IF EXISTS saques;
DROP TABLE IF EXISTS contas;
DROP TABLE IF EXISTS clientes;

-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- --
-- -=-=-=-=-=-=-=- Criação das tabelas table  -=-=-=-=-=-=-=-=-=-=-=- --
-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- --

-- Criar tabelas
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL
);

CREATE TABLE contas (
    id_conta SERIAL PRIMARY KEY,
    id_cliente INT,
    saldo NUMERIC(10,2) DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE saques (
    id_saque SERIAL PRIMARY KEY,
    id_conta INT,
    valor NUMERIC(10,2) NOT NULL,
    data_saque DATE,
    FOREIGN KEY (id_conta) REFERENCES contas(id_conta)
);

-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- --
-- -=-=-=-=-=-=-=     Inserção de Dados      -=-=-=-=-=-=-=-=-=-=-= --
-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- --

-- Inserindo clientes
INSERT INTO clientes (nome, cpf) VALUES
('Ana Souza', '111.111.111-11'),
('Carlos Pereira', '222.222.222-22'),
('Mariana Lima', '333.333.333-33'),
('João Silva', '444.444.444-44');

-- Inserindo contas
INSERT INTO contas (id_cliente, saldo) VALUES
(1, 1500.00),
(2, 2300.50),
(3, 500.75),
(4, 10000.00);

-- Inserindo saques
INSERT INTO saques (id_conta, valor, data_saque) VALUES
(1, 200.00, '2025-08-01'),
(1, 150.00, '2025-08-15'),
(2, 500.00, '2025-08-10'),
(3, 50.00, '2025-08-20'),
(4, 1000.00, '2025-08-25');

-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- --
-- -=-=-=-=-=-=-     Consultas dos Dados      -=-=-=-=-=-=-=-=-=-=- --
-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- --

-- 1. Contar quantos clientes estão cadastrados
SELECT COUNT(*) AS total_clientes
FROM clientes;

-- 2. Calcular o saldo total armazenado no banco
SELECT SUM(saldo) AS saldo_total
FROM contas;

-- 3. Descobrir a média dos saques feitos
SELECT AVG(valor) AS media_saques
FROM saques;
