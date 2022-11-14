package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"
)

var (
	version string
)

func main() {
	// Set routing rules
	http.HandleFunc("/demo/info", Info)

	//Use the default DefaultServeMux.
	err := http.ListenAndServe(":80", nil)
	if err != nil {
		log.Fatal(err)
	}
}

func Info(w http.ResponseWriter, r *http.Request) {
	currentTime := time.Now()

	hostname, err := os.Hostname()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	var output = " | " + version + " | " + hostname + " | " + currentTime.Format("2006.01.02 15:04:05.000000") + " | "
	io.WriteString(w, output)
	log.Println(output)
}
