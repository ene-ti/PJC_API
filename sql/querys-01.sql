
SELECT * FROM DB_PJC.ARTISTA;
SELECT * FROM DB_PJC.ALBUM;

SELECT * FROM DB_PJC.ARTISTA ART 
   LEFT OUTER JOIN DB_PJC.ALBUM ALB ON ART.ART_ID = ALB.ID_ART;
WHERE ART.ART_NOME LIKE "%MIKE%";   

SELECT * FROM DB_PJC.ALBUM ALB 
   INNER JOIN DB_PJC.ARTISTA ART ON ALB.ART_ID = ART.ART_ID;

SELECT * FROM DB_PJC.ARTISTA ART 
   INNER JOIN DB_PJC.ALBUM ALB ON ART.ART_ID = ALB.ID_ART
   INNER JOIN DB_PJC.CAPA CAP ON CAP.ID_ALB = ALB.ALB_ID;
      
      