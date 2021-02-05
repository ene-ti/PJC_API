REM .
REM Script para criar um container do WindowsApp
REM .
REM Cria a imagem
REM .
  pause
  docker build -t image_winapp -f app/Dockerfile .
REM .
REM Cria o container e executa 
  pause
  docker run -d -it -p 8080:8080 --link container_mysql --name container_winapp image_winapp  
REM .
REM Executa terminal dentro da imagem
REM Testar se criou ok
REM .
  pause
  docker exec -it container_winapp cmd
REM .

REM para saber o IP do container
REM .
  pause
  docker inspect container_winapp
REM .
REM container WindowsApp criado
REM .

