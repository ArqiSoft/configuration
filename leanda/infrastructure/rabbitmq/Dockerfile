FROM rabbitmq:3.6-management

RUN apt-get update

RUN apt-get install -y curl

# -L option tells cirl to follow redirects that may be added on the initial URL by resource owner
RUN curl https://www.rabbitmq.com/community-plugins/v3.6.x/rabbitmq_delayed_message_exchange-0.0.1.ez > $RABBITMQHOME/plugins/rabbitmq_delayed_message_exchange-0.0.1.ez

RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange

HEALTHCHECK --timeout=2s CMD curl -sf -u $RABBIT_MQ_USER:$RABBIT_MQ_PASSWORD http://localhost:15672/api/healthchecks/node || exit 1