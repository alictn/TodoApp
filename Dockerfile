FROM mcr.microsoft.com/mssql/server:2022-latest AS mssqlbase
ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=MyStrongPass123!
ENV MSSQL_PID=Express
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["TodoApp.csproj", "./"]
RUN dotnet restore "./TodoApp.csproj"
COPY . .
RUN dotnet publish "./TodoApp.csproj" -c Release -o /app/publish

FROM mssqlbase AS final
WORKDIR /app
COPY --from=build /app/publish ./

EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:8080


ENTRYPOINT bash -c "/opt/mssql/bin/sqlservr & \
  echo 'Waiting for SQL Server to start...' && \
  sleep 30 && \
  dotnet TodoApp.dll"