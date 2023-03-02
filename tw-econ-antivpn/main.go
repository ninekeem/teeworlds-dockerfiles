package main

import (
	"log"
	"os"
	"os/signal"
	"regexp"
	"strings"

	"github.com/xbt573/tw-econ-antivpn/antivpn"
	"github.com/xbt573/tw-econ-antivpn/econ"
)

var (
	playerJoinedRegex = regexp.MustCompile(`ClientID=(\d+) addr=(.*):\d+`)

	host        = getEnvDefault("TW_HOST", "localhost")
	port        = intMustParse(getEnvDefault("TW_PORT", "8303"))
	password    = getEnv("TW_PASSWORD")
	token       = getEnv("API_TOKEN")
	kickMessage = getEnvDefault("KICK_MESSAGE", "Kicked for VPN")
	banMessage  = getEnvDefault("BAN_MESSAGE", "Banned for VPN")
	banTime     = intMustParse(getEnvDefault("BAN_TIME", "60"))

	console = econ.NewECON(host, password, port)
	vpn     = antivpn.NewAntiVPN(token)

	signalChannel = make(chan os.Signal, 1)
)

func mainLoop() {
	for console.Connected {
		message, err := console.Read()
		if err != nil {
			log.Fatalln(err)
		}

		if strings.Contains(message, "player has entered the game") {
			match := playerJoinedRegex.FindStringSubmatch(message)
			checkResult, err := vpn.CheckVPN(match[2])
			if err != nil {
				log.Fatalln(err)
			}

			id := intMustParse(match[1])

			if checkResult.Ban {
				err := console.Ban(id, banTime, banMessage)
				if err != nil {
					log.Fatalln(err)
				}
			} else if checkResult.IsVPN {
				err := console.Kick(id, kickMessage)
				if err != nil {
					log.Fatalln(err)
				}
			}

			switch {
			case checkResult.Ban:
				log.Printf("Banned %v\n", match[2])

			case checkResult.IsVPN && checkResult.Cached:
				log.Printf("Kicked %v (cached)\n", match[2])
			case checkResult.IsVPN:
				log.Printf("Kicked %v\n", match[2])
			}
		}
	}
}

func init() {
	log.SetFlags(0)
	log.SetOutput(new(logWriter))

	signal.Notify(signalChannel, os.Interrupt)
}

func main() {
	log.Println("Starting tw-econ-antivpn...")

	err := console.Connect()
	if err != nil {
		log.Fatalln(err)
	}

	go mainLoop()

	log.Println("Started! Waiting for server shutdown or interrupt...")

	select {
	case <-signalChannel:
		break

	case <-console.Completed:
		break
	}

	log.Println("Shutting down...")
}
