package main

import (
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

func Usage() {
	log.Println("Usage: highlow MAX_URL_LENGTH URL_BASE")
	log.Println("")
	log.Println(" MAX_URL_LENGTH - in bytes")
	log.Println(" URL_BASE - base url including protocol")
	log.Println("")
	log.Println("Example:")
	log.Println("highlow 2048 http://echo.maxymiser.qa/v5/")
	log.Println("")
}

func Request(req string) time.Duration {
	start := time.Now()
	resp, err := http.Get(req)
	if err != nil {
		log.Fatal("Achtung!")
	}

	resp.Body.Close()
	duration := time.Since(start)
	dur := strconv.Itoa(int(duration / time.Millisecond))
	log.Println("Queried in " + dur + "ms, len == " + strconv.Itoa(len(req)))

	return duration
}

func main() {
	if len(os.Args) != 3 {
		Usage()
		os.Exit(1)
	}

	max_length, err := strconv.Atoi(os.Args[1])
	if err != nil {
		log.Println("Unable to parse MAX_URL_LENGTH")
		Usage()
		os.Exit(3)
	}

	url := os.Args[2]
	size := max_length
	pos := max_length

	for {
		req := url + strings.Repeat("a", pos)

		if size <= 0 {
			log.Println("Upper boundary: " + req)
			break
		}

		d1 := Request(req)
		time.Sleep(500 * time.Millisecond)
		d2 := Request(req)
		time.Sleep(500 * time.Millisecond)

		size = size / 2
		if d1 < (150*time.Millisecond) && d2 < (150*time.Millisecond) {
			pos = pos + size
		} else {
			pos = pos - size
		}
	}
}
