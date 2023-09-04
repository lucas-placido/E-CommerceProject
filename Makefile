# Generate ssh key for ec2 instance
generate-key:
	yes | ssh-keygen -t ed25519 -f "./terraform/ssh-key" -N "" -C "ssh-key"

# Terraform commands
tf-init:
	docker run --rm -it -v ./terraform/:/app -w /app hashicorp/terraform:light init

tf-plan:
	docker run --rm -it -v ./terraform/:/app -w /app hashicorp/terraform:light plan
	
tf-apply:
	docker run --rm -it -v ./terraform/:/app -w /app hashicorp/terraform:light apply --auto-approve

tf-destroy:
	docker run --rm -it -v ./terraform/:/app -w /app hashicorp/terraform:light destroy --auto-approve

tf-up: tf-init generate-key tf-apply

# Data Producers
build:
	cd files && docker build -t py_img:v1 .

create:
	docker run --rm -v ./files/:/app --env-file ./files/env_variables.txt py_img:v1 python3 create_schema.py
# CRIAR FUNÇÃO ASSINCRONA PARA RODAR O SCRIPT DE BATCH E STREAMING AO MESMO TEMPO !!!
batch_input:
	docker run --rm -v ./files/:/app --env-file ./files/env_variables.txt py_img:v1 python3 batch_data_producer.py

stream_input:
	docker run --rm -v ./files/:/app --env-file ./files/env_variables.txt py_img:v1 python3 kinesis_data_producer.py

run: create batch_input stream_input