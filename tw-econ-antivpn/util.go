package main

import (
	"log"
	"os"
	"strconv"
)

func getEnv(name string) string {
	env, exists := os.LookupEnv(name)
	if !exists {
		log.Fatalf("%v not set\n", name)
	}

	return env
}

func getEnvDefault(name string, defaultValue string) string {
	env, exists := os.LookupEnv(name)
	if !exists {
		return defaultValue
	}

	return env
}

func intMustParse(str string) int {
	result, err := strconv.Atoi(str)
	if err != nil {
		log.Fatalf("\"%v\" is invalid integer\n", str)
	}

	return result
}
