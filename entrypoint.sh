#!/bin/bash
# MSSQL server start
/opt/mssql/bin/sqlservr &

# SQL Server hazır olana kadar bekle
echo "Waiting for SQL Server to start..."
sleep 30s

# API start
dotnet TodoApp.dll