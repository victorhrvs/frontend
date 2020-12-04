CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAcessoNotebook`()
BEGIN
    DECLARE total_de_alunos_com_cadastro INT;
    DECLARE notebook INT;
    
	SELECT
			count(*) into total_de_alunos_com_cadastro
	FROM
			socioeconomico
	order by
			renda_per_capita;
	
	SELECT
			count(*) into notebook
	FROM
			notebook;

	IF (total_de_alunos_com_cadastro < notebook) then
		SELECT "Todos os alunos podem pegar os notebooks";
    ELSE
		Select * from socioeconomico ORDER BY `socioeconomico`.`renda_per_capita` LIMIT notebook;
    END IF;

END