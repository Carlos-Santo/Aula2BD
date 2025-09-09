/* ============================================================
    0. EXCLUSÃO DAS TABELAS (DROP TABLE)
   ============================================================ */

DROP TABLE IF EXISTS notas;

DROP TABLE IF EXISTS alunos;

DROP TABLE IF EXISTS cursos;


/* ============================================================
    1. CRIAÇÃO DAS TABELAS
   ============================================================ */

CREATE TABLE cursos (
    id_curso SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE alunos (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT,
    id_curso INT REFERENCES cursos(id_curso)
);

CREATE TABLE notas (
    id_nota INT PRIMARY KEY,
    disciplina VARCHAR(100) NOT NULL,
    nota FLOAT,
    id_aluno INT REFERENCES alunos(id_aluno)
);

/* ============================================================
    2. INSERÇÃO DE DADOS
   ============================================================ */

-- 2.1 Inserção de Cursos
INSERT INTO cursos (nome) VALUES 
    ('Engenharia'),
    ('Análise de Sistemas'),
    ('Computação'),
    ('Matemática');

-- 2.2 Inserção de Alunos
INSERT INTO alunos (nome, idade, id_curso) VALUES 
    ('João Silva', 22, 1),
    ('Marina Lima', 16, 3),
    ('Maria Souza', 20, 3),
    ('Carlos Lima', 25, 4),
    ('Lucas Pereira', 18, 3),
    ('Carlos Almeida', 21, 1),
    ('Fernanda Costa', 19, 3), 
	('Roberta Dias', 20, NULL);

-- 2.3 Inserção de Notas
INSERT INTO notas (id_nota, id_aluno, disciplina, nota) VALUES 
    (101, 1, 'Matemática', 8.5),
    (102, 2, 'História', 9.0);


/* ============================================================
    3. ATUALIZAÇÕES
   ============================================================ */

UPDATE alunos 
SET idade = 16 
WHERE nome = 'João Silva';

UPDATE alunos 
SET idade = 17, id_curso = 1 
WHERE nome = 'Marina Lima';

/* ============================================================
    4. CONSULTAS
   ============================================================ */

-- 4.1 Consultar todas as tabelas
SELECT * FROM cursos;
SELECT * FROM alunos;

-- 4.2 INNER JOIN entre alunos e notas
SELECT alunos.nome, notas.disciplina, notas.nota
FROM alunos
INNER JOIN notas ON alunos.id_aluno = notas.id_aluno;

-- 4.3 LEFT JOIN entre alunos e notas
SELECT alunos.nome, notas.disciplina, notas.nota
FROM alunos
LEFT JOIN notas ON alunos.id_aluno = notas.id_aluno;

/* ============================================================
    5. EXERCÍCIOS
   ============================================================ */

-- 5.1 Tabela com nome do aluno e nome do curso usando INNER JOIN
SELECT alunos.nome, cursos.nome AS curso
FROM alunos
INNER JOIN cursos ON alunos.id_curso = cursos.id_curso;

-- 5.2 Tabela com nome do aluno e nome do curso usando LEFT JOIN
SELECT alunos.nome, cursos.nome AS curso
FROM alunos
LEFT JOIN cursos ON alunos.id_curso = cursos.id_curso;
