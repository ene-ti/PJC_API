FROM mcr.microsoft.com/windows/servercore:ltsc2019
ADD app/PJC_API_ArtAlbum.exe /app/PJC_API_ArtAlbum.exe
ADD app/PJC_API_ArtAlbum.ini /app/PJC_API_ArtAlbum.ini
ADD app/www/*.* /app/www
ADD app/libmysql.dll /app/libmysql.dll
WORKDIR /app
CMD [PJC_API_ArtAlbum.exe]
