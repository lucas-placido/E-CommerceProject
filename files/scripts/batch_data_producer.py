import boto3
import os
import sys

aws_key = os.getenv("AWS_ACCESS_KEY_ID")
aws_secret_key = os.getenv("AWS_SECRET_ACCESS_KEY")
aws_region = os.getenv("AWS_REGION")

# Nome do bucket S3 onde você deseja fazer o upload dos arquivos
bucket_name = os.getenv("bucket_name")

# Configuração do cliente S3
session = boto3.Session(aws_access_key_id=aws_key,
                        aws_secret_access_key=aws_secret_key)
s3 = session.client('s3', region_name=aws_region)

# Diretório local contendo os arquivos que você deseja enviar
local_directory = '../data/batch_data'

# Função para listar todos os arquivos em um diretório e seus subdiretórios
def list_files(directory):
    for root, dirs, files in os.walk(directory):
        for filename in files:
            yield os.path.join(root, filename)

# Loop pelos arquivos locais e envio para o S3
for local_file in list_files(local_directory):
    # Determina o nome do objeto S3 (chave) a partir do nome do arquivo local
    s3_object_key = os.path.relpath(local_file, local_directory)
    
    # Realiza o upload do arquivo para o S3
    try:
        s3.upload_file(local_file, bucket_name, s3_object_key)
        print(f'Arquivo enviado para o S3: {s3_object_key}')
    except Exception as e:
        print(f'Erro ao enviar arquivo {local_file} para o S3: {str(e)}')
