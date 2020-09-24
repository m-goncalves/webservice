package main

import (
	"net/http"

	"github.com/m-goncalves/webservice/server"
)

func main() {
	// setting up the routes (home and upload).
	http.HandleFunc("/", server.GetFile)
	http.HandleFunc("/upload", server.Upload)
	//setting up port to listen on. Check the importance of the second paramenter later
	http.ListenAndServe(":8080", nil)
}
