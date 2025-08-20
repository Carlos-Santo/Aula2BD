-- Criação do schema
CREATE SCHEMA Biblioteca;

-- Tabela Autor
CREATE TABLE Biblioteca.Autor (
    idAutor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50)
);

-- Tabela Livro
CREATE TABLE Biblioteca.Livro (
    idLivro SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    anoPublicacao INT,
    isbn VARCHAR(20)
);

-- Tabela Cliente
CREATE TABLE Biblioteca.Cliente (
    idCliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20)
);

-- Tabela Emprestimo
CREATE TABLE Biblioteca.Emprestimo (
    idEmprestimo SERIAL PRIMARY KEY,
    dataEmprestimo DATE NOT NULL,
    dataDevolucao DATE,
    idCliente INT,
    FOREIGN KEY (idCliente) REFERENCES Biblioteca.Cliente(idCliente)
);

-- Tabela associativa LivroAutor (Relacionamento N:M entre Livro e Autor)
CREATE TABLE Biblioteca.LivroAutor (
    idLivro INT,
    idAutor INT,
    PRIMARY KEY (idLivro, idAutor),
    FOREIGN KEY (idLivro) REFERENCES Biblioteca.Livro(idLivro),
    FOREIGN KEY (idAutor) REFERENCES Biblioteca.Autor(idAutor)
);

-- Tabela associativa EmprestimoLivro (Relacionamento N:M entre Emprestimo e Livro)
CREATE TABLE Biblioteca.EmprestimoLivro (
    idEmprestimo INT,
    idLivro INT,
    PRIMARY KEY (idEmprestimo, idLivro),
    FOREIGN KEY (idEmprestimo) REFERENCES Biblioteca.Emprestimo(idEmprestimo),
    FOREIGN KEY (idLivro) REFERENCES Biblioteca.Livro(idLivro)
);
