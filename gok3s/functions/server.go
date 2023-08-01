package utils

import (
	"errors"
	"os/exec"
	"runtime"
	"strings"
)

type IServer struct{}

func NewServer() *IServer {
	return &IServer{}
}

func (u *IServer) GetOS() string {
	return runtime.GOOS
}

func (u *IServer) GetArch() string {
	return runtime.GOARCH
}

func (u *IServer) DowloadPackages(packageManager string, libs []string) (string, error) {
	args := strings.Join(libs, " ")

	cmd := exec.Command(packageManager, args)
	output, err := cmd.CombinedOutput()
	if err != nil {
		return "", errors.New(err.Error())
	}

	return string(output), nil
}
