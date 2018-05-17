package database

import (
	"net/http"
)

type insecureTransport struct{}

func (t *insecureTransport) RoundTrip(req *http.Request) (*http.Response, error) {
	req.URL.Scheme = "http"
	return http.DefaultTransport.RoundTrip(req)
}
