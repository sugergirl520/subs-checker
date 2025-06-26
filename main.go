package main

import (
	"fmt"
	"log/slog"
	"os"

	"github.com/bruceblink/subs-checker/app"
)

var (
    Version       = "unknown"
    CurrentCommit = "unknown"
)

func main() {
	application := app.New(fmt.Sprintf("%s-%s", Version, CurrentCommit))
	slog.Info(fmt.Sprintf("当前版本: %s-%s", Version, CurrentCommit))

	if err := application.Initialize(); err != nil {
		slog.Error(fmt.Sprintf("初始化失败: %v", err))
		os.Exit(1)
	}

	application.Run()
}
