import pandas as pd
import random
import time
import boto3
import json
import os 

AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
AWS_REGION = os.getenv("AWS_REGION")

# Carregar o arquivo CSV
csv_file = '../data/streaming_data/olist_order_reviews_dataset.csv'
df = pd.read_csv(csv_file)

# Configuração do cliente do Amazon Kinesis
delivery_stream_name = 'firehose-reviews-stream'
session = boto3.Session(aws_access_key_id=AWS_ACCESS_KEY_ID,
                         aws_secret_access_key=AWS_SECRET_ACCESS_KEY)
# Criar um cliente do Kinesis Data Firehose usando a sessão
firehose_client = session.client('firehose', region_name=AWS_REGION)

while True:
    # Gerar um número aleatório de linhas para selecionar
    num_rows = random.randint(1, 5) 
    
    # Selecionar linhas aleatórias do DataFrame
    selected_rows = df.sample(num_rows)
    
    # Enviar registros para o Amazon Kinesis
    for _, row in selected_rows.iterrows():
        data = json.dumps(row.to_dict()) 
        response = firehose_client.put_record(
        	DeliveryStreamName=delivery_stream_name,
        	Record={"Data": data}
    )
        print(f'Registro enviado: {response}')
        
    # Aguardar um intervalo de tempo antes de continuar o loop
    time.sleep(random.uniform(1, 5)) 