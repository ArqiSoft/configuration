# Use SDK image to build solution
FROM microsoft/dotnet:2.1-sdk AS build-env

ARG RID=linux-x64

# mongo db url for tests
ARG CI_MONGO_DB=ci_url

ENV OSDR_MONGO_DB=$CI_MONGO_DB



WORKDIR /build

RUN git clone https://github.com/ArqiSoft/leanda-core ./ 


RUN dotnet restore --configfile Nuget.config Sds.Osdr.Domain.BackEnd/Sds.Osdr.Domain.BackEnd.csproj
RUN dotnet restore --configfile Nuget.config Sds.Osdr.Domain.FrontEnd/Sds.Osdr.Domain.FrontEnd.csproj
RUN dotnet restore --configfile Nuget.config Sds.Osdr.Persistence/Sds.Osdr.Persistence.csproj
RUN dotnet restore --configfile Nuget.config Sds.Osdr.Domain.SagaHost/Sds.Osdr.Domain.SagaHost.csproj
RUN dotnet restore --configfile Nuget.config Sds.Osdr.WebApi/Sds.Osdr.WebApi.csproj


RUN dotnet publish Sds.Osdr.Domain.BackEnd/Sds.Osdr.Domain.BackEnd.csproj -r $RID -c Release -o /dist
RUN dotnet publish Sds.Osdr.Domain.FrontEnd/Sds.Osdr.Domain.FrontEnd.csproj -r $RID -c Release -o /dist
RUN dotnet publish Sds.Osdr.Persistence/Sds.Osdr.Persistence.csproj -r $RID -c Release -o /dist
RUN dotnet publish Sds.Osdr.Domain.SagaHost/Sds.Osdr.Domain.SagaHost.csproj -r $RID -c Release -o /dist
RUN dotnet publish Sds.Osdr.WebApi/Sds.Osdr.WebApi.csproj -r $RID -c Release -o /dist

# Build runtime image
FROM microsoft/dotnet:2.1-runtime-deps

LABEL maintainer="rick.zakharov@gmail.com"

WORKDIR /app

RUN apt-get update && apt-get install -y curl
RUN curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /app/wait-for-it.sh && chmod 777 /app/wait-for-it.sh
RUN apt-get update && apt-get install -y procps

COPY --from=build-env /dist ./

COPY core-light-startup.sh ./core-light-startup.sh
RUN chmod 777 ./core-light-startup.sh

ENV ASPNETCORE_URLS http://+:18006
EXPOSE 18006

CMD ["/bin/sh", "/app/core-light-startup.sh"]
