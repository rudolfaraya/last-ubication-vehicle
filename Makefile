USERNAME = rudolfaraya
PROJECT_NAME = $(USERNAME)/last-ubication-vehicle
TAG = latest

build:
	docker-compose build
up:
	docker-compose up -d
down:
	docker-compose down
push:
	docker push $(PROJECT_NAME)-app:$(TAG)
rails-console:
	docker-compose exec app bundle exec rails console
ssh-container:
	docker-compose exec app /bin/sh
logs:
	docker-compose logs -f
run-tests:
	docker-compose exec app bundle exec rake spec
db:
	docker-compose exec app bundle exec rake db:setup db:migrate
db-clear:
	make down
	docker volume rm $(PROJECT_NAME)_db_data $(PROJECT_NAME)_redis_data
