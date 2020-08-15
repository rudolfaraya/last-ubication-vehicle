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
test:
	docker-compose exec app bundle exec rspec
db:
	docker-compose exec app bundle exec rake db:setup db:migrate
db-clear:
	make down
	docker volume rm last-ubication-vehicle_db_data last-ubication-vehicle_redis_data
