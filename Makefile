sidekiq:
	make up
	make db-setup
	bundle exec sidekiq
up:
	docker-compose up -d
down:
	docker-compose down
test:
	bundle exec rspec
db-create:
	rails db:create
db-setup:
	rails db:setup
db-clear:
	rails db:drop
	make down
	docker volume rm last-ubication-vehicle_db-postgres last-ubication-vehicle_redis-data
