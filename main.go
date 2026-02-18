package main

import (
	"ci_pipeline_docker/database"
	"ci_pipeline_docker/routes"
)

func main() {
	database.ConectaComBancoDeDados()
	routes.HandleRequest()
}
