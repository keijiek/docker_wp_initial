## .env

```bash
# プロジェクト名
COMPOSE_PROJECT_NAME=wp_theme_making

# MySQL のユーザー・パスワード・データベース
MYSQL_ROOT_PASSWORD=passowrd
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wordpress_db_user
MYSQL_PASSWORD=password
```

## docker-compose.yml

```yml
version: '3.8'

services:
  mariadb:
    image: mariadb:10.5
    volumes:
      - ./volumes/mysql/:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}

  wordpress:
    image: wordpress:latest
    volumes:
      - ./volumes/themes:/var/www/html/wp-content/themes
      - ./volumes/plugins:/var/www/html/wp-content/plugins
      - ./volumes/uploads:/var/www/html/wp-content/uploads
    links:
      - mariadb
    depends_on:
      - mariadb
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: mariadb
      WORDPRESS_DB_NAME: ${MYSQL_DATABASE}
      WORDPRESS_DB_USER: ${MYSQL_USER}
      WORDPRESS_DB_PASSWORD: ${MYSQL_PASSWORD}
```

### ディレクティブの説明

- hostname : (規定値)コンテナID
- container_name : (規定値)プロジェクト名+サービス名+連番
  - プロジェクト名は、このディレクトリ名か、.env に設定した COMPOSE_PROJECT_NAME の値が使われる。

### yml 文法について

- インデントによる階層構造が適切でなければエラーになる。

## パーミッションの変え方

- WordPress のテーマやプラグインを開発する時にやっかいなのはパーミッション。
- WordPress 関連ディレクトリのオーナーは、ウェブサーバーの実行者(例えばwww-data)でなければ、コンパネ上の操作が上手くいかない。
- テーマやプラグインをいじる場合は、グループに自身のユーザー名を登録し、グループの権限を高めて行うとよい。公開時はグループの権限を0に戻す。
- ディレクトリは7(rwx)、ファイルは6(rw)、に一斉に合わせるため、次のように操作する。

```bash
sudo chown -R www-data:hoge ./targetDir
# 編集時
sudo find ./targetDir -type d -exec chmod 775 {} \;
sudo find ./targetDir -type f -exec chmod 664 {} \;
# 公開時
sudo find ./targetDir -type d -exec chmod 705 {} \;
sudo find ./targetDir -type f -exec chmod 604 {} \;
```

## docker-compose コマンド

### コンテナの作成と開始と停止と削除

```bash
# 最初はこれでコンテナ群を作成・起動
docker-compose up -d
# 存在するコンテナ群を起動
docker-compose start
# コンテナ群停止
docker-compose stop
# コンテナ群を停止・削除
docker-compose down
```

### コンテナにログイン

```bash
# コンテナの name や id などを確認したいなら
docker-compose ps
# コンテナにログイン(wordpress はコンテナ名)
docker-compose exec containerNameOrId /bin/bash
```
