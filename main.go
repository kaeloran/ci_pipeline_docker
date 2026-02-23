package main

import (
	"log"

	"ci_pipeline_docker/database"
	"ci_pipeline_docker/routes"

	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Erro ao carregar arquivo .env")
	}

	database.ConectaComBancoDeDados()
	routes.HandleRequest()
}
