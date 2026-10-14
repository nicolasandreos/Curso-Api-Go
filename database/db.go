package database

import (
	"log"
	"os"
	"github.com/guilhermeonrails/api-go-gin/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
) 

var (
	DB  *gorm.DB
	err error
)

func ConectaComBancoDeDados() {
	sslmode := os.Getenv("DATABASE_SSLMODE")
	if sslmode == "" {
		sslmode = "prefer"
	}

	stringDeConexao := "host="+os.Getenv("DATABASE_HOST")+" user="+os.Getenv("DATABASE_USER")+" password="+os.Getenv("DATABASE_PASSWORD")+" dbname="+os.Getenv("DATABASE_NAME")+" port="+os.Getenv("DATABASE_PORT")+" sslmode="+sslmode
	DB, err = gorm.Open(postgres.Open(stringDeConexao))
	if err != nil {
		log.Panic("Erro ao conectar com banco de dados")
	}

	DB.AutoMigrate(&models.Aluno{})
}
