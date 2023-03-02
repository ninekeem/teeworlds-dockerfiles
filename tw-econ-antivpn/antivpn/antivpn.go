package antivpn

import (
	"encoding/json"
	"io"
	"net/http"
	"strings"
)

type AntiVPN struct {
	token     string
	cache     map[string]bool
	banned    map[string]bool
	joinTimes map[string]int
}

type VPNCheckResult struct {
	IsVPN  bool
	Ban    bool
	Cached bool
}

type apiResponse struct {
	Security apiResponseSecurity `json:"security"`
}

type apiResponseSecurity struct {
	VPN   bool `json:"vpn"`
	Proxy bool `json:"proxy"`
	Tor   bool `json:"tor"`
	Relay bool `json:"relay"`
}

func (a *AntiVPN) CheckVPN(ip string) (VPNCheckResult, error) {
	result := VPNCheckResult{}

	if a.joinTimes[ip] >= 3 {
		result.Ban = true
		a.joinTimes[ip] = 0
	}

	if a.cache[ip] {
		result.IsVPN = true
		result.Cached = true
		a.joinTimes[ip]++
		return result, nil
	}

	url := "https://vpnapi.io/api/" + strings.Split(ip, ":")[0] + "?key=" + a.token
	req, err := http.NewRequest(http.MethodGet, url, nil)
	if err != nil {
		return VPNCheckResult{}, err
	}

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		return VPNCheckResult{}, err
	}

	resBody, err := io.ReadAll(res.Body)
	if err != nil {
		return VPNCheckResult{}, err
	}

	var response apiResponse
	err = json.Unmarshal(resBody, &response)
	if err != nil {
		return VPNCheckResult{}, err
	}

	if response.Security.VPN || response.Security.Proxy ||
		response.Security.Tor || response.Security.Relay {
		result.IsVPN = true
		a.joinTimes[ip]++
		a.cache[ip] = true
	}

	return result, nil
}

func NewAntiVPN(token string) *AntiVPN {
	return &AntiVPN{
		token:     token,
		cache:     make(map[string]bool),
		banned:    make(map[string]bool),
		joinTimes: make(map[string]int),
	}
}
