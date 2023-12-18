postgres:
	docker run --name postgres16 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:16-alpine

startcontainer:
	docker start postgres16

createdb:
	docker exec -it postgres16 createdb --username=root --owner=root simple_bank

accessdb:
	docker exec -it postgres16 psql -U root simple_bank

dropdb: 
	docker exec -it postgres16 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown: 
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb accessdb dropdb migrateup migratedown sqlc test