# Leanda Lite Configuration

## Run locally

```terminal
docker network create leanda-net
```

```terminal
docker-compose up
```

## Environment Variables

Environment Variable            | Value
------------------------------- | -------------
IDENTITY_SERVER_URL             | https://id.leanda.io/auth/realms/OSDR
OSDR_LOG_FOLDER                 | /logs
OSDR_MONGO_DB                   | mongodb://mongo:27017/osdr_dev
OSDR_RABBIT_MQ                  | rabbitmq://guest:guest@rabbitmq:5672/osdr_dev
MAX_BLOB_SIZE                   | 419430400
OSDR_REDIS                      | redis
OSDR_EVENT_STORE                | ConnectTo=tcp://admin:changeit@eventstore:1113
OSDR_ES                         | http://elasticsearch:9200
SWAGGER_BASEPATH                | /core-api/v1
OSDR_LOG_LEVEL                  | Debug
OSDR_TEMP_FILES_FOLDER          | /temp
CORE_API_URL                    | http://localhost/core-api/v1/api
BLOB_STORAGE_API_URL            | http://localhost/blob/v1/api
IMAGING_URL                     | http://localhost:7972/api
SIGNALR_URL                     | http://localhost/core-api/v1/signalr
METADATA_URL                    | http://localhost:63790/api
PROXY_JSMOL_URL                 | http://localhost/core-api/v1/api/proxy/jsmol
KETCHER_URL                     | https://leanda.io/ketcher/indigo/layout
REALM                           | OSDR
