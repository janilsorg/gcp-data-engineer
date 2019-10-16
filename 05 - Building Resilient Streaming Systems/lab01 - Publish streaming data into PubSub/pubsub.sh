
# Cria um tópico chamado sandiego
gcloud pubsub topics create sandiego

# Publica mensagem para o tópico sandiego
gcloud pubsub topics publish sandiego --message "hello"

# Cria uma subscrição para o tópico
gcloud pubsub subscriptions create --topic sandiego mySub1

# Recupera mensagens enviadas para o tópico
gcloud pubsub subscriptions pull --auto-ack mySub1

# Cancelar inscrição
gcloud pubsub subscriptions delete mySub1


# Instalar python PIP API suporte
sudo apt-get install -y python-pip

# Instala a biblioteca google-cloud-pubsub
sudo pip install -U google-cloud-pubsub
