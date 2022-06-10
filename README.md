# Introduction
Rails App that can accept GPS waypoints associated to a vehicle, and then show them in a map

# The problem
Write a rails app that can accept GPS waypoints associated to a vehicle, and then show them in a map. 
A GPS waypoint represents a location based on a latitude/longitude pair, and a point in time. 
A vehicle is represented by a unique alphanumeric identifier, and can have multiple GPS waypoints.

Specifically, the app consists of the following endpoints:

- A JSON API endpoint named /api/v1/gps that accepts GPS waypoints associated to a vehicle. The following format must be used:
```json
{
  "latitude": 20.23,
  "longitude": -0.56,
  "sent_at": "2016-06-02 20:45:00",
  "vehicle_identifier": "HA-3452"
}
```
If no vehicle exists with that identifier, create it.

- An HTML endpoint named /show that shows the vehicles' most recent coordinate in a map (choose any map provider you want, such as Google Maps, Open Street Map, Bing Maps, Mapbox, etc.).

# Things to consider
1. All historical waypoints must be stored.
2. No authentication is required for the endpoints.
3. Waypoints received through the API must be processed in a background job processing framework.


# Basic configuration
- Ruby 2.5.1
- Ruby on Rails 6.0.3
- Postgres database
- Sidekiq
- Redis
- Docker & Docker-Compose

# Install Instructions on Ubuntu 18.04

### Install Ruby with RVM
1. Install dependencies
```
$ sudo apt-get install software-properties-common
```

2. Add the PPA and install the RVM
```
$ sudo apt-add-repository -y ppa:rael-gc/rvm
$ sudo apt-get update
$ sudo apt-get install rvm
```

3. Install ruby with RVM
```
$ rvm install 2.5.1
```

***

### Install Docker and Docker-Compose
1. Install packages to allow apt to use a repository over HTTPS:
```
$ sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```

2. Add Docker’s official GPG key:
```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

3. Add PPA (set up the stable repository)
```
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
4. Update package index and install Docker Engine - Community
```
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io -y
```

5. Solve permission denied
```
$ sudo usermod -a -G docker $USER
```

6. Install Docker Compose
```
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

***

### Build and run project
1. Clone repository
```
$ git clone git@github.com:rudolfaraya/last-ubication-vehicle.git
$ bundle install
$ yarn install --check-files
```
2. Set environment variables on .env
- Content:
```
POSTGRES_DATABASE=last_ubication_development
POSTGRES_USER=admin_test
POSTGRES_PASSWORD=admin_test
POSTGRES_HOST=database
POSTGRES_PORT=5432
REDIS_HOST=redis
GOOGLE_MAPS_API_KEY=
```
3. Run database configuration (db:setup, db:migrate):
```
$ make db-setup
```
- Access to map on:
```
http://localhost:3000/show
```
![](https://i.imgur.com/DvNO4MHl.png)
- View to sidekiq jobs on:
 ```
 http://localhost:3000/sidekiq
 ```
![](https://i.imgur.com/NeNGsjZl.png)
4. Others

- Run tests:
```
$ make run-tests
```
- Show logs:
```
$ make logs
```

5. Makefile instructions:
```
build:
	docker-compose build
up:
	docker-compose up -d
down:
	docker-compose down
restart:
	make down
	make up
rails-console:
	docker-compose exec app bundle exec rails console
ssh-container:
	docker-compose exec app /bin/bash
logs:
	docker-compose logs -f
run-tests:
	docker-compose exec app bundle exec rake spec
db-setup:
	docker-compose exec app bundle exec rake db:setup db:migrate
db-clear:
	make down
	docker volume rm last-ubication-vehicle_db_data last-ubication-vehicle_redis_data
```
6. Generate random data:
```
$ make rails-console # Open a Rails console
# Generate v number of vehicles and w number of waypoint of each of them
$ MapService.new.random_data(v, w) 

```
*** Redis and postgres docker volumes are persisted locally ***
