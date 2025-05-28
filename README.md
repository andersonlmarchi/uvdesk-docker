
# UVdesk Dockerized - Deploy Completo

Este projeto entrega uma stack Dockerizada para rodar o **UVdesk Helpdesk** em produção com:

- Banco de dados (MySQL)
- UVdesk (PHP 8.1 + PHP-FPM)
- Nginx (Servidor Web)
- Redis (Cache)

## Instalação

### 1. Clone o projeto
```bash
git clone https://www.github.com/andersonlmarchi/uvdesk-docker uvdesk
cd uvdesk
```

### 2. Rode o Docker Compose
```bash
sudo docker compose up -d
```

Após rodar o compose todas as pastas de Volumes serão criadas na raiz da pasta desse projeto.

### 3. Dar as permissões na pasta do Volume
```bash
sudo chmod -R 775 volumes/uvdesk/
```

### 4. Baixar o Uvdesk na pasta do Volume
```bash
cd volumes/uvdesk/
git clone https://github.com/uvdesk/community-skeleton.git
```

### 5. Instalar as dependências do UVdesk
```bash
cd community-skeleton/
sudo docker run --rm -v "${PWD}":/app -w /app composer install --ignore-platform-req=ext-mailparse
```
Esse ultimo comando irá rodar um container do composer para poder fazer a instalação do projeto sem precisar ter o composer instalado e configurado na sua máquina

## Acessar

Abrir o navegador e verificar se o UVdesk está rodando

```
http://localhost:8080
```

## Dados do banco
- Host: `db`
- Nome: `uvdesk`
- Usuário: `uvdesk`
- Senha: `uvdeskpass`

## Configurar Redis
Edite `.env` dentro de `volumes/uvdesk/community-skeleton/` e adicione a seguinte linha:
```
REDIS_URL=redis://uvdesk_redis:6379
```

O redis é usado internamente pelo UVdesk para cache, então é necessário configurar essa variável de ambiente.


## Comandos úteis
| Descrição         | Comando                         |
|-------------------|---------------------------------|
| Subir             | docker-compose up -d            |
| Parar             | docker-compose down             |
| Logs              | docker-compose logs -f          |
| Bash app          | docker exec -it uvdesk_app bash |
| Bash db           | docker exec -it uvdesk_db bash  |

