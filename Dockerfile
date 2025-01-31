FROM mcr.microsoft.com/dotnet/sdk:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY BaseApi.sln ./
COPY src/*.csproj ./src/
COPY tests/UnitTests/*.csproj ./tests/UnitTests

RUN dotnet restore
COPY . .

WORKDIR /src/src
RUN dotnet build -c Release -o /app

WORKDIR /src/tests/UnitTests
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app . 

CMD ASPNETCORE_URLS=http://*:$PORT dotnet BaseApi.dll