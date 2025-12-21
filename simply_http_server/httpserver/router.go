package httpserver

import (
	"net/http"
	"os"
	"path/filepath"
)

var frontendDir = "./front"

func ViewRouter() *http.ServeMux {
	mux := http.NewServeMux()
	fileServer := http.FileServer(http.Dir(frontendDir))
	mux.Handle("/assets/", fileServer) // если сборка Vue в dist/assets
	mux.Handle("/js/", fileServer)
	mux.Handle("/css/", fileServer)

	// Корень и все остальные пути → index.html (SPA fallback)
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		indexPath := filepath.Join(frontendDir, "index.html")

		// проверяем существует ли файл (для SPA fallback)
		if _, err := os.Stat(indexPath); os.IsNotExist(err) {
			http.Error(w, "index.html не найден", http.StatusInternalServerError)
			return
		}

		http.ServeFile(w, r, indexPath)
	})
	return mux
}

func ApiRouter() *http.ServeMux{
		mux := http.NewServeMux()
	fileServer := http.FileServer(http.Dir(frontendDir))
	mux.Handle("/assets/", fileServer) // если сборка Vue в dist/assets
	mux.Handle("/js/", fileServer)
	mux.Handle("/css/", fileServer)

	// Корень и все остальные пути → index.html (SPA fallback)
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		indexPath := filepath.Join(frontendDir, "index.html")

		// проверяем существует ли файл (для SPA fallback)
		if _, err := os.Stat(indexPath); os.IsNotExist(err) {
			http.Error(w, "index.html не найден", http.StatusInternalServerError)
			return
		}

		http.ServeFile(w, r, indexPath)
	})
	return mux
}
