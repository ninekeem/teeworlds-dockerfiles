package main

import (
	"fmt"
	"time"
)

type logWriter struct{}

func (writer logWriter) Write(bytes []byte) (int, error) {
	return fmt.Printf("[%v] %v", time.Now().Format("2006-01-02 15:04:05"), string(bytes))
}
