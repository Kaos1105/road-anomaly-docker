# SNET Deploy

Using Docker Compose to build and deploy all SNET systems

## Usage

To get started, make sure to install Docker and Docker Compose on a Linux system. Then clone this repo.

Next, navigate in the terminal to the directory you cloned this repository and clone the SNET Projects.

1. Check out to desired branch (ex: develop, staging)

Directory structure:

```bash
├── SNET
│   ├── Main_API
│   ├── Main_WEB
│   ├── ${PROJECT}_API
│   ├── ${PROJECT}_WEB
│   ├── dockerfiles
│   ├── .env.docker
│   ├── docker-compose.yml
```

1. Copy .env.docker and rename to .env. Edit .env with correct values.
2. Public these ports in the server:
    1. MariaDB: 3306
    2. Apache
        1. Server: 3110, 3120, 3130, ….
        2. Client: 3111, 3121, 3131, …
3. Build Docker image

    ```bash
    docker-compose down
    docker-compose up -d --build
    ```

4. Build Frontend

    ```bash
    docker-compose run --rm -w /var/www/html/${REACT_PROJECT} npm install
    docker-compose run --rm -w /var/www/html/${REACT_PROJECT} npm run build
    ```

5. Deploy Backend

    ```bash
    docker-compose run --rm -w /var/www/html/${LARAVEl_PROJECT} php composer install
    docker-compose run --rm -w /var/www/html/${LARAVEl_PROJECT} php php artisan optimize:clear
    docker-compose run --rm -w /var/www/html/${LARAVEl_PROJECT} php php artisan migrate #only run when migrate database
    ```

6. Develop Frontend
    ```bash
    docker-compose run --rm -w /var/www/html/${REACT_PROJECT} npm install
    docker-compose run --rm -w /var/www/html/${REACT_PROJECT} --service-ports npm run dev
    ```