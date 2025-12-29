package config

import (
	"encoding/json"
	"fmt"
	"os"
)

type GlobalConfig struct {
	PostgresSettings PostgresSettings `json:"postgress_settings"`
	Host             string           `json:"host"`
	Port             string           `json:"port"`
}

type PostgresSettings struct {
	Host     string `json:"host"`
	Port     string `json:"port"`
	User     string `json:"user"`
	Password string `json:"password"`
	DBName   string `json:"db_name"`
}

func (c *GlobalConfig) InitConfig(path string) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return fmt.Errorf("cannot read config file %s: %w", path, err)
	}

	if err := json.Unmarshal(data, &c); err != nil {
		return fmt.Errorf("cannot parse config file %s: %w", path, err)
	}

	return nil
}

func NewConfig() *GlobalConfig {
	return &GlobalConfig{}
}
