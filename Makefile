build:
	docker-compose build
up:
	docker-compose up -d
down:
	docker-compose down
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
	docker volume rm last-ubication-vehicle_db_data last-ubication-vehicle_redis_data
