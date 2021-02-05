Processo Seletivo PJC/MT 2020
##-------------------------------##
## Inscrição:
  NOME: NELSIMAR SELANO GONCALVES
  EMAIL: nelsimar.sg@gmail.com
  CPF: 12894325894
  RG: 32702710 SSP/MT
  FONE: 65999562983
  ATRIBUIÇÃO: Analista Desenvolvedor
##-------------------------------##

##-------------------------------##
## Instalação:
Clonar o projeto em uma pasta local;
Abrir o CMD (modo admin);
Acessar a sub-pasta do projeto ".\docker";
Executar o comando: 01-mysql.bat para criar o container do MySql 
Executar o comando: 02-win.bat para criar o container do Windows/app

##-------------------------------##
## Acesso:
Carregar os scripts do POSTMAN para testes da API (pasta: postman)
Para acesso a documentação e teste via navegador: http://localhost:8080/docs/   (ip do container image_winapp)
Para acesso a API: http://localhost:8080/login (ip do container image_winapp)

##-------------------------------##
## Requisitos:
a)	A solução deverá conter a segurança necessária de forma a não permitir acesso ao endpoint a partir de domínios diversos do qual estará hospedado o serviço; 
	** Não implementado (faltou entendimento/conhecimento o suficiente para demandar este requisito);
b)	A solução deverá conter controle de acesso por meio de autenticação JWT com expiração a cada 5 minutos e possibilidade de renovação; 
	*** Implementado;
c)	A solução deverá implementar pelo menos os verbos post, put, get; 
	*** Implementado;
d)	A solução deverá conter recursos de paginação na consulta dos álbuns; 
	*** Implementado;
e)	A solução deverá expor quais álbuns são/tem os cantores e/ou bandas possibilitando consultas parametrizadas; 
	*** Implementado;
f)	Deverá ser possível realizar consultas por nome do artista, permitindo ordenar por ordem alfabética (asc e desc); 
	*** Implementado;
g)	Deverá ser possível fazer o upload de uma ou mais imagens da capa do álbum;  
	** Não implementado (não consegui estabelecer acesso aos objetos dentro do "bucket" do MinIO. A solução alternativa seria disponibilizar as imagens
	** diretamente no AWS, mas perdi muito tempo com o MinIO, e não consegui tempo suficiente para a mudança);
h)	As imagens deverão ser armazenadas no Object Store MinIO utilizando API S3; 
	** Não implementado (não consegui estabelecer acesso aos objetos dentro do "bucket" do MinIO. A solução alternativa seria disponibilizar as imagens
	** diretamente no AWS, mas perdi muito tempo com o MinIO, e não consegui tempo suficiente para a mudança);
i)	Preferencialmente, a recuperação das imagens deverá ser através links apontando para o Min.IO Play com tempo de expiração. 
	** Não implementado (não consegui estabelecer acesso aos objetos dentro do "bucket" do MinIO. A solução alternativa seria disponibilizar as imagens
	** diretamente no AWS, mas perdi muito tempo com o MinIO, e não consegui tempo suficiente para a mudança);
j)	Por fim, a solução deverá ser “dockerizada” de forma que a solução execute em docker
	*** Implementado;
##-------------------------------##
