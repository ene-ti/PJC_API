REM .
REM Script para criar um container do MySql
REM .
REM Cria a imagem
REM .
  pause
  docker build -t image_mysql -f db/Dockerfile .
REM .
REM Cria o container e executa 
  pause
  docker run -d -it -p 3306:3306 --name container_mysql image_mysql  
REM .
REM ----- ATENCAO !!! AGUARDE PELO MENOS 1 MINUTO PARA O PROXIMO PASSO ---  
REM ----- ISSO GARANTE A CRICAO DE ESTRUTURA DE PASTAS DO MYSQL ----------  
REM .
REM Cria o banco DB_PJC dentro do container  
REM .
  pause
  docker exec -i container_mysql mysql -uroot -pdbpjc < db/scriptdbpjc.sql
REM Executa terminal dentro da imagem
REM Testar se criou ok
REM    # mysql -uroot -pdbpjc
REM    mysql> use db_pjc;
REM    mysql> select * from artista; 
REM .
  pause
  docker exec -it container_mysql /bin/bash
REM .
REM para saber o IP do container
REM .
  pause
  docker inspect container_mysql
REM .
REM container MySql criado
REM .
  