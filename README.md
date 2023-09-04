# What i've build
O objetivo do projeto é criar um pipeline de dados no formato datalake que suporte tanto dados em batch quanto dados em streaming. Para isso vamos usar dados disponibilidados pela olist no kaggle.
A primeira coisa que criei foi o banco de dados postgres usando o RDS através do terraform. Depois, criei os scripts SQL que criam o esquema e também o script que insere os dados (batch e streaming). Em seguida, criei o kinesis data firehose para capturar os dados de streaming e um bucket s3 para receber as reviews dos clientes. Inicialmente o meu data producer funcionava em uma instância ec2. Decidi então rodar os scripts em um container docker através do SDK boto3 para simular uma interação entre ambientes on-premise e cloud. 

## Como rodar o código ?
    extrair os arquivos 'data.zip' e 'streaming_data.zip' para dentro da pasta 'files/data/'
	1. Setar as chaves da conta AWS no arquivo 'terraform.tfvars' (elas serão usadas para criar o template na aws)
	2. Rodar o comando 'make tf-apply' dentro de um ambiente linux (ubuntu WSL por exemplo), ou rodar o comando docker diretamente no terminal
	3. Depois que a estrutura estiver funcionando, adicionar o nome do bucket e as chaves de acesso no arquivo 'env_variables.cmd'
    4. Rodar o comando "call env_variables.cmd"
    5. Executar os arquivos "batch_data_producer.py" e "streaming_data_producer.py"

<!-- **Importante** gerador de policy da aws
    (https://awspolicygen.s3.amazonaws.com/policygen.html)
 -->

<!-- Proximos passos
* Extrair dados do RDS e enviar para a bronze layer (s3)
    * Usar lambda para fazer a extração
    * Conectar ao banco sem precisar do host, username, etc (através de uma VPC ?)
    * Permissões: s3
    * Passar package com os pacotes usados (pip install pacote1 pacote2 pacote3 -t packages/)
    * zip -r lambda_layer.zip lambda_layer/
    * Adicionar meu zip na layer do lambda e testar o script
 -->

<!-- 
# Como documentar o meu projeto ?
	* What i've build
	* The steps i took
	* What services i used
	* Include diagrams/screenshots
	* Make a video showing how it works

## Conexão com postgres diretamente pelo terminal
psql --host=postgres.cwtw8vsrsinc.us-east-1.rds.amazonaws.com --port=5432 --username=gudy --password --dbname=awsPG
 -->