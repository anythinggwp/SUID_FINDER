package httpserver

import (
	"net/http"
	"simply_http_server/config"
)

func Start(cfg *config.GlobalConfig) error {
	return http.ListenAndServe(cfg.Host+":"+cfg.Port, ViewRouter(cfg))
}
