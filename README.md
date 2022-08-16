# Translations API

## Overview
This is a Dockerized, API-only Ruby on Rails application with several endpoints to manage glossaries and translations.

Features:\
- REST API using Grape.
- Tests using RSpec.
- PostgreSQL database.
- Swagger UI for API documentation and interaction.
- Dockerfile that helps to run the API.

## Installation
You can use Docker to install and run this application:

```
docker-compose build

# One time
docker-compose run web bash
rails db:create db:migrate

# And then, to start the server each time
docker-compose up web
```

## Documentation
All endpoints available within this API are well documented.
Swagger UI is set up to visualize and interact with the API’s resources. To access Swagger UI you can go to:

```
http://localhost:3000/swagger
```

## Testing
All endpoints in this API have been tested using RSpec. To run all tests:

```
bundle exec rspec
```