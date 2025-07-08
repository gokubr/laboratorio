#!/bin/bash

# Lista dos nodes no cluster (ajuste conforme seus nomes)
NODES=("node2" "node3")

# Caminho da chave pública SSH
SSH_KEY="$HOME/.ssh/id_rsa.pub"

# Verifica se a chave SSH existe, se não, gera uma nova sem senha
if [ ! -f "$SSH_KEY" ]; then
  echo "Chave SSH não encontrada. Gerando uma nova chave SSH..."
  ssh-keygen -t rsa -b 4096 -N "" -f "${SSH_KEY%.*}"
else
  echo "Chave SSH já existe em $SSH_KEY."
fi

# Copia a chave pública para cada node do cluster
for NODE in "${NODES[@]}"; do
  echo "Copiando chave SSH para o node: $NODE"
  ssh-copy-id -i "$SSH_KEY" root@"$NODE"
done

# Testa a conexão SSH sem senha para cada node
echo
echo "Testando conexão SSH sem senha para os nodes:"
for NODE in "${NODES[@]}"; do
  echo -n "Conectando em $NODE... "
  if ssh -o BatchMode=yes -o ConnectTimeout=5 root@"$NODE" "echo OK" &>/dev/null; then
    echo "Sucesso!"
  else
    echo "Falha na conexão."
  fi
done
