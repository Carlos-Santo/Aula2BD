-- ================================================================
-- ATIVIDADE
-- Inserir um novo cliente chamado "Carlos Santos"
-- Criar uma nova conta vinculada a este cliente
-- Realizar uma transferência de R$ 100,00 da conta 000123 (João)
-- para a conta 000789 (Carlos)
-- Atualizar os saldos das contas envolvidas
-- Listar todas as contas com saldos atualizados
-- ================================================================
 
 
-- ================================================================
-- EXCLUSÃO DE TABELAS ANTIGAS
-- ================================================================
DROP TABLE IF EXISTS transacoes;
DROP TABLE IF EXISTS contas;
DROP TABLE IF EXISTS clientes;
 
 
-- ================================================================
-- CRIAÇÃO DAS TABELAS
-- ================================================================
 
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    endereco TEXT,
    telefone VARCHAR(15)
);
 
CREATE TABLE contas (
    id_conta SERIAL PRIMARY KEY,
    numero_conta VARCHAR(10) UNIQUE NOT NULL,
    saldo DECIMAL(10,2) DEFAULT 0,
    id_cliente INT REFERENCES clientes(id_cliente) ON DELETE CASCADE
);
 
CREATE TABLE transacoes (
    id_transacao SERIAL PRIMARY KEY,
    id_conta INT REFERENCES contas(id_conta) ON DELETE CASCADE,
    tipo VARCHAR(15) CHECK (tipo IN ('Depósito', 'Saque', 'Transferência')),
    valor DECIMAL(10,2) NOT NULL CHECK (valor > 0),
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    destino_transferencia INT REFERENCES contas(id_conta)
);
 
 
-- ================================================================
-- INSERTS INICIAIS
-- ================================================================
 
-- Inserindo dois clientes iniciais
INSERT INTO clientes (nome, cpf, endereco, telefone)
VALUES
('João Silva', '12345678900', 'Rua A, 123', '11999990000'),
('Maria Oliveira', '98765432100', 'Rua B, 456', '11988887777');
 
-- Criando contas para os clientes João e Maria
INSERT INTO contas (numero_conta, saldo, id_cliente)
VALUES
('000123', 1500.00, 1),
('000456', 2300.00, 2);
 
-- Registrando transações iniciais (depósito, saque e transferência sem destino)
INSERT INTO transacoes (id_conta, tipo, valor)
VALUES
(1, 'Depósito', 500.00),
(2, 'Saque', 200.00),
(1, 'Transferência', 300.00);
 
 
-- ================================================================
-- ATIVIDADE: CLIENTE E CONTA NOVOS + TRANSFERÊNCIA
-- ================================================================
 
-- Inserindo novo cliente Carlos Santos
INSERT INTO clientes (nome, cpf, endereco, telefone)
VALUES ('Carlos Santos', '11122233344', 'Rua C, 789', '11977776666');
 
-- Criando conta para o novo cliente Carlos (id_cliente = 3)
INSERT INTO contas (numero_conta, saldo, id_cliente)
VALUES ('000789', 1000.00, 3);
 
-- Registrando uma transferência de João (id_conta = 1) para Carlos (id_conta = 3)
INSERT INTO transacoes (id_conta, tipo, valor, destino_transferencia)
VALUES (1, 'Transferência', 100.00, 3);
 
-- Atualizando saldo da conta do João (000123), debitando R$100
UPDATE contas
SET saldo = saldo - 100.00
WHERE numero_conta = '000123';
 
-- Atualizando saldo da conta do Carlos (000789), creditando R$100
UPDATE contas
SET saldo = saldo + 100.00
WHERE numero_conta = '000789';
 
 
-- ================================================================
-- ATUALIZAÇÕES EXEMPLO
-- ================================================================
 
-- Exemplo: adicionando R$500 na conta do João
UPDATE contas
SET saldo = saldo + 500.00
WHERE id_conta = 1;
 
 
-- ================================================================
-- EXCLUSÕES
-- ================================================================
 
-- Exemplo: removendo Maria do sistema
DELETE FROM clientes WHERE id_cliente = 2;
 
 
-- ================================================================
-- CONSULTAS
-- ================================================================
 
-- Listando todos os clientes
SELECT * FROM clientes;
 
-- Listando todas as contas com o nome do cliente e saldo
SELECT contas.numero_conta, clientes.nome, contas.saldo
FROM contas
INNER JOIN clientes ON contas.id_cliente = clientes.id_cliente;
 
-- Listando todas as transações, mostrando origem e destino (se houver)
SELECT transacoes.tipo, transacoes.valor, transacoes.data_transacao,
       contas.numero_conta AS origem,
       c2.numero_conta AS destino
FROM transacoes
INNER JOIN contas ON transacoes.id_conta = contas.id_conta
LEFT JOIN contas c2 ON transacoes.destino_transferencia = c2.id_conta;
 