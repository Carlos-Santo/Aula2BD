-- Criação do schema
CREATE SCHEMA INPEApp;

-- Tabela de usuários (população)
CREATE TABLE INPEApp.Usuario (
    idUsuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela de eventos ambientais
CREATE TABLE INPEApp.EventoAmbiental (
    idEvento SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,  -- Ex: 'Queimada', 'Inundação', etc.
    descricao TEXT,
    dataEvento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    idUsuario INT NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES INPEApp.Usuario(idUsuario)
);

-- Tabela de alertas enviados com base em eventos
CREATE TABLE INPEApp.Alerta (
    idAlerta SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    mensagem TEXT NOT NULL,
    dataEnvio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idEvento INT NOT NULL,
    FOREIGN KEY (idEvento) REFERENCES INPEApp.EventoAmbiental(idEvento)
);

-- Tabela de evidências (fotos, vídeos, etc.)
CREATE TABLE INPEApp.Evidencia (
    idEvidencia SERIAL PRIMARY KEY,
    urlArquivo TEXT NOT NULL,
    descricao TEXT,
    idEvento INT NOT NULL,
    FOREIGN KEY (idEvento) REFERENCES INPEApp.EventoAmbiental(idEvento)
);
