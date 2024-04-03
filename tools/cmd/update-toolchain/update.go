package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

type Asset struct {
	Url                string `json:"url"`
	Id                 int    `json:"id"`
	Name               string `json:"name"`
	Label              string `json:"label"`
	ContentType        string `json:"content_type"`
	State              string `json:"state"`
	Size               int    `json:"size"`
	DownloadCount      int    `json:"download_count"`
	CreatedAt          string `json:"created_at"`
	UpdatedAt          string `json:"updated_at"`
	BrowserDownloadUrl string `json:"browser_download_url"`
	// Include other fields from the JSON response that you're interested in
}

type Release struct {
	Url       string  `json:"url"`
	AssetsUrl string  `json:"assets_url"`
	UploadUrl string  `json:"upload_url"`
	HtmlUrl   string  `json:"html_url"`
	Id        int     `json:"id"`
	Assets    []Asset `json:"assets"`
	// Include other fields from the JSON response that you're interested in
}

func main() {
	resp, err := http.Get("https://api.github.com/repos/cue-lang/cue/releases/latest")
	if err != nil {
		fmt.Printf("The HTTP request failed with error %s\n", err)
	} else {
		data, _ := io.ReadAll(resp.Body)
		var release Release
		json.Unmarshal(data, &release)
		fmt.Printf("Latest release assets: %v\n", release.Assets)
	}
}
