package utils

import (
	"errors"
	"os/exec"
	"runtime"
	"strings"
)

type IUltils struct{}

func NewUtils() *IUltils {
	return &IUltils{}
}

func (u *IUltils) GetOS() string {
	return runtime.GOOS
}

func (u *IUltils) GetArch() string {
	return runtime.GOARCH
}

func (u *IUltils) DowloadPackages(packageManager string, libs []string) (string, error) {
	args := strings.Join(libs, " ")

	cmd := exec.Command(packageManager, args)
	output, err := cmd.CombinedOutput()
	if err != nil {
		return "", errors.New(err.Error())
	}

	return string(output), nil
}
