FROM maven:3.6-jdk-10-slim AS builder
RUN apt-get update
RUN apt-get -y install git
RUN git clone https://github.com/ArqiSoft/imaging-service.git /usr/src/imaging-service
RUN git clone https://github.com/ArqiSoft/office-file-processor-service.git /usr/src/office-file-processor-service
WORKDIR /usr/src/imaging-service
RUN mvn -B -Pdocker clean package
WORKDIR /usr/src/office-file-processor-service
RUN mvn -B -Pdocker package

FROM openjdk:8-jre
WORKDIR /app

RUN apt-get update && apt-get install -y curl
RUN curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /app/wait-for-it.sh && chmod 777 /app/wait-for-it.sh

COPY --from=builder /usr/src/imaging-service/target/sds-imaging-service.jar ./
COPY --from=builder /usr/src/office-file-processor-service/target/office-file-processor.jar ./

RUN apt-get update
RUN apt-get -y install supervisor
ADD supervisord.conf /etc/supervisord.conf
CMD ["supervisord", "-n"]