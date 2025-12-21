package httpserver

import "net/http"

func Start(addres, port string) error {
	return http.ListenAndServe(addres+":"+port, ViewRouter())
}
