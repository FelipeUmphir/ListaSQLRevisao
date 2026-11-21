CREATE DATABASE ex9
GO
USE ex9
GO
CREATE TABLE editora (
codigo INT NOT NULL,
nome VARCHAR(30) NOT NULL,
site VARCHAR(40) NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo INT NOT NULL,
nome VARCHAR(30) NOT NULL,
biografia VARCHAR(100) NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo INT NOT NULL,
nome VARCHAR(100) NOT NULL UNIQUE,
quantidade INT NOT NULL,
valor DECIMAL(7,2) NOT NULL CHECK(valor > 0.00),
codEditora INT NOT NULL,
codAutor INT NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo INT NOT NULL,
codEstoque INT NOT NULL,
qtdComprada INT NOT NULL,
valor DECIMAL(7,2) NOT NULL,
dataCompra DATE NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civilização Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Marilia Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matematica da UFRS e da
PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Linguistica Aplicada e
Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ciencias da Computacão pelo
MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos',4,108.00,1,101),
(10002,'A Arte da Política',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de Fisica I',26,68.00,4,104),
(10005,'Geometria Analitica',1,95.00,3,105),
(10006,'Gramática Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de Fisica III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00, CAST('2026-07-04' AS DATE)),
(15051,10008,1,95.00, CAST('2026-07-04' AS DATE)),
(15051,10004,1,68.00, CAST('2026-07-04' AS DATE)),
(15051,10007,1,78.00, CAST('2026-07-04' AS DATE)),
(15052,10006,1,49.00, CAST('2026-07-05' AS DATE)),
(15052,10002,3,165.00, CAST('2026-07-05' AS DATE)),
(15053,10001,1,108.00, CAST('2026-07-05' AS DATE)),
(15054,10003,1,79.00, CAST('2026-08-06' AS DATE)),
(15054,10008,1,95.00, CAST('2026-08-06' AS DATE))

SELECT * FROM autor
SELECT * FROM compra
SELECT * FROM editora
SELECT * FROM estoque

--EXERCICIO 01 Consultar nome, valor unitário, nome da editora e nome do autor dos livros do
--estoque que foram vendidos. Não pode haver repetições.

SELECT DISTINCT estoque.nome, estoque.valor, editora.nome, autor.nome
FROM estoque, editora, autor, compra
WHERE autor.codigo = estoque.codAutor
	AND editora.codigo = estoque.codEditora
	AND estoque.codigo = compra.codEstoque

--EXERCICIO 02 Consultar nome do livro, quantidade comprada e valor de compra da compra 15051

SELECT estoque.nome, compra.qtdComprada, compra.valor
FROM estoque, compra
WHERE estoque.codigo = compra.codEstoque
	AND compra.codigo = 15051

--EXERCICIO 03 Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site
--tenha mais de 10 dígitos, remover o www.)

SELECT estoque.nome, 
	CASE WHEN (LEN(editora.site) > 10)
		THEN SUBSTRING(editora.site, 5, 40)
		ELSE editora.site
	END AS editora_site
FROM estoque, editora
WHERE editora.codigo = estoque.codEditora
	AND editora.nome = 'Makron Books'

--EXERCICIO 04 Consultar nome do livro e Breve Biografia do David Halliday

SELECT estoque.nome, autor.biografia
FROM estoque, autor
WHERE autor.codigo = estoque.codAutor
	AND autor.nome = 'David Halliday'

--EXERCICIO 05 Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos

SELECT compra.codigo, compra.qtdComprada
FROM compra, estoque
WHERE estoque.codigo = compra.codEstoque
	AND estoque.nome = 'Sistemas Operacionais Modernos'

--EXERCICIO 06 Consultar quais livros não foram vendidos

SELECT estoque.nome
FROM estoque LEFT OUTER JOIN compra
ON estoque.codigo = compra.codEstoque
WHERE compra.codEstoque IS NULL

--EXERCICIO 07 Consultar quais livros foram vendidos e não estão cadastrados. Caso o nome dos
--livros termine com espaço, fazer o trim apropriado

SELECT RTRIM(estoque.nome)
FROM compra LEFT OUTER JOIN estoque
ON estoque.codigo = compra.codEstoque
WHERE estoque.codigo IS NULL


--EXERCICIO 08 Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha
--mais de 10 dígitos, remover o www.)

SELECT editora.nome, editora.site,
	CASE WHEN (LEN(editora.site) > 10)
		THEN SUBSTRING(editora.site, 5, 40)
		ELSE editora.site
	END AS editora_site
FROM editora LEFT OUTER JOIN estoque
ON editora.codigo = estoque.codEditora
WHERE estoque.codEditora IS NULL 

--EXERCICIO 09 Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a
--biografia inicie com Doutorado, substituir por Ph.D.)

SELECT autor.nome, 
	CASE WHEN (autor.biografia LIKE 'Doutorado%')
		THEN 'Ph.D.' + SUBSTRING(autor.biografia, 10, 100)
		ELSE autor.biografia
	END AS autor_biografia
FROM autor LEFT OUTER JOIN estoque
ON autor.codigo = estoque.codAutor
WHERE estoque.codAutor IS NULL

--EXERCICIO 10 Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente

SELECT autor.nome, estoque.valor
FROM autor, estoque
WHERE autor.codigo = estoque.codAutor
	AND estoque.valor = (SELECT MAX(valor) FROM estoque)
ORDER BY estoque.valor DESC 

--EXERCICIO 11 Consultar o código da compra, o total de livros comprados e a soma dos valores
--gastos. Ordenar por Código da Compra ascendente

SELECT codigo, SUM(qtdComprada) AS qnt_comprada, SUM(valor) AS valor_gasto
FROM compra
GROUP BY codigo
ORDER BY codigo ASC

--EXERCICIO 12 Consultar o nome da editora e a média de preços dos livros em estoque. Ordenar
--pela Média de Valores ascendente

SELECT editora.nome, AVG(estoque.valor) AS media_preço 
FROM editora, estoque
WHERE editora.codigo = estoque.codEditora
GROUP BY editora.nome
ORDER BY media_preço ASC

--EXERCIO 13 Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da
--editora (Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna
--status onde:
--Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
--Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
--Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
--A Ordenação deve ser por Quantidade ascendente

SELECT estoque.nome, estoque.quantidade, editora.nome, 
	   CASE WHEN (LEN(editora.site) > 10)
			THEN SUBSTRING(editora.site, 5, 40)
			ELSE editora.site
	   END AS site_editora,
	   CASE WHEN (estoque.quantidade < 5)
			THEN 'Produto em Ponto de Pedido'
			WHEN (estoque.quantidade < 10)
			THEN 'Produto Acabando'
			ELSE 'Estoque Suficiente'
	   END AS status_produto
FROM estoque, editora
WHERE editora.codigo = estoque.codEditora
ORDER BY estoque.quantidade ASC

--EXERCICIO 14 Para montar um relatório, é necessário montar uma consulta com a seguinte saída:
--Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site)
--de todos os livros
--Só pode concatenar sites que não são nulos

SELECT estoque.codigo AS Codigo_do_Livro,
		estoque.nome AS Nome_do_Livro,
		autor.nome AS Nome_do_Autor,
		CASE WHEN (editora.site IS NOT NULL)
			THEN editora.nome + ': ' + editora.site
			ELSE editora.nome
		END AS Info_Editora
FROM estoque, autor, editora
WHERE autor.codigo = estoque.codAutor
	AND editora.codigo = estoque.codEditora

--EXERCICIO 15 Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da
--compra até hoje

SELECT codigo AS codigo_compra, 
	DATEDIFF(DAY, dataCompra, GETDATE()) AS quantos_dias_compra,
	DATEDIFF(MONTH, dataCompra, GETDATE()) AS quantos_meses_compra
FROM compra

--EXERCICIO 16 Consultar o código da compra e a soma dos valores gastos das compras que somam
--mais de 200.00

SELECT codigo, 
	SUM(valor) AS soma_valores_gastos
FROM compra
GROUP BY codigo
HAVING SUM(valor) > 200.00