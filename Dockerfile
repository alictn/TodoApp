# Base image olarak SQL Server kullan
FROM mcr.microsoft.com/mssql/server:2022-latest AS mssqlbase
ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=MyStrongPass123!
ENV MSSQL_PID=Express
WORKDIR /app

# .NET runtime ekleyelim
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# SDK image ile build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["TodoApp.csproj", "./"]
RUN dotnet restore "./TodoApp.csproj"
COPY . .
RUN dotnet publish "./TodoApp.csproj" -c Release -o /app/publish

# Tek servis image oluştur
FROM mssqlbase AS final
WORKDIR /app
COPY --from=build /app/publish ./

# Start script koyalım
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]