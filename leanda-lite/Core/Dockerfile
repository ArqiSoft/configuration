# Use SDK image to build solution
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env

ARG RID=linux-x64

# mongo db url for tests
ARG CI_MONGO_DB=ci_url

ENV OSDR_MONGO_DB=$CI_MONGO_DB

WORKDIR /build

RUN git clone --depth 1 https://github.com/ArqiSoft/leanda-core ./  


RUN dotnet restore --configfile Nuget.config Sds.Osdr.Domain.BackEnd/Sds.Osdr.Domain.BackEnd.csproj
RUN dotnet restore --configfile Nuget.config Sds.Osdr.Domain.FrontEnd/Sds.Osdr.Domain.FrontEnd.csproj
RUN dotnet restore --configfile Nuget.config Sds.Osdr.Persistence/Sds.Osdr.Persistence.csproj
RUN dotnet restore --configfile Nuget.config Sds.Osdr.Domain.SagaHost/Sds.Osdr.Domain.SagaHost.csproj
RUN dotnet restore --configfile Nuget.config Sds.Osdr.WebApi/Sds.Osdr.WebApi.csproj


RUN dotnet publish Sds.Osdr.Domain.BackEnd/Sds.Osdr.Domain.BackEnd.csproj -r $RID -c Release -o /dist/Sds.Osdr.Domain.BackEnd
RUN dotnet publish Sds.Osdr.Domain.FrontEnd/Sds.Osdr.Domain.FrontEnd.csproj -r $RID -c Release -o /dist/Sds.Osdr.Domain.FrontEnd
RUN dotnet publish Sds.Osdr.Persistence/Sds.Osdr.Persistence.csproj -r $RID -c Release -o /dist/Sds.Osdr.Persistence
RUN dotnet publish Sds.Osdr.Domain.SagaHost/Sds.Osdr.Domain.SagaHost.csproj -r $RID -c Release -o /dist/Sds.Osdr.Domain.SagaHost
RUN dotnet publish Sds.Osdr.WebApi/Sds.Osdr.WebApi.csproj -r $RID -c Release -o /dist/Sds.Osdr.WebApi

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime-deps:3.1

LABEL maintainer="rick.zakharov@gmail.com"

WORKDIR /app

RUN apt-get update && apt-get install -y curl
RUN curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /app/wait-for-it.sh && chmod 777 /app/wait-for-it.sh
RUN apt-get update && apt-get install -y procps

COPY --from=build-env /dist ./
COPY --from=build-env /dist/Sds.Osdr.Domain.BackEnd/appsettings.BackEnd.json ./appsettings.BackEnd.json
COPY --from=build-env /dist/Sds.Osdr.Domain.FrontEnd/appsettings.FrontEnd.json ./appsettings.FrontEnd.json
COPY --from=build-env /dist/Sds.Osdr.Persistence/appsettings.Persistence.json ./appsettings.Persistence.json
COPY --from=build-env /dist/Sds.Osdr.Domain.SagaHost/appsettings.SagaHost.json ./appsettings.SagaHost.json
COPY --from=build-env /dist/Sds.Osdr.WebApi/appsettings.WebApi.json ./appsettings.WebApi.json

ENV ASPNETCORE_URLS http://+:18006
EXPOSE 18006

RUN apt-get update
RUN apt-get -y install supervisor
ADD supervisord.conf /etc/supervisord.conf
CMD ["supervisord", "-n"]
