# Use uma imagem base do Node.js para construir o aplicativo React
FROM node:14 AS build

# Crie um diretório de trabalho no contêiner
WORKDIR /app

# Copie o arquivo package.json e o arquivo package-lock.json (se existir)
COPY chagas-app/package*.json ./

# Instale as dependências do projeto
RUN npm install

# Copie os arquivos do aplicativo React para o contêiner
COPY chagas-app/ .

# Construa o aplicativo React
RUN npm run build

# Use uma imagem base do Apache
FROM httpd:2.4

# Copie o aplicativo React compilado do estágio de construção para o diretório padrão do Apache
COPY --from=build /app/build/ /usr/local/apache2/htdocs/

# Exponha a porta 80 (a porta padrão do Apache)
EXPOSE 80

# Inicialize o servidor Apache quando o contêiner for iniciado
CMD ["httpd", "-D", "FOREGROUND"]

