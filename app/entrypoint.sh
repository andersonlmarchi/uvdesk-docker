#!/bin/bash

export DATABASE_URL="mysql://$UV_DATABASE_USER:$UV_DATABASE_PASS@$UV_DATABASE_HOST:3306/$UV_DATABASE_NAME"

echo "⏳ Aguardando o MySQL estar pronto..."
until mysqladmin ping -h "$UV_DATABASE_HOST" --silent; do
  echo "MySQL ainda não está pronto, tentando novamente em 2 segundos..."
  sleep 2
done
echo "✅ MySQL está pronto!"

cd /var/www/html

if [ ! -d /community-skeleton ]; then
  echo "📥 Baixando UVdesk Community Skeleton..."
  git clone https://github.com/uvdesk/community-skeleton.git
fi

cd community-skeleton/

if [ ! -f vendor/autoload.php ]; then
  echo "📦 Instalando dependências PHP..."
  COMPOSER_MEMORY_LIMIT=-1 composer install
fi

if [ ! -d node_modules ]; then
  echo "📦 Instalando dependências do frontend..."
  yarn install
fi

echo "🛠️ Compilando assets do frontend..."
yarn encore production || true

echo "🛠️ Instalando assets do Symfony..."
php bin/console assets:install --symlink --relative public

echo "🧹 Limpando cache do Symfony..."
php bin/console cache:clear --env=prod

echo "⚙️  Rodando migrations..."
php bin/console doctrine:schema:update --force --no-interaction --complete

echo "📬 Configurando helpdesk UVdesk..."
php bin/console uvdesk:configure-helpdesk --no-interaction || true

echo "🔌 Configurando extensões UVdesk..."
php bin/console uvdesk_extensions:configure-extensions --no-interaction || true

echo "🧹 Limpando cache do Symfony..."
php bin/console cache:clear --env=prod

echo "✅ Inicialização concluída. Iniciando PHP-FPM..."
exec php-fpm