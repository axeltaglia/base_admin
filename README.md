# Administrador de Instituciones
================================

## Descripción

El presente sistema propone la administración de instituciones educativas como academias, escuelas e institutos. 


## Tecnologías

Lenguage: Ruby v2.4.0
Framework: Ruby on Rails 5.0.2
Base de datos: PostgreSql 9.5

## Ambiente

## Instalación

### 1 - Instalación de Ruby

Me baso en este tutorial: https://cbednarski.com/articles/installing-ruby/

Instalaciones previas:

```
sudo apt-get install -y libssl-dev zlib1g-dev libreadline-dev
```

Instalo rbenv

```
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
exec $SHELL -l
```

INSTALO con rbenv la versión de Ruby 2.3.2 (que es la que requiere el proyecto)

```
rbenv install 2.3.2
```

Correr este comando para asentar los cambios de gemas

```
rbenv rehash 
```

Pongo como default la versión de Ruby a utilizar

```
rbenv global 2.3.2
```

Instalación del bundler (este es la gema que se encarga de instalar otras gemas)

```
gem install bundler
rbenv rehash
```

### 2 - Instalación de Servidor PostgreSQL (>=9.4).

```
sudo apt-get install postgresql postgresql-contrib
```

Buscar el archivo pg_hba.conf.  

Para eso hacer "updatedb" para actualizar la base de búsqueda de archivos del "locate":

```
updatedb
```

luego:

```
locate ph_hba.conf
```

Y debe devolver algo así:

```
/etc/postgresql/9.6/main/pg_hba.conf
```

Editar el archivo con permisos de root:

```
sudo vim /etc/postgresql/9.6/main/pg_hba.conf
```

Cambiar los "peer" y el "md5" para la lista de ip v4 a "trust"


Al final del archivo, debe quedar algo así. 

```
# Database administrative login by Unix domain socket
local   all             postgres                                trust

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 md5
```

De esta manera, las conexiones locales e IP v4 serán confiadas.

Si se quiere habilitar una cierta IP:

```
host    all             all             xxx.xxx.xxx.xxx/32            md5
```

Para acceder desde afuera, debe permitir escuchar en el puerto 5432 no solo para localhost. Buscar archivo de configuración postgresql.conf:

```
locate postgresql.conf
```
Y la ruta esperada será algo así:

```
/etc/postgresql/9.5/main/postgresql.conf
```

Editar el archivo con permisos de root

```
sudo vim /etc/postgresql/9.5/main/postgresql.conf
```

Y habilitar todas las Ips para permitir de esta manera:

```
listen_addresses = '*'                  # what IP address(es) to listen on;
```

El usuario default que te crea postgres es el siguiente:

user: postgres
password: 

(sin password)

Para mayor seguridad, debe asignarse una contraseña e incluso crear otro usuario más específico para el proyecto "consul". Por ahora se usará este usuario y con contraseña vacía.

Ver siguientes links para cambiar contraseña:

https://stackoverflow.com/questions/12720967/how-to-change-postgresql-user-password
https://blog.2ndquadrant.com/how-to-safely-change-the-postgres-user-password-via-psql/

### 3 - Configuración del proyecto

Para descargar el proyecto, situarse en el directorio deseado para colocar la carpeta que contiene el proyecto. Luego:

```
git clone https://github.com/axeltaglia/institution_admin.git institution_admin
cd institution_admin
bundle install
cp config/database.yml.example config/database.yml
```

Luego modificar el usuario y contraseña de base de datos en el archivo config/database.yml. En nuestro caso: usuario "postgres" y password vacía.

A continuación:

Las variables de ambiente se cargan en el archivo .env en la raíz del proyecto. Este archivo está exceptuado en el .gitignore ya que se debe llenar con datos por entorno.

```
SENDGRID_USERNAME=Your_Username
SENDGRID_PASSWORD=Your_Password
DOMAIN_NAME=example.com
ADMIN_NAME=First User
ADMIN_EMAIL=email@gmail.com
ADMIN_PASSWORD=123456789
SITE_TITLE=AdminLTE Rails Template
SITE_DESCRIPTION=AdminLTE Rails Template
SECRET_KEY_BASE=de99e26d3ba8443c76cb9baafa3d3fcfd4bda63974ef3caa04f249271874e1a78f56a288db97d57e581e802d2b2c1c8de1668f22c7b26c66a80ca2d41d45a905
```

Para generar una secret key:

```
bundle exec rake secret
```

```
cp config/secrets.yml.example config/secrets.yml
bin/rake db:setup RAILS_ENV=development
bin/rake db:dev_seed RAILS_ENV=development
```

Nota: Otra forma de levantar la base (en vez de db:setup) es correr todas las migraciones. De esta manera podemos crear la base de datos a mano y luego ejecutar el siguiente comando:
```
RAILS_ENV=development bin/rake db:drop
RAILS_ENV=development bin/rake db:create
RAILS_ENV=development bin/rake db:migrate
RAILS_ENV=development bin/rake db:seed
```

Para ejecutar el proyecto de forma local:

```
bin/rails s
```

Para ejecutar el servidor en un puerto específico (-p), bindearse con IP específica (-b), levantar un entorno específico (-e) y ejecutar como daemond (-d), ejecutar de la siguiente forma:

```
rails s -b 172.31.30.101 -p 3000 -e development -d
```

Después de esto, navegar desde un navegador: localhost:3000 y veremos el proyecto de forma local.


Para ejecutar tests:

```
bin/rspec
```

Usuario Administrador:

Seteado en .env


### Actuaizacíón de la base de datos

```
rake db:migrate RAILS_ENV="development"
```


## Instalación del sitio con Passenger + Apache2

Basarse en este tutorial

https://www.phusionpassenger.com/library/install/apache/install/oss/xenial/


## Poner un sitio en producción con Passenger + Apache2

Basarse en este tutorial

https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/apache/oss/xenial/deploy_app.html#rails_determine-the-ruby-command-that-passenger-should-use

### Log de Passenget

https://www.phusionpassenger.com/library/admin/apache/log_file/#location-of-the-log-file


## Otros módulos que se deben instalar

### ImageMagick

Instalar con permisos de root:

```
sudo apt-get install imagemagick libmagickcore-dev libmagickwand-dev libmagic-dev
sudo apt-get install imagemagick
```

## Servidor y entornos

En el proyecto, actualmente tenemos dos entornos: development y staging

```
URL development: http://ruby.magnetico.com.ar:3000/

URL staging: http://ruby.magnetico.com.ar:3001/
```

Rutas de los proyectos dentro del servidor:

```
PATH development: /home/rubydev/projects/participacion_ciudadana/dev

PATH staging: /home/rubydev/projects/participacion_ciudadana/stg
```

### Correr el servidor de rails en los entornos

Primero situarse en el root del entorno. Luego ejecutar lo siguiente.

```
DEV: bin/rails s -b 172.31.30.101 -p 3000 -e development -d

STG: bin/rails s -b 172.31.30.101 -p 3001 -e staging -d

```

Para ver los servicios de servidores de Rails corriendo, ejecutar:

```
ps -fea | grep rails
```
Para bajar el servidor de rails, obtener el número de proceso con el comando anterior y luego ejecutar:

```
kill -9 [numero de proceso del servidor]
```

Para actualizar el entorno:


```
Dev: git pull origin development
Stg: git pull origin testing
```

Para correr migraciones (si es que las hubiera):

```
Dev: bin/rake db:migrate RAILS_ENV=development
Stg: bin/rake db:migrate RAILS_ENV=testing
```

Probablemente al correrlas, genere cambios de fechas en el schema.rb. Este archivo habrá que volverlo atrás haciendo:

```
git checkout db/schema.rb
```

Esto evitará problemas al volver a hacer pull.

O bien configurar git para que resuelva de forma automática el conflicto generado en este archivo:

https://tbaggery.com/2010/10/24/reduce-your-rails-schema-conflicts.html


