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
- Ruby 2.6.5
- Ruby on Rails 6.0.3
- Postgres database
- Sidekiq
- Redis

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
$ rvm install 2.6.5
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
```
2. Copy master.key on repository: config/master.key. To recreate key you can use `rails credentials:edit` or follow the next [instructions](https://gist.github.com/db0sch/19c321cbc727917bc0e12849a7565af9)
- Content:
```
google:
  maps:
    api_key: INSERT_YOUR_GOOGLE_MAPS_API_KEY
postgres:
  username: postgres
  password: docker
```
3. Run redis and database container services:
```
$ make up
```
4. Run Sidekiq (for asynchronous tasks) 
```
$ bundle exec sidekiq
```
5. Run Rails Server (for asynchronous tasks) 
```
$ rails s
```
* Otherwise you can use: `m̀ake sidekiq` (resume step 3-4 and check database)
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
6. Others

- Run tests:
```
$ bundle exec rspec
```

7. Makefile instructions:
```
# Up redis and postgres container services
up: 
	docker-compose up -d
# Down redis and postgres container services
down: 
	docker-compose down
# Rspec Testing
test: 
	bundle exec rspec
# Create development and test database
db-create:
	rails db:create
db-setup:
	rails db:setup
# Clean and drop database and volumes
db-clear: 
	rails db:drop
	make down
	docker volume rm last-ubication-vehicle_db-postgres last-ubication-vehicle_redis-data
```
8. Generate random data:
```
$ rails c # Open a Rails console
# Generate v number of vehicles and w number of waypoint of each of them
$ MapService.new.random_data(v, w) 

```
*** Redis and postgres docker volumes are persisted locally ***