# api-

comando para buildar a imagem local
docker build -t api-escolar:latest .

comando para iniciar o container
docker run -d --name api-escolar -p 8000:8000 api-escolar:latest