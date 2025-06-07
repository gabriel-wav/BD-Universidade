# Sistema de Gerenciamento Acadêmico - Universidade Saint Gabriel

Este projeto documenta o processo de modelagem e implementação de um banco de dados para um sistema de gerenciamento acadêmico, desde a definição das regras de negócio até a criação do esquema físico no SQL Server.

---

## 🚀 Visão Geral

O objetivo foi construir um banco de dados relacional normalizado para gerenciar as principais entidades de uma instituição de ensino fictícia, a "Universidade Saint Gabriel". O sistema lida com informações sobre alunos, professores, cursos, disciplinas, matrículas e departamentos, garantindo a integridade e a consistência dos dados.

O processo partiu de um script inicial não normalizado, aplicando as Formas Normais (1FN, 2FN e 3FN) para eliminar redundâncias e anomalias de dados, resultando em um modelo lógico e físico robusto e eficiente.

---

## 🏛️ Entidades Principais

O banco de dados foi estruturado em torno das seguintes entidades centrais para o negócio acadêmico:

* **Aluno:** Armazena os dados cadastrais dos estudantes, como informações pessoais, endereço e contato. É a entidade central do sistema.
* **Professor:** Contém as informações dos docentes, incluindo dados pessoais, titulação, tipo de vínculo e o departamento ao qual pertencem.
* **Departamento:** Agrupa cursos e professores por área de conhecimento. É a unidade responsável pela gestão acadêmica de sua área.
* **Curso:** Define os cursos oferecidos pela universidade, especificando nome, duração, tipo (graduação, pós-graduação) e o departamento responsável.
* **Disciplina:** Representa as unidades curriculares que compõem a grade dos cursos. Contém informações como ementa e carga horária.
* **Matrícula:** Formaliza o vínculo de um aluno com um curso específico, registrando o status dessa relação (ex: Ativa, Trancada, Concluída).
* **Turma:** É a oferta de uma disciplina em um período letivo específico, associando um professor, uma disciplina e os alunos inscritos.
* **Histórico Acadêmico:** Registra o desempenho de um aluno em uma disciplina cursada, armazenando nota, frequência e a situação final (aprovado ou reprovado).

---

## 🛠️ Ferramentas Utilizadas

* **SGBD:** Microsoft SQL Server
* **Modelagem Conceitual:** brModelo
* **Documentação, Dicionário de Dados e Modelagem Lógica:** Microsoft Excel
* **Edição de Scripts e Anotações:** Bloco de Notas (Notepad)

---

## 📁 Estrutura do Projeto

O repositório está organizado com os artefatos gerados em cada etapa do processo de desenvolvimento do banco de dados:

* `REGRAS_DO_NEGOCIO.txt`: Documento inicial contendo as definições e restrições que guiaram a modelagem do sistema.
* `NORMAS DE BANCO DE DADOS.txt`: Anotações teóricas sobre as Formas Normais (1FN, 2FN, 3FN) utilizadas como base para a normalização.
* `BANCO DE DADOS SEM NORMA.txt`: O primeiro script SQL, representando uma estrutura denormalizada com diversas anomalias.
* `CONCEITUAL_UNIVERSIDADE_SAINT_GABRIEL.xml`: Arquivo do brModelo contendo o Modelo Entidade-Relacionamento (MER) conceitual.
* `DICIONARIO E DER UNIVERSIDADE.xlsx`: Planilha com o dicionário de dados detalhado, descrevendo tabelas, colunas, tipos de dados e restrições contendo também o modelo lógico.
* `FISICO_UniversidadeSaintGabriel.sql`: Script SQL final, contendo o código para criação do banco de dados, tabelas normalizadas, relacionamentos (chaves primárias e estrangeiras) e constraints de verificação.

---

## ⚙️ Como Utilizar

Para recriar o banco de dados em seu ambiente local, siga os passos abaixo:

1.  **Pré-requisitos:** Certifique-se de ter o [SQL Server](https://www.microsoft.com/pt-br/sql-server/sql-server-downloads) e uma ferramenta de gerenciamento como o SQL Server Management Studio (SSMS) ou Azure Data Studio instalados.

2.  **Execução do Script:**
    * Abra o arquivo `FISICO_UniversidadeSaintGabriel.sql` no seu editor SQL de preferência.
    * O script já contém os comandos `CREATE DATABASE` e `USE`, então você pode executá-lo diretamente.
    * A execução criará o banco de dados `UniversidadeSaintGabriel` e todas as suas tabelas, relacionamentos e constraints.

3.  **Verificação:** Após a execução, você pode expandir a árvore de objetos do seu servidor para visualizar a estrutura completa do banco de dados e suas tabelas.
