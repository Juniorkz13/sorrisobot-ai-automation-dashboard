# Payload sanitizado da Evolution API

Este arquivo registra um exemplo sanitizado de payload real recebido pelo Webhook do n8n a partir da Evolution API.

Dados sensíveis foram mascarados:

- números de telefone
- remoteJid
- ownerJid
- URLs de foto
- tokens
- nomes reais

```json
[
  {
    "headers": {
      "host": "seu-workspace.app.n8n.cloud",
      "user-agent": "axios/1.13.2",
      "content-length": "1478",
      "accept": "application/json, text/plain, */*",
      "accept-encoding": "gzip, br",
      "cdn-loop": "cloudflare; loops=1; subreqs=1",
      "cf-connecting-ip": "000.000.000.000",
      "cf-ew-via": "15",
      "cf-ipcountry": "BR",
      "cf-ray": "valor-mascarado",
      "cf-visitor": "{\"scheme\":\"https\"}",
      "cf-worker": "n8n.cloud",
      "content-type": "application/json",
      "x-forwarded-for": "000.000.000.000, 000.000.000.000",
      "x-forwarded-host": "seu-workspace.app.n8n.cloud",
      "x-forwarded-port": "443",
      "x-forwarded-proto": "https",
      "x-forwarded-server": "valor-mascarado",
      "x-is-trusted": "yes",
      "x-real-ip": "000.000.000.000"
    },
    "params": {},
    "query": {},
    "body": {
      "event": "messages.upsert",
      "instance": "sorrisobot",
      "data": {
        "key": {
          "remoteJid": "@s.whatsapp.net",
          "remoteJidAlt": "@s.whatsapp.net",
          "fromMe": false,
          "id": "AC511FEC2824C4D88DA62095D8BB38F7",
          "participant": "",
          "addressingMode": "lid"
        },
        "pushName": "",
        "status": "DELIVERY_ACK",
        "message": {
          "conversation": "Olá, gostaria de marcar uma consulta",
          "messageContextInfo": {
            "threadId": [],
            "deviceListMetadata": {
              "senderKeyIndexes": [],
              "recipientKeyIndexes": [],
              "senderKeyHash": {
                "0": 99,
                "1": 40,
                "2": 160,
                "3": 77,
                "4": 218,
                "5": 35,
                "6": 100,
                "7": 12,
                "8": 121,
                "9": 155
              },
              "senderTimestamp": {
                "low": 1780922206,
                "high": 0,
                "unsigned": true
              },
              "recipientKeyHash": {
                "0": 159,
                "1": 239,
                "2": 148,
                "3": 242,
                "4": 219,
                "5": 102,
                "6": 66,
                "7": 43,
                "8": 36,
                "9": 84
              },
              "recipientTimestamp": {
                "low": 1782166562,
                "high": 0,
                "unsigned": true
              }
            },
            "deviceListMetadataVersion": 2,
            "messageSecret": {
              "0": 115,
              "1": 93,
              "2": 15,
              "3": 224,
              "4": 89,
              "5": 181,
              "6": 44,
              "7": 150,
              "8": 84,
              "9": 214,
              "10": 78,
              "11": 225,
              "12": 20,
              "13": 96,
              "14": 2,
              "15": 254,
              "16": 149,
              "17": 239,
              "18": 54,
              "19": 63,
              "20": 138,
              "21": 142,
              "22": 226,
              "23": 33,
              "24": 68,
              "25": 188,
              "26": 226,
              "27": 234,
              "28": 150,
              "29": 89,
              "30": 108,
              "31": 17
            }
          }
        },
        "messageType": "conversation",
        "messageTimestamp": 1782169148,
        "instanceId": "4e2131a5-17ad-4387-9890-8d1820321aae",
        "source": "android"
      },
      "destination": "https://seu-workspace.app.n8n.cloud/webhook-test/evolution/sorrisobot/inbound",
      "date_time": "2026-06-22T19:59:08.161Z",
      "sender": "@s.whatsapp.net",
      "server_url": "http://localhost:8080",
      "apikey": "valor-mascarado"
    },
    "webhookUrl": "https://seu-workspace.app.n8n.cloud/webhook-test/evolution/sorrisobot/inbound",
    "executionMode": "test"
  }
]
```
