CREATE SCHEMA IF NOT EXISTS `notebooks_para_todos` DEFAULT CHARACTER SET utf8 ;
USE `notebooks_para_todos`;

CREATE TABLE `notebooks_para_todos`.`socioeconomico` (
  `id_socioeconomico` INT NOT NULL,
  `numero_de_membros_da_familia` INT NULL,
  `renda_per_capita` FLOAT NULL,
  `programa_bolsa_familia` TINYINT UNSIGNED NULL DEFAULT 0,
  `programa_de_erradicacao_do_trabalho_infantil` TINYINT NULL DEFAULT 0,
  `programa_projovem_adolescente` TINYINT NULL DEFAULT 0,
  PRIMARY KEY (`id_socioeconomico`));

  
CREATE TABLE `notebooks_para_todos`.`local` (
  `idlocal` INT NOT NULL AUTO_INCREMENT,
  `cep` VARCHAR(45) NULL,
  `cidade` VARCHAR(45) NULL,
  `bairro` VARCHAR(45) NULL,
  `endereco` VARCHAR(45) NULL,
  `numero` VARCHAR(45) NULL,
  PRIMARY KEY (`idlocal`));

CREATE TABLE `notebooks_para_todos`.`aluno` (
  `matricula` INT NOT NULL AUTO_INCREMENT,
  `cpf` VARCHAR(15) NULL,
  `rg` VARCHAR(15) NULL,
  `sexo` CHAR(1) NULL,
  `data_de_nascimento` DATE NULL,
  `nome` VARCHAR(80) NULL,
  `email` VARCHAR(64) NULL,
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `socioeconomico_id_socioeconomico` INT NULL,
  `permissao_para_pegar_notebook` TINYINT NOT NULL DEFAULT 0,
  `local_idlocal` INT NOT NULL,
  PRIMARY KEY (`matricula`),
  INDEX `fk_aluno_socioeconomico_idx` (`socioeconomico_id_socioeconomico` ASC) VISIBLE,
  INDEX `fk_aluno_local_idx` (`local_idlocal` ASC) VISIBLE,
  CONSTRAINT `fk_aluno_socioeconomico`
    FOREIGN KEY (`socioeconomico_id_socioeconomico`)
    REFERENCES `notebooks_para_todos`.`socioeconomico` (`id_socioeconomico`),
  CONSTRAINT `fk_aluno_local`
    FOREIGN KEY (`local_idlocal`)
    REFERENCES `notebooks_para_todos`.`local` (`idlocal`));

CREATE TABLE `notebooks_para_todos`.`responsavel` (
  `idresponsavel` INT NOT NULL,
  `r_nome` VARCHAR(75) NULL,
  `r_email` VARCHAR(64) NULL,
  PRIMARY KEY (`idresponsavel`));

CREATE TABLE `notebooks_para_todos`.`responsavel_has_aluno` (
  `responsavel_idresponsavel` INT NOT NULL,
  `aluno_matricula` INT NOT NULL,
  PRIMARY KEY (`responsavel_idresponsavel`, `aluno_matricula`),
  INDEX `fk_responsavel_has_aluno_aluno1_idx` (`aluno_matricula` ASC) VISIBLE,
  INDEX `fk_responsavel_has_aluno_responsavel1_idx` (`responsavel_idresponsavel` ASC) VISIBLE,
  CONSTRAINT `fk_responsavel_has_aluno_responsavel1`
    FOREIGN KEY (`responsavel_idresponsavel`)
    REFERENCES `notebooks_para_todos`.`responsavel` (`idresponsavel`),
  CONSTRAINT `fk_responsavel_has_aluno_aluno1`
    FOREIGN KEY (`aluno_matricula`)
    REFERENCES `notebooks_para_todos`.`aluno` (`matricula`));

CREATE TABLE `notebooks_para_todos`.`doador` (
  `iddoador` INT NOT NULL AUTO_INCREMENT,
  `d_nome` VARCHAR(75) NULL,
  `email` VARCHAR(64) NULL,
  `d_cpf` VARCHAR(45) NULL,
  PRIMARY KEY (`iddoador`));

CREATE TABLE `notebooks_para_todos`.`notebook` (
  `idnotebook` INT NOT NULL AUTO_INCREMENT,
  `marca` VARCHAR(45) NULL,
  `modelo` VARCHAR(45) NULL,
  `apresenta_defeito` TINYINT NULL,
  `manutencao` TINYINT NULL,
  `aluno_matricula` INT NULL,
  `doador_iddoador` INT NOT NULL,
  `escola_idescola` INT NOT NULL,
  PRIMARY KEY (`idnotebook`),
  INDEX `fk_notebook_aluno1_idx` (`aluno_matricula` ASC) VISIBLE,
  INDEX `fk_notebook_doador1_idx` (`doador_iddoador` ASC) VISIBLE,
  INDEX `fk_notebook_escola1_idx` (`escola_idescola` ASC) VISIBLE,
  CONSTRAINT `fk_notebook_aluno`
    FOREIGN KEY (`aluno_matricula`)
    REFERENCES `notebooks_para_todos`.`aluno` (`matricula`),
  CONSTRAINT `fk_notebook_doador`
    FOREIGN KEY (`doador_iddoador`)
    REFERENCES `notebooks_para_todos`.`doador` (`iddoador`),
  CONSTRAINT `fk_notebook_escola`
    FOREIGN KEY (`escola_idescola`)
    REFERENCES `notebooks_para_todos`.`escola` (`idescola`));

CREATE TABLE `notebooks_para_todos`.`professor` (
  `id_professor` INT NOT NULL AUTO_INCREMENT,
  `nome_professor` VARCHAR(45) NULL,
  PRIMARY KEY (`id_professor`));

CREATE TABLE `notebooks_para_todos`.`disciplina` (
  `id_disciplina` INT NOT NULL AUTO_INCREMENT,
  `horario` VARCHAR(45) NOT NULL,
  `nome_disciplina` VARCHAR(45) NULL,
  `professor_id_professor` INT NOT NULL,
  PRIMARY KEY (`id_disciplina`, `horario`, `professor_id_professor`),
  INDEX `fk_disciplina_professor_idx` (`professor_id_professor` ASC) VISIBLE,
  CONSTRAINT `fk_disciplina_professor`
    FOREIGN KEY (`professor_id_professor`)
    REFERENCES `notebooks_para_todos`.`professor` (`id_professor`)
);

CREATE TABLE IF NOT EXISTS `notebooks_para_todos`.`nota` (
  `id_nota` INT NOT NULL AUTO_INCREMENT,
  `total_de_pontos` INT NULL,
  `pontos` INT NULL,
  `disciplina_id_disciplina` INT NOT NULL,
  `disciplina_horario` VARCHAR(45) NOT NULL,
  `disciplina_professor_id_professor` INT NOT NULL,
  `aluno_matricula` INT NOT NULL,
  PRIMARY KEY (`id_nota`, `disciplina_id_disciplina`, `disciplina_horario`, `disciplina_professor_id_professor`, `aluno_matricula`),
  INDEX `fk_nota_disciplina_idx` (`disciplina_id_disciplina` ASC, `disciplina_horario` ASC, `disciplina_professor_id_professor` ASC) VISIBLE,
  INDEX `fk_nota_aluno_idx` (`aluno_matricula` ASC) VISIBLE,
  CONSTRAINT `fk_nota_disciplina`
    FOREIGN KEY (`disciplina_id_disciplina` , `disciplina_horario` , `disciplina_professor_id_professor`)
    REFERENCES `notebooks_para_todos`.`disciplina` (`id_disciplina` , `horario` , `professor_id_professor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_nota_aluno`
    FOREIGN KEY (`aluno_matricula`)
    REFERENCES `notebooks_para_todos`.`aluno` (`matricula`));