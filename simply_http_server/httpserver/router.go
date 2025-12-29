package httpserver

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"simply_http_server/config"
	"simply_http_server/models"
	"simply_http_server/postcli"
	"strconv"
	"strings"

	_ "github.com/lib/pq"
)

var frontendDir = "./front/laba/dist"

func ViewRouter(cfg *config.GlobalConfig) *http.ServeMux {
	mux := http.NewServeMux()
	fileServer := http.FileServer(http.Dir(frontendDir))

	cli, err := postcli.NewPostgresCli(cfg.PostgresSettings)
	if err != nil {
		log.Fatalf("can't connect to postgres: %v", err)
	}

	mux.Handle("/assets/", fileServer)
	mux.Handle("/js/", fileServer)
	mux.Handle("/css/", fileServer)
	mux.Handle("/post", corsMiddleware(PostInfoRouter(cli)))
	mux.Handle("/delete", corsMiddleware(DeleteInfoRouter(cli)))
	mux.Handle("/get", corsMiddleware(GetInfoRouter(cli)))
	mux.Handle("/patch", corsMiddleware(PatchInfoRouter(cli)))

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		indexPath := filepath.Join(frontendDir, "index.html")

		if _, err := os.Stat(indexPath); os.IsNotExist(err) {
			http.Error(w, "index.html не найден", http.StatusInternalServerError)
			return
		}

		http.ServeFile(w, r, indexPath)
	})
	return mux
}

func GetInfoRouter(postgresCli *postcli.PostgreCli) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		// запрашиваем все данные из таблицы с коментариями
		comments, err := postgresCli.GetComments()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)

		// записываем в буфер данные
		if err := json.NewEncoder(w).Encode(comments); err != nil {
			log.Printf("encode JSON error: %v", err)
		}
	}
}

func PostInfoRouter(postgresCli *postcli.PostgreCli) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var comment models.Comment

		if err := json.NewDecoder(r.Body).Decode(&comment); err != nil {
			http.Error(w, "invalid JSON", http.StatusBadRequest)
			log.Printf("decode JSON error: %v", err)
			return
		}

		if strings.TrimSpace(comment.Text) == "" {
			http.Error(w, "text field is required", http.StatusBadRequest)
			return
		}

		if err := postgresCli.InsertNewComment(&comment); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			log.Printf("failed to insert comment: %v", err)
			return
		}

		log.Printf("Inserted comment id=%d, created_at=%s", comment.ID, comment.CreatedAt)

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusCreated)

		if err := json.NewEncoder(w).Encode(&comment); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			log.Printf("encode JSON error: %v", err)
			return
		}
	}
}

func PatchInfoRouter(postgresCli *postcli.PostgreCli) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var comment models.Comment // исправлено: структура, а не указатель

		// получаем изменный комментарий
		if err := json.NewDecoder(r.Body).Decode(&comment); err != nil {
			http.Error(w, "invalid request body", http.StatusBadRequest)
			log.Printf("decode JSON error: %v", err)
			return
		}

		// проверка обязательных полей
		if comment.ID == 0 || strings.TrimSpace(comment.Text) == "" {
			http.Error(w, "id and text are required", http.StatusBadRequest)
			return
		}

		// отправляем запрос в БД для изменения записи
		if err := postgresCli.ChangeComment(&comment); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			log.Printf("failed to change comment: %v", err)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)

		// отправляем ответ с изменённым комментарием
		if err := json.NewEncoder(w).Encode(&comment); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			log.Printf("encode JSON error: %v", err)
			return
		}
	}
}

func DeleteInfoRouter(postgresCli *postcli.PostgreCli) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		idStr := r.URL.Query().Get("id")
		if idStr == "" {
			http.Error(w, "missing id parameter", http.StatusBadRequest)
			return
		}

		id, err := strconv.Atoi(idStr)
		if err != nil {
			http.Error(w, "invalid id parameter", http.StatusBadRequest)
			return
		}

		err = postgresCli.DeleteComment(id)
		if err != nil {
			http.Error(w, err.Error(), http.StatusNotFound)
			log.Printf("failed to delete comment id=%d: %v", id, err)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)

		if err := json.NewEncoder(w).Encode(map[string]interface{}{
			"deleted_id": id,
			"status":     "success",
		}); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			log.Printf("encode JSON error: %v", err)
			return
		}
	}
}

func corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*") // или конкретный фронтенд
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		// Обработка preflight запроса
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}