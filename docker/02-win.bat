REM Script para criar um container do Windows
REM Cria a imagem
  docker build -t win-image -f app/Dockerfile .
  pause
REM Lista as imagens  
  docker image ls
  pause
REM Cria o container e executa  
  docker run -d -p8080:8080 --rm --name win-container win-image
  pause
REM Lista os containers
  docker ps
REM ----- ATENCAO !!! AGUARDE PELO MENOS 1 MINUTO PARA O PROXIMO PASSO ---  
REM ----- ISSO GARANTE A CRICAO DE ESTRUTURA DE PASTAS DO MYSQL ----------  
  pause
REM Cria o banco dentro do container  
 rem docker exec -i mysql-container mysql -uroot -pdbpjc < db/scriptdbpjc.sql
REM Executa terminal dentro da imagem
REM Teste se criou ok
REM    # mysql -uroot -pdbpjc
REM    mysql> use db_pjc;
REM    mysql> select * from artista; 
 rem docker exec -it mysql-container /bin/bash
  pause
REM para saber o IP do conteiner
  docker inspect mysql-container
REM container MySql criado
