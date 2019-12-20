FROM docker.elastic.co/elasticsearch/elasticsearch:6.8.4
COPY elasticsearch.yml /usr/share/elasticsearch/config/

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch ingest-attachment