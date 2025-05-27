--------------------------------------------------------------------------------- CORRIGIDO --------------------------
DROP DATABASE UniversidadeSaintGabriel;

CREATE DATABASE UniversidadeSaintGabriel; 
USE UniversidadeSaintGabriel;

-- Departamento
CREATE TABLE Departamento (
    cod_departamento INT PRIMARY KEY IDENTITY,
    nome_departamento VARCHAR(255) NOT NULL
);
GO

-- Professor
CREATE TABLE Professor (
    cod_professor INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nome_professor VARCHAR(255) NOT NULL,
    sobrenome_professor VARCHAR(255) NOT NULL,
    data_nascimento DATE NOT NULL,
    identificacao_genero VARCHAR(50) NULL,
    data_contratacao DATE NOT NULL, 
    tipo_vinculo VARCHAR(50) NOT NULL,
    CPF VARCHAR(14) NOT NULL UNIQUE,
    RG VARCHAR(20) NOT NULL UNIQUE,
    titulacao VARCHAR(50) NOT NULL,
    email_pessoal VARCHAR(255) NULL CHECK (email_pessoal LIKE '%@%.%'),
    email_corporativo VARCHAR(255) NULL CHECK (email_corporativo LIKE '%@%.%'),
    cod_departamento INT NOT NULL,
    status_professor VARCHAR(50) NOT NULL,
    cod_endereco INT NOT NULL,
    cod_telefone INT NOT NULL
);
GO

-- Curso
CREATE TABLE Curso (
    cod_curso INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nome_curso VARCHAR(255) NOT NULL,
    tipo_curso VARCHAR(255) NOT NULL,
    duracao_meses INT NOT NULL,
    cod_departamento INT NOT NULL,
    turno VARCHAR(50) NULL,
    carga_horaria_total INT NOT NULL,
    modalidade VARCHAR(50) NOT NULL CHECK (modalidade IN ('Presencial', 'EAD', 'Híbrido', 'Integral')),
    cod_prof_coordenador INT NOT NULL
);
GO

-- Disciplina
CREATE TABLE Disciplina (
    cod_disciplina INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nome_disciplina VARCHAR(255) NOT NULL,
    ementa VARCHAR(MAX) NOT NULL,
    cod_departamento INT NOT NULL,
    carga_horaria INT NOT NULL CHECK (carga_horaria > 0)
);
GO

-- Turma
CREATE TABLE Turma (
    cod_turma INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    cod_curso INT NOT NULL,
    sala VARCHAR(50) NOT NULL,
    ano INT NOT NULL,
    semestre INT NOT NULL,
    cod_disciplina INT NOT NULL,
    cod_professor INT NOT NULL,
    periodo VARCHAR(50) NOT NULL,
    num_alunos INT NOT NULL CHECK (num_alunos >= 0),
    data_inicio DATE NOT NULL,
    data_fim DATE NULL,
    CHECK (data_fim IS NULL OR data_fim > data_inicio)
);
GO

-- Aluno
CREATE TABLE Aluno (
    RA_aluno INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    nome_aluno VARCHAR(255) NOT NULL,
    sobrenome_aluno VARCHAR(255) NOT NULL,
    data_nascimento DATE NOT NULL,
    genero VARCHAR(50) NULL,
    CPF VARCHAR(14) NOT NULL UNIQUE,
    RG VARCHAR(20) NOT NULL UNIQUE,
    email_pessoal VARCHAR(60) NOT NULL CHECK (email_pessoal LIKE '%@%.%'),
    email_corporativo VARCHAR(60) NULL CHECK (email_corporativo LIKE '%@%.%'),
    status_aluno VARCHAR(50) NOT NULL,
    data_ingresso DATE NOT NULL,
    cod_curso INT NOT NULL,
    deficiencia VARCHAR(3) NOT NULL CHECK (deficiencia IN ('sim','não')),
    tipo_deficiencia VARCHAR(100) NULL,
    nome_mae VARCHAR(255) NULL,
    nome_pai VARCHAR(255) NULL,
    cod_endereco INT NOT NULL,
    cod_telefone INT NOT NULL
);
GO

-- Endereco_Aluno
CREATE TABLE Endereco_Aluno (
    cod_endereco INT PRIMARY KEY IDENTITY(1,1),
    RA_aluno INT NOT NULL,
    rua VARCHAR(100) NOT NULL,
    numero_residencial INT NOT NULL CHECK (numero_residencial > 0),
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado CHAR(2) NOT NULL,
    CEP VARCHAR(9) NOT NULL CHECK (CEP LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]'),
    complemento VARCHAR(100) NULL
);
GO

-- Telefone_Aluno
CREATE TABLE Telefone_Aluno (
    cod_telefone INT PRIMARY KEY IDENTITY(1,1),
    RA_aluno INT NOT NULL,
    num_telefone VARCHAR(20) NULL,
    tipo_telefone VARCHAR(20) NULL
);
GO

-- Endereco_Professor
CREATE TABLE Endereco_Professor (
    cod_endereco INT PRIMARY KEY IDENTITY(1,1),
    cod_professor INT NOT NULL,
    rua VARCHAR(100) NOT NULL,
    numero_residencial INT NOT NULL CHECK (numero_residencial > 0),
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado CHAR(2) NOT NULL,
    CEP VARCHAR(9) NOT NULL,
    complemento VARCHAR(100) NULL
);
GO

-- Telefone_Professor
CREATE TABLE Telefone_Professor (
    cod_telefone INT PRIMARY KEY IDENTITY(1,1),
    cod_professor INT NOT NULL,
    num_telefone VARCHAR(20) NULL,
    tipo_telefone VARCHAR(20) NULL
);
GO

-- Historico_Escolar
CREATE TABLE Historico_Escolar (
    cod_disciplina INT NOT NULL,
    RA_aluno INT NOT NULL,
    ano INT NOT NULL,
    semestre INT NOT NULL CHECK (semestre IN (1,2)),
    nota DECIMAL(4,2) NOT NULL CHECK (nota BETWEEN 0 AND 10),
    frequencia FLOAT NOT NULL CHECK (frequencia BETWEEN 0 AND 100),
    situacao_historico VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Historico_Escolar PRIMARY KEY (cod_disciplina, RA_aluno, ano, semestre)
);
GO

-- Matricula
CREATE TABLE Matricula (
    cod_matricula INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    RA_aluno INT NOT NULL,
    cod_turma INT NOT NULL,
    data_matricula DATE NOT NULL,
    data_cancelamento DATE NULL,
    CHECK (data_cancelamento IS NULL OR data_cancelamento > data_matricula),
    status_matricula VARCHAR(50) NOT NULL,
    motivo_cancelamento VARCHAR(MAX) NULL
);
GO

-- Curso_Disciplina
CREATE TABLE Curso_Disciplina (
    cod_curso INT NOT NULL,
    cod_disciplina INT NOT NULL,
    tipo_disciplina VARCHAR(50) NOT NULL CHECK (tipo_disciplina IN ('Obrigatória','Optativa')),
    PRIMARY KEY (cod_curso, cod_disciplina)
);
GO

-- Professor_Disciplina
CREATE TABLE Professor_Disciplina (
    cod_professor INT NOT NULL,
    cod_disciplina INT NOT NULL,
    PRIMARY KEY (cod_professor, cod_disciplina)
);
GO

-- Aluno_Disciplina
CREATE TABLE Aluno_Disciplina (
    RA_aluno INT NOT NULL,
    cod_disciplina INT NOT NULL,
    PRIMARY KEY (RA_aluno, cod_disciplina)
);
GO

-- Disciplina_PreRequisito
CREATE TABLE Disciplina_PreRequisito (
    cod_disciplina INT NOT NULL,
    cod_prerequisito INT NOT NULL,
    PRIMARY KEY (cod_disciplina, cod_prerequisito),
    CHECK (cod_disciplina <> cod_prerequisito)
);
GO

-- Adicionando as foreign keys (depois que todas as tabelas existem e inserido os dados)
ALTER TABLE Professor ADD FOREIGN KEY (cod_departamento) REFERENCES Departamento(cod_departamento);
ALTER TABLE Professor ADD FOREIGN KEY (cod_endereco) REFERENCES Endereco_Professor(cod_endereco);
ALTER TABLE Professor ADD FOREIGN KEY (cod_telefone) REFERENCES Telefone_Professor(cod_telefone);

ALTER TABLE Curso ADD FOREIGN KEY (cod_departamento) REFERENCES Departamento(cod_departamento);
ALTER TABLE Curso ADD FOREIGN KEY (cod_prof_coordenador) REFERENCES Professor(cod_professor);

ALTER TABLE Turma ADD FOREIGN KEY (cod_curso) REFERENCES Curso(cod_curso);
ALTER TABLE Turma ADD FOREIGN KEY (cod_disciplina) REFERENCES Disciplina(cod_disciplina);
ALTER TABLE Turma ADD FOREIGN KEY (cod_professor) REFERENCES Professor(cod_professor);

ALTER TABLE Aluno ADD FOREIGN KEY (cod_curso) REFERENCES Curso(cod_curso);
ALTER TABLE Aluno ADD FOREIGN KEY (cod_endereco) REFERENCES Endereco_Aluno(cod_endereco);
ALTER TABLE Aluno ADD FOREIGN KEY (cod_telefone) REFERENCES Telefone_Aluno(cod_telefone);

ALTER TABLE Endereco_Aluno ADD FOREIGN KEY (RA_aluno) REFERENCES Aluno(RA_aluno);
ALTER TABLE Telefone_Aluno ADD FOREIGN KEY (RA_aluno) REFERENCES Aluno(RA_aluno);
ALTER TABLE Endereco_Professor ADD FOREIGN KEY (cod_professor) REFERENCES Professor(cod_professor);
ALTER TABLE Telefone_Professor ADD FOREIGN KEY (cod_professor) REFERENCES Professor(cod_professor);

ALTER TABLE Historico_Escolar ADD FOREIGN KEY (cod_disciplina) REFERENCES Disciplina(cod_disciplina);
ALTER TABLE Historico_Escolar ADD FOREIGN KEY (RA_aluno) REFERENCES Aluno(RA_aluno);

ALTER TABLE Matricula ADD FOREIGN KEY (RA_aluno) REFERENCES Aluno(RA_aluno);
ALTER TABLE Matricula ADD FOREIGN KEY (cod_turma) REFERENCES Turma(cod_turma);

ALTER TABLE Curso_Disciplina ADD FOREIGN KEY (cod_curso) REFERENCES Curso(cod_curso);
ALTER TABLE Curso_Disciplina ADD FOREIGN KEY (cod_disciplina) REFERENCES Disciplina(cod_disciplina);

ALTER TABLE Professor_Disciplina ADD FOREIGN KEY (cod_professor) REFERENCES Professor(cod_professor);
ALTER TABLE Professor_Disciplina ADD FOREIGN KEY (cod_disciplina) REFERENCES Disciplina(cod_disciplina);

ALTER TABLE Aluno_Disciplina ADD FOREIGN KEY (RA_aluno) REFERENCES Aluno(RA_aluno);
ALTER TABLE Aluno_Disciplina ADD FOREIGN KEY (cod_disciplina) REFERENCES Disciplina(cod_disciplina);

ALTER TABLE Disciplina_PreRequisito ADD FOREIGN KEY (cod_disciplina) REFERENCES Disciplina(cod_disciplina);
ALTER TABLE Disciplina_PreRequisito ADD FOREIGN KEY (cod_prerequisito) REFERENCES Disciplina(cod_disciplina);
GO

-- Novos Dados de Inserção (Todos em São Paulo)

/*--------------------------------------------------------------
   1. Dados para a tabela Departamento
--------------------------------------------------------------*/
INSERT INTO Departamento (nome_departamento)
VALUES
    ('Letras e Linguística'),        -- ID 1
    ('Ciências Exatas e Tecnologia'),-- ID 2
    ('Ciências Humanas e Sociais'),  -- ID 3
    ('Artes e Design'),              -- ID 4
    ('Ciências da Saúde');           -- ID 5
GO

/*--------------------------------------------------------------
   2. Dados para a tabela Endereco_Professor
   (Todos em São Paulo)
--------------------------------------------------------------*/
INSERT INTO Endereco_Professor (cod_professor, rua, numero_residencial, bairro, cidade, estado, CEP, complemento)
VALUES
(1, 'Rua Augusta', 1250, 'Consolação', 'São Paulo', 'SP', '01304-001', 'Apto 101'),
(2, 'Avenida Brigadeiro Faria Lima', 4500, 'Itaim Bibi', 'São Paulo', 'SP', '04538-132', 'Conjunto 82'),
(3, 'Rua Oscar Freire', 800, 'Jardins', 'São Paulo', 'SP', '01426-000', NULL),
(4, 'Rua Harmonia', 350, 'Vila Madalena', 'São Paulo', 'SP', '05435-000', 'Casa Amarela'),
(5, 'Avenida Engenheiro Luís Carlos Berrini', 1700, 'Brooklin', 'São Paulo', 'SP', '04571-000', 'Andar 12');
GO

/*--------------------------------------------------------------
   3. Dados para a tabela Telefone_Professor
--------------------------------------------------------------*/
INSERT INTO Telefone_Professor (cod_professor, num_telefone, tipo_telefone)
VALUES
(1, '(11) 98877-1001', 'Celular'),
(2, '(11) 3030-2002', 'Comercial'),
(3, '(11) 99900-3003', 'Celular'),
(4, '(11) 3223-4004', 'Residencial'),
(5, '(11) 97654-5005', 'Celular');
GO

/*--------------------------------------------------------------
   4. Dados para a tabela Professor
   (cod_endereco e cod_telefone devem corresponder aos IDs gerados acima)
--------------------------------------------------------------*/
INSERT INTO Professor (
    nome_professor, sobrenome_professor, data_nascimento, identificacao_genero,
    data_contratacao, tipo_vinculo, CPF, RG, titulacao,
    email_pessoal, email_corporativo, cod_departamento, status_professor,
    cod_endereco, cod_telefone
)
VALUES
('Beatriz', 'Alves', '1975-03-12', 'Feminino', '2002-08-01', 'Efetivo', '111.222.333-44', '20.123.456-1', 'Doutora', 'beatriz.alves@email.com', 'b.alves@univer.edu', 1, 'Ativo', 1, 1),
('Ricardo', 'Mendes', '1980-11-25', 'Masculino', '2005-02-15', 'Efetivo', '222.333.444-55', '21.234.567-2', 'Mestre', 'ricardo.mendes@email.com', 'r.mendes@univer.edu', 2, 'Ativo', 2, 2),
('Fernanda', 'Barros', '1968-07-01', 'Feminino', '1999-03-10', 'Efetivo', '333.444.555-66', '22.345.678-3', 'Doutora', 'fernanda.barros@email.com', 'f.barros@univer.edu', 3, 'Ativo', 3, 3),
('Alexandre', 'Pinto', '1985-01-30', 'Masculino', '2010-07-20', 'Contratado', '444.555.666-77', '23.456.789-4', 'Mestre', 'alexandre.pinto@email.com', 'a.pinto@univer.edu', 4, 'Licença',4, 4),
('Juliana', 'Castro', '1979-09-17', 'Feminino', '2008-01-05', 'Efetivo', '555.666.777-88', '24.567.890-5', 'Doutora', 'juliana.castro@email.com', 'j.castro@univer.edu', 5, 'Ativo',5, 5);
GO

/*--------------------------------------------------------------
   5. Dados para a tabela Curso
--------------------------------------------------------------*/
INSERT INTO Curso (
	nome_curso, tipo_curso, duracao_meses, cod_departamento,
	turno, carga_horaria_total, modalidade, cod_prof_coordenador
)
VALUES
  ('Letras - Português/Espanhol', 'Licenciatura', 48, 1, 'Noturno', 2800, 'Presencial', 1),
  ('Análise e Desenvolvimento de Sistemas', 'Tecnólogo', 30, 2, 'Matutino', 2000, 'EAD', 2),
  ('Sociologia', 'Bacharelado', 48, 3, 'Vespertino', 2900, 'Presencial', 3),
  ('Produção Audiovisual', 'Tecnólogo', 24, 4, 'Noturno', 1800, 'Híbrido', 4),
  ('Fisioterapia', 'Bacharelado', 60, 5, 'Integral', 3800, 'Presencial', 5),
  ('Ciência de Dados', 'Bacharelado', 48, 2, 'Integral', 3200, 'Presencial', 2);
GO

/*--------------------------------------------------------------
   6. Dados para a tabela Disciplina
--------------------------------------------------------------*/
INSERT INTO Disciplina (nome_disciplina, ementa, cod_departamento, carga_horaria)
VALUES
    ('Gramática Normativa da Língua Portuguesa', 'Estudo aprofundado das regras gramaticais do português.', 1, 60),
    ('Desenvolvimento Web Full Stack', 'Criação de aplicações web completas, do front-end ao back-end.', 2, 90),
    ('Teorias Sociológicas Clássicas', 'Análise dos principais pensadores da sociologia.', 3, 60),
    ('Roteiro e Narrativa para Cinema e TV', 'Técnicas de escrita de roteiros e construção de narrativas.', 4, 70),
    ('Cinesiologia e Biomecânica', 'Estudo do movimento humano e suas aplicações na fisioterapia.', 5, 80),
    ('Modelagem Estatística e Inferência', 'Métodos estatísticos para análise e interpretação de dados.', 2, 80),
    ('Literatura Espanhola Moderna', 'Obras e autores significativos da literatura espanhola.', 1, 60),
    ('Banco de Dados NoSQL', 'Conceitos e aplicações de bancos de dados não relacionais.', 2, 70),
    ('Fotografia e Iluminação em Estúdio', 'Técnicas de fotografia e controle de iluminação.', 4, 60);
GO

/*--------------------------------------------------------------
   7. Dados para a tabela Endereco_Aluno
   (Todos em São Paulo)
--------------------------------------------------------------*/
INSERT INTO Endereco_Aluno (RA_aluno, rua, numero_residencial, bairro, cidade, estado, CEP, complemento)
VALUES
(1, 'Rua Frei Caneca', 500, 'Cerqueira César', 'São Paulo', 'SP', '01307-000', 'Bloco A, Apto 22'),
(2, 'Avenida Angélica', 2000, 'Higienópolis', 'São Paulo', 'SP', '01228-200', 'Apto 1503'),
(3, 'Rua Teodoro Sampaio', 1100, 'Pinheiros', 'São Paulo', 'SP', '05406-050', 'Casa com portão verde'),
(4, 'Rua Vergueiro', 3500, 'Vila Mariana', 'São Paulo', 'SP', '04101-300', NULL),
(5, 'Avenida Santo Amaro', 6000, 'Santo Amaro', 'São Paulo', 'SP', '04702-002', 'Próximo ao metrô'),
(6, 'Rua da Mooca', 3000, 'Mooca', 'São Paulo', 'SP', '03104-002', 'Apto 7B');
GO

/*--------------------------------------------------------------
   8. Dados para a tabela Telefone_Aluno
--------------------------------------------------------------*/
INSERT INTO Telefone_Aluno (RA_aluno, num_telefone, tipo_telefone)
VALUES
    (1, '(11) 91122-0011', 'Celular'),
    (2, '(11) 92233-0022', 'Celular'),
    (3, '(11) 3344-0033', 'Residencial'),
    (4, '(11) 94455-0044', 'Celular'),
    (5, '(11) 95566-0055', 'Comercial'),
    (6, '(11) 2233-0066', 'Celular');
GO

/*--------------------------------------------------------------
   9. Dados para a tabela Aluno
   (cod_endereco e cod_telefone devem corresponder aos IDs gerados acima)
--------------------------------------------------------------*/
INSERT INTO Aluno
(
    nome_aluno, sobrenome_aluno, data_nascimento, genero, CPF, RG,
    email_pessoal, email_corporativo, status_aluno, data_ingresso, cod_curso,
    deficiencia, tipo_deficiencia, nome_mae, nome_pai,
    cod_endereco, cod_telefone
)
VALUES
('Anita', 'Malfatti', '2003-05-10', 'Feminino', '666.777.888-99', '30.111.222-X', 'anita.m@email.com', 'amalfatti@uni.edu', 'Ativo', '2021-02-01', 1, 'não', NULL, 'Eleonora Malfatti', 'Samuel Malfatti', 1, 1),
('Tarsila', 'do Amaral', '2002-12-01', 'Feminino', '777.888.999-00', '31.222.333-1', 'tarsila.a@email.com', 'tamaral@uni.edu', 'Ativo', '2020-07-15', 2, 'não', NULL, 'Lydia do Amaral', 'José do Amaral', 2, 2),
('Oswald', 'de Andrade', '2004-01-20', 'Masculino', '888.999.000-11', '32.333.444-2', 'oswald.a@email.com', 'oandrade@uni.edu', 'Trancado', '2022-02-01', 3, 'não', NULL, 'Inês de Andrade', 'José Oswald Nogueira de Andrade', 3, 3),
('Mário', 'de Andrade', '2003-08-15', 'Masculino', '999.000.111-22', '33.444.555-3', 'mario.a@email.com', 'mandrade@uni.edu', 'Ativo', '2021-07-10', 4, 'sim', 'Baixa Visão', 'Maria Luísa de Andrade', 'Carlos Augusto de Andrade', 4, 4),
('Candido', 'Portinari', '2002-03-25', 'Masculino', '000.111.222-33', '34.555.666-4', 'candido.p@email.com', 'cportinari@uni.edu', 'Ativo', '2020-02-01', 5, 'não', NULL, 'Eugenia Portinari', 'Batista Portinari', 5, 5),
('Di', 'Cavalcanti', '2004-07-05', 'Masculino', '112.233.445-56', '35.666.777-5', 'di.c@email.com', 'dcavalcanti@uni.edu', 'Formado', '2022-07-15', 6, 'não', NULL, 'Rosalia Cavalcanti', 'Emiliano de Albuquerque e Melo', 6, 6);
GO

/*--------------------------------------------------------------
   10. Dados para a tabela Turma
--------------------------------------------------------------*/
INSERT INTO Turma (
cod_curso, sala, ano, semestre, cod_disciplina, cod_professor, periodo, num_alunos, data_inicio, data_fim
)
VALUES
    (1, 'SL10', 2023, 1, 1, 1, 'Noturno', 33, '2023-02-20', '2023-07-05'),
    (2, 'LAB03', 2023, 1, 2, 2, 'Matutino', 28, '2023-02-20', '2023-07-05'),
    (3, 'AUD01', 2023, 2, 3, 3, 'Vespertino', 38, '2023-08-05', '2023-12-18'),
    (4, 'ESTUDIO_A', 2024, 1, 4, 4, 'Noturno', 22, '2024-02-15', '2024-06-25'),
    (5, 'CLIN02', 2024, 1, 5, 5, 'Integral', 30, '2024-02-15', '2024-06-25'),
    (6, 'LAB05', 2023, 2, 6, 2, 'Integral', 25, '2023-08-05', '2023-12-18'),
    (1, 'SL12', 2024, 1, 7, 1, 'Noturno', 35, '2024-02-20', '2024-07-05'),
    (2, 'LAB04', 2023, 2, 8, 2, 'Matutino', 20, '2023-08-05', '2023-12-18');
GO

/*--------------------------------------------------------------
   11. Dados para a tabela Historico_Escolar
--------------------------------------------------------------*/
INSERT INTO Historico_Escolar (cod_disciplina, RA_aluno, ano, semestre, nota, frequencia, situacao_historico)
VALUES
    (1, 1, 2023, 1, 8.5, 92.0, 'Aprovado'),
    (2, 2, 2023, 1, 7.0, 80.0, 'Aprovado'),
    (3, 3, 2023, 2, 4.5, 65.0, 'Reprovado'),
    (4, 4, 2024, 1, 9.2, 98.0, 'Aprovado'),
    (5, 5, 2024, 1, 6.0, 75.0, 'Aprovado'),
    (6, 6, 2023, 2, 9.8, 100.0, 'Aprovado com Distinção'),
    (7, 1, 2024, 1, 7.8, 90.0, 'Aprovado');
GO

/*--------------------------------------------------------------
   12. Dados para a tabela Matricula
--------------------------------------------------------------*/
INSERT INTO Matricula (RA_aluno, cod_turma, data_matricula, data_cancelamento, status_matricula, motivo_cancelamento)
VALUES
    (1, 1, '2023-02-05', NULL, 'Ativa', NULL),
    (2, 2, '2023-02-05', NULL, 'Ativa', NULL),
    (3, 3, '2023-07-20', '2023-09-10', 'Cancelada', 'Mudança de cidade'),
    (4, 4, '2024-01-25', NULL, 'Ativa', NULL),
    (5, 5, '2024-01-25', NULL, 'Ativa', NULL),
    (6, 6, '2023-07-20', NULL, 'Concluída', NULL),
    (1, 7, '2024-02-05', NULL, 'Ativa', NULL);
GO

/*--------------------------------------------------------------
   13. Dados para a tabela Curso_Disciplina
--------------------------------------------------------------*/
INSERT INTO Curso_Disciplina (cod_curso, cod_disciplina, tipo_disciplina)
VALUES
    (1, 1, 'Obrigatória'), (1, 7, 'Obrigatória'), -- Curso 1 (Letras)
    (2, 2, 'Obrigatória'), (2, 6, 'Optativa'), (2, 8, 'Obrigatória'), -- Curso 2 (ADS)
    (3, 3, 'Obrigatória'),                        -- Curso 3 (Sociologia)
    (4, 4, 'Obrigatória'), (4, 9, 'Obrigatória'), -- Curso 4 (Audiovisual)
    (5, 5, 'Obrigatória'),                        -- Curso 5 (Fisioterapia)
    (6, 2, 'Optativa'), (6, 6, 'Obrigatória'), (6, 8, 'Optativa'); -- Curso 6 (Ciência de Dados)
GO

/*--------------------------------------------------------------
   14. Dados para a tabela Professor_Disciplina
--------------------------------------------------------------*/
INSERT INTO Professor_Disciplina (cod_professor, cod_disciplina)
VALUES
    (1, 1), (1, 7), -- Prof 1 (Beatriz)
    (2, 2), (2, 6), (2, 8), -- Prof 2 (Ricardo)
    (3, 3),         -- Prof 3 (Fernanda)
    (4, 4), (4, 9), -- Prof 4 (Alexandre)
    (5, 5);         -- Prof 5 (Juliana)
GO

/*--------------------------------------------------------------
   15. Dados para a tabela Aluno_Disciplina
--------------------------------------------------------------*/
INSERT INTO Aluno_Disciplina (RA_aluno, cod_disciplina)
VALUES
    (1, 1), (1, 7),
    (2, 2), (2, 8),
    (4, 4), (4, 9),
    (5, 5),
    (6, 6);
GO

/*--------------------------------------------------------------
   16. Dados para a tabela Disciplina_PreRequisito
--------------------------------------------------------------*/
INSERT INTO Disciplina_PreRequisito (cod_disciplina, cod_prerequisito)
VALUES
    (8, 2),   -- Banco de Dados NoSQL (Disc 8) tem Desenvolvimento Web Full Stack (Disc 2) como pré-requisito
    (2, 6);   -- Desenvolvimento Web Full Stack (Disc 2) tem Modelagem Estatística (Disc 6) como pré-requisito (Exemplo)
GO


-- Verificação (Opcional, após os ALTER TABLE serem executados no seu script principal)
SELECT * FROM Departamento;
SELECT * FROM Professor;
SELECT * FROM Curso;
SELECT * FROM Disciplina;
SELECT * FROM Aluno;
SELECT * FROM Endereco_Professor;
SELECT * FROM Telefone_Professor;
SELECT * FROM Endereco_Aluno;
SELECT * FROM Telefone_Aluno;
SELECT * FROM Turma;
SELECT * FROM Historico_Escolar;
SELECT * FROM Matricula;
SELECT * FROM Curso_Disciplina;
SELECT * FROM Professor_Disciplina;
SELECT * FROM Aluno_Disciplina;
SELECT * FROM Disciplina_PreRequisito;

GO

-- EX 1 Disciplinas cursadas por um aluno com suas respectivas notas para o aluno 1
SELECT * FROM Aluno;
SELECT * FROM Historico_Escolar;
SELECT * FROM Disciplina;

SELECT 
	A.RA_aluno,
	A.nome_aluno,
	A.sobrenome_aluno,
	D.nome_disciplina,
	H.ano,
	H.semestre,
	H.nota,
	H.frequencia,
	H.situacao_historico
FROM 
	Historico_Escolar H
JOIN
	Aluno A ON H.RA_aluno = A.RA_aluno
JOIN 
	Disciplina D ON H.cod_disciplina = D.cod_disciplina
WHERE
	H.RA_aluno = 1
ORDER BY 
	H.ano, h.semestre;

GO

-- EX 2 Professores que ministram determinada disciplina
SELECT * FROM Professor;
SELECT * FROM Disciplina;
SELECT * FROM Professor_Disciplina;

SELECT 
	P.cod_professor,
	P.nome_professor,
	P.sobrenome_professor,
	D.nome_disciplina
FROM
	Professor_Disciplina PD
JOIN	
	Professor P ON PD.cod_professor = P.cod_professor
JOIN 
	Disciplina D ON PD.cod_disciplina = D.cod_disciplina;

GO

-- EX 3 Alunos matriculados em uma turma específica
SELECT * FROM Aluno;
SELECT * FROM Turma;
SELECT * FROM Matricula;

SELECT
	A.RA_aluno,
	A.nome_aluno,
	A.sobrenome_aluno,
	T.cod_turma,
	M.status_matricula,
	M.data_matricula
FROM
	Aluno A
JOIN
	Matricula M ON A.RA_aluno = M.RA_aluno
JOIN
	Turma T ON M.cod_turma = T.cod_turma;

GO

-- EX 4 Disciplinas obrigatórias de um curso
SELECT * FROM Curso;
SELECT * FROM Disciplina;
SELECT * FROM Curso_Disciplina;

SELECT 
	Curso.nome_curso,
	Disciplina.nome_disciplina,
	Curso_Disciplina.tipo_disciplina
FROM 
	Curso_Disciplina
JOIN
	Curso ON Curso_Disciplina.cod_curso = Curso.cod_curso
JOIN 
	Disciplina ON Curso_Disciplina.cod_curso = Disciplina.cod_disciplina;

GO

-- EX 5 Endereço completo de um aluno
SELECT * FROM Aluno;
SELECT * FROM Endereco_Aluno;

SELECT
	A.RA_aluno,
	A.nome_aluno,
	A.sobrenome_aluno,
	E.rua,
	E.numero_residencial,
	E.bairro,
	E.cidade,
	E.estado,
	E.CEP,
	E.complemento
FROM
	Aluno A
JOIN 
	Endereco_Aluno E ON A.cod_endereco = E.cod_endereco;

GO

-- EX 6 Disciplinas que possuem pré-requisitos
SELECT * FROM Disciplina;
SELECT * FROM Disciplina_PreRequisito;

SELECT 
	D.nome_disciplina AS Disciplina,
	DP.nome_disciplina AS Prerequisito
FROM
	Disciplina_PreRequisito PR
JOIN
	Disciplina D ON PR.cod_disciplina = D.cod_disciplina
JOIN
	Disciplina DP ON PR.cod_prerequisito = DP.cod_disciplina;

GO

-- EX 7 Alunos e seus respectivos cursos
SELECT * FROM Aluno;
SELECT * FROM Curso;

SELECT
	A.RA_aluno,
	A.nome_aluno,
	A.sobrenome_aluno,
	C.nome_curso
FROM
	Aluno A
JOIN
	Curso C ON A.cod_curso = C.cod_curso;

GO

-- EX 8 Professores que atuam em mais de um departamento
SELECT * FROM Professor;
SELECT * FROM Departamento;

SELECT
	P.cod_professor,
	P.nome_professor,
	P.sobrenome_professor,
	P.cod_departamento,
	D.nome_departamento
FROM
	Professor P
JOIN
	Departamento D ON P.cod_departamento = D.cod_departamento;

GO

-- EX 9 Número de alunos por curso
SELECT * FROM Aluno;
SELECT * FROM Curso;

SELECT 
	C.nome_curso,
	COUNT (A.cod_curso) AS Total_Alunos
FROM
	Aluno A
JOIN
	Curso C ON A.cod_curso = C.cod_curso
GROUP BY 
	C.nome_curso
ORDER BY 
	Total_Alunos DESC;

GO

-- EX 10 Turmas com seus professores responsáveis e disciplinas
SELECT * FROM Disciplina;
SELECT * FROM Professor;
SELECT * FROM Turma;

SELECT
	P.cod_professor,
	P.nome_professor,
	P.sobrenome_professor,
	D.nome_disciplina,
	T.cod_turma,
	T.sala
FROM 
	Turma T
JOIN
	Professor P ON T.cod_professor = P.cod_professor
JOIN
	Disciplina D ON T.cod_disciplina = D.cod_disciplina;

GO

-- EX 11 Sala onde um professor está ministrando aulas
SELECT * FROM Turma;
SELECT * FROM Professor;

SELECT
	P.cod_professor,
	P.nome_professor,
	P.sobrenome_professor,
	T.sala
FROM
	Professor P
JOIN 
	Turma T ON T.cod_professor = P.cod_professor;

GO

-- EX 12 A qual departamento um professor pertence
SELECT * FROM Departamento;
SELECT * FROM Professor;

SELECT 
	P.cod_professor,
	P.cod_departamento,
	P.nome_professor,
	P.sobrenome_professor
FROM
	Professor P
JOIN
	Departamento D ON P.cod_departamento = D.cod_departamento;

GO

-- Inserir comandos check e trigger para garantir as regras
-- CHECK Constraints (Restrições)
-- 1 - Gênero apenas permitido
-- Usar a constraint CHECK para fazer a identificação do gênero das tabelas Aluno e Professor. Os campos que devem ser aceitos são: Masculino, Feminino e Outros
SELECT * FROM Aluno;
SELECT * FROM Professor;

ALTER TABLE Aluno
ADD CONSTRAINT chk_genero_aluno CHECK (genero IN ('Masculino', 'Feminino', 'Outros'));

ALTER TABLE Professor
ADD CONSTRAINT chk_genero_professor CHECK (identificacao_genero IN ('Masculino', 'Feminino', 'Outros'));

GO

-- 2 - Status do aluno permitido
-- Usar a constraint CHECK para fazer a identificação do status_aluno da tabela Aluno. Os campos que devem ser aceitos são: ('Ativo', 'Formado', 'Trancado', 'Cancelado')
SELECT * FROM Aluno;

ALTER TABLE Aluno
ADD CONSTRAINT chk_status_aluno CHECK (status_aluno IN ('Ativo', 'Formado', 'Trancado', 'Cancelado'));

GO

-- 3 - Status do professor permitido
-- Usar a constraint CHECK para fazer a identificação do status_professor da tabela Professor. Os campos que devem der aceitos são: ('Ativo', 'Inativo', 'Licença');
SELECT * FROM Professor;

ALTER TABLE Professor
ADD CONSTRAINT chk_status_professor CHECK (status_professor IN ('Ativo', 'Inativo', 'Licença'));

GO

-- 4 - Tipo de vinculo do professor permitido
-- Usar a a constraint CHECK para fazer a identificação do tipo_vinculo da tabela Professor. Os campos que devem ser aceitos são: ('Efetivo', 'Substituto', 'Temporário')
SELECT * FROM Professor;

ALTER TABLE Professor
ADD CONSTRAINT chk_tipo_vinculo_professor CHECK (tipo_vinculo IN ('Efetivo', 'Substituto', 'Temporário'));

UPDATE Professor
SET tipo_vinculo = 'Temporário'
WHERE tipo_vinculo = 'Contratado';

GO

-- 5 - Tipo de disciplina permitido
-- Usar a constraint CHECK para fazer a identificação do tipo_disciplina da tabela Curso_Disciplina. Os campos que devem ser aceitos são: ('Obrigatória', 'Optativa')
SELECT * FROM Curso_Disciplina;

ALTER TABLE Curso_Disciplina
ADD CONSTRAINT chk_tipo_disciplina_curso_disciplina CHECK (tipo_disciplina IN ('Obrigatória', 'Optativa'));

GO

-- 6 - Status da matrícula permitido
-- Usar a constraint CHECK para fazer a identificação do status_matricula da tabela Matricula. Os campos que devem ser aceitos são: ('Ativa', 'Cancelada', 'Trancada', 'Concluída')
SELECT * FROM Matricula;

ALTER TABLE Matricula
ADD CONSTRAINT chk_status_matricula CHECK (status_matricula IN ('Ativa', 'Cancelada', 'Trancada', 'Concluída'));

GO

-- 7 - Turno permitido para curso
-- Usar a constraint CHECK para fazer a identificação do turno_curso da tabela Curso. Os campos que devem ser aceitos são: ('Matutino', 'Vespertino', 'Noturno', 'Integral');
SELECT * FROM Curso;

ALTER TABLE Curso
ADD CONSTRAINT chk_turno_curso CHECK (turno IN ('Matutino', 'Vespertino', 'Noturno', 'Integral'));

GO

-- 8 - Modalidade permitida para cada curso
ALTER TABLE Curso
ADD CONSTRAINT chk_modalidade_curso CHECK (modalidade IN ('Presencial', 'EAD', 'Híbrido'));

GO

-- Triggers DML
-- Uma trigger é um gatilho que será disparado automaticamente quando acontecer um evento.
-- Triggers podem der disparados por eventos DDL (CREATE, ALTER, DROP) e DML (INSERT, UPDATE, DELETE).

-- A) Tempo de execução:
-- BEFORE (antes)
-- AFTER (depois)

-- B) Evento:
-- INSERT
-- UPDATE
-- DELETE

CREATE OR ALTER TRIGGER tgClienteAlterado
ON dCliente
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

	PRINT 'Os dados da tabela cliente foram alterados!'
END

GO

SELECT * FROM dCliente;

INSERT INTO dCliente (nome_cliente, genero, data_de_nascimento, cpf)
VALUES
('Pedro Junior', 'M', '14/03/1999', '222.555.123-12');

GO

UPDATE dCliente
SET cpf = '111.222.333-44'
WHERE id_cliente = 6;

GO

DELETE FROM dCliente
WHERE id_cliente = 11;

GO

-- Desabilitando uma TRIGGER DML (Linguagem de Manipulação de Dados)

DISABLE TRIGGER tgClienteAlterado ON dCliente;

GO

-- Desabilitando todas as TRIGGERs DML de uma tabela (Linguagem de Manipulação de Dados)
DISABLE TRIGGER ALL ON dCliente;

GO

-- Habilitando uma TRIGGER DML
ENABLE TRIGGER tgClienteAlterado ON dCliente;

GO

-- habilitando todas as TRIGGERs DML de uma tabela
ENABLE TRIGGER ALL ON dCliente;

GO

-- Excluindo uma TRIGGER DML
DROP TRIGGER tgClienteAlterado;

GO

-- Identificando na TRIGGER o evento DML relacionado
CREATE OR ALTER TRIGGER tgClienteAlterado
ON dCliente
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
PRINT 'Dados foram atualizados na tabela'
ELSE IF EXISTS (SELECT * FROM inserted)
PRINT 'Dados foram inseridos na tabela'
ELSE IF EXISTS (SELECT * FROM deleted)
PRINT 'Dados foram excluídos na tabela'
END

GO

INSERT INTO dCliente (nome_cliente, genero, data_de_nascimento, cpf)
VALUES
('Bianca Bacarini', 'F', '10/05/2005', '553.598.289-05');

GO

DELETE FROM dCliente
WHERE id_cliente = 12;

GO

UPDATE dCliente
SET cpf = '678.333.111-11'
WHERE id_cliente = 1;

GO

-- Crie uma TRIGGER que seja disparada sempre que tentarem inserir um dado na tabela, essa TRIGGER deverá informar que não é possível inserir dados na quinta ou sábado 

SELECT * FROM dbo.dCliente;

CREATE OR ALTER TRIGGER tgRecusarTabelasFimDeSemana
ON dCliente
AFTER
INSERT
AS
BEGIN
	-- VERIFICA SE O DIA ATUAL É SÁBADO OU QUINTA
	IF FORMAT(GETDATE(), 'dddd') IN ('sábado', 'quinta-feira')
	BEGIN

	-- SE FOR SÁBADO OU DOMINGO, DISPARA UM ERRO INFORMANDO A RESTRIÇÃO
	RAISERROR('Não é possível inserir dados no sábado e quinta-feira', 16, 1)
	-- 16, 1 ESSES VALORES INDICAM A GRAVIDADE DO ERRO

ROLLBACK TRANSACTION;
	END
END;
GO

INSERT INTO dCliente (nome_cliente, genero, data_de_nascimento, cpf)
VALUES
('Fernanda Lima', 'F', '28/10/1988', '145.333.888-01');

GO