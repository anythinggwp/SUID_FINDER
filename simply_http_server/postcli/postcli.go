package postcli

import (
	"database/sql"
	"errors"
	"fmt"
	"simply_http_server/config"
	"simply_http_server/models"
	"sync"
	"time"

	_ "github.com/lib/pq"
)

type PostgreCli struct {
	db *sql.DB
	mu sync.RWMutex
}

func NewPostgresCli(cfg config.PostgresSettings) (*PostgreCli, error) {
	var err error
	// Перевод конфигурационных параметров в формат для sql клиента
	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", cfg.Host, cfg.Port, cfg.User, cfg.Password, cfg.DBName)

	// создаем клиент для postgres
	db, err := sql.Open("postgres", dsn)
	if err != nil {
		return nil, err
	}

	// проверка соединения
	if err = db.Ping(); err != nil {
		return nil, err
	}

	// максимум 15 конетов к бд
	db.SetMaxOpenConns(15)
	// Максимум 10 ожидающих соединений
	db.SetMaxIdleConns(10)
	// время жизни соединения 10 минут
	db.SetConnMaxLifetime(10 * time.Minute)

	query := `
	CREATE TABLE IF NOT EXISTS comments (
		id SERIAL PRIMARY KEY,
		text TEXT NOT NULL,
		created_at TIMESTAMP NOT NULL DEFAULT now()
	);
	`

	// создаем таблицу если нет
	_, err = db.Exec(query)
	if err != nil {
		return nil, err
	}

	return &PostgreCli{
		db: db,
		mu: sync.RWMutex{},
	}, nil
}

func (p *PostgreCli) GetComments() ([]models.Comment, error) {

	// получаем все строки из бд
	rows, err := p.db.Query(`SELECT id, text, created_at FROM comments ORDER BY created_at DESC`)
	if err != nil {
		return nil, errors.New("failed to query comments")
	}
	// заполняем массив даннымии из строки
	comments := []models.Comment{}
	for rows.Next() {
		var c models.Comment
		if err := rows.Scan(&c.ID, &c.Text, &c.CreatedAt); err != nil {
			return nil, errors.New("failed to scan row")
		}
		comments = append(comments, c)
	}
	return comments, nil
}

func (p *PostgreCli) InsertNewComment(comment *models.Comment) error {

	var id int
	var createdAt string

	// делаем вставку новой записи в таблицу
	err := p.db.QueryRow(`INSERT INTO comments (text) VALUES ($1) RETURNING id, created_at`, comment.Text).Scan(&id, &createdAt)
	if err != nil {
		return err
	}

	// сохраняем новый id и дату создания для информирования о успешном создании
	comment.ID = id
	comment.CreatedAt = createdAt
	return nil
}

func (p *PostgreCli) ChangeComment(comment *models.Comment) error {
	var createdAt string
	err := p.db.QueryRow(
		`UPDATE comments
		 SET text = $1,
		 	created_at = NOW()
		 WHERE id = $2 
		 RETURNING created_at`,
		comment.Text, comment.ID,
	).Scan(&createdAt)

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return errors.New("comment not found")
		}
		return errors.New("failed to update comment")
	}

	comment.CreatedAt = createdAt
	return nil
}

func (p *PostgreCli) DeleteComment(id int) error {

	_, err := p.db.Exec(`DELETE FROM comments WHERE id = $1 RETURNING id`, id)
	if err != nil {
		return err
	}
	return nil
}

// закрываем соединения с бд
func (p *PostgreCli) Close() error {
	p.mu.Lock()
	defer p.mu.Unlock()

	if p.db != nil {
		return p.db.Close()
	}
	return nil
}
