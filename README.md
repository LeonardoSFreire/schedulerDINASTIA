# API de Agendamento

Um serviço de agendamento de webhooks desenvolvido pela **Comunidade DinastIA** - a maior comunidade de Agentes de IA do Brasil.

## Visão Geral

Esta API permite agendar chamadas de webhook para timestamps específicos. As mensagens são armazenadas no Redis e executadas apenas uma vez no horário especificado.

### Como Funciona

1. **Agendamento de Mensagens**: Quando você cria uma mensagem agendada, ela é armazenada no Redis e adicionada ao agendador interno
2. **Execução Única**: As tarefas são agendadas para executar apenas uma vez no timestamp especificado
3. **Persistência**: Na reinicialização do servidor, todas as mensagens do Redis são automaticamente restauradas e reagendadas
4. **Limpeza**: Após a execução do webhook, as mensagens são automaticamente removidas do Redis

## Pré-requisitos

- Python 3.x
- Servidor Redis executando localmente
- Dependências necessárias (instale com `pip install -r requirements.txt`)

## Configuração do Ambiente

Crie um arquivo `.env` com:

```env
# Configuração do Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Configuração da API
API_HOST=0.0.0.0
API_PORT=8000
API_TOKEN=seu-token-secreto-aqui
```

## Executando o Servidor

```bash
python scheduler_api.py
```

O servidor será iniciado em `http://localhost:8000`

## Autenticação

Todos os endpoints (exceto `/health`) requerem autenticação com Bearer token:

```
Authorization: Bearer seu-token-secreto-aqui
```

## Endpoints da API

### Agendar uma Mensagem

`POST /messages`

**Cabeçalhos:**
- `Authorization: Bearer seu-token-secreto-aqui`
- `Content-Type: application/json`

**Corpo:**
```json
{
  "id": "id-unico-da-mensagem",
  "scheduleTo": "2024-12-25T10:30:00Z",
  "payload": {
    "data": "dados-do-seu-webhook"
  },
  "webhookUrl": "https://seu-endpoint-webhook.com"
}
```

**Resposta:**
```json
{
  "status": "agendada",
  "messageId": "id-unico-da-mensagem"
}
```

### Listar Mensagens Agendadas

`GET /messages`

**Cabeçalhos:**
- `Authorization: Bearer seu-token-secreto-aqui`

**Resposta:**
```json
{
  "scheduledJobs": [
    {
      "messageId": "id-unico-da-mensagem",
      "nextRun": "2024-12-25T10:30:00",
      "job": "<function job at 0x...>"
    }
  ],
  "count": 1
}
```

### Remover uma Mensagem Agendada

`DELETE /messages/{message_id}`

**Cabeçalhos:**
- `Authorization: Bearer seu-token-secreto-aqui`

**Resposta:**
```json
{
  "status": "removida",
  "messageId": "id-unico-da-mensagem"
}
```

### Verificação de Saúde

`GET /health`

Nenhuma autenticação necessária.

**Resposta:**
```json
{
  "status": "saudável",
  "redis": "conectado"
}
```

## Códigos de Erro

- `401` - Token de autenticação ausente ou inválido
- `404` - Mensagem não encontrada (ao remover)
- `409` - Mensagem com ID já existe (ao criar)
- `500` - Erro interno do servidor

## Sobre a Comunidade DinastIA

Este projeto é desenvolvido pela **Comunidade DinastIA**, a maior comunidade de Agentes de IA do Brasil, dedicada ao avanço das tecnologias de inteligência artificial e automação.

## Licença

Este projeto está licenciado sob a Licença MIT.