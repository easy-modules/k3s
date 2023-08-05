package utils

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"errors"
	"fmt"
	"os"
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

func (u *IUltils) DownloadPackages(packageManager string, libs []string) (string, error) {
	args := strings.Join(libs, " ")

	cmd := exec.Command(packageManager, args)
	output, err := cmd.CombinedOutput()
	if err != nil {
		return "", errors.New(err.Error())
	}

	return string(output), nil
}

func (u *IUltils) GetCpu() int {
	return runtime.NumCPU()
}

func (u *IUltils) CreatePPKeys() error {
	err := os.Mkdir("./tmp", 0755)
	if err != nil {
		return fmt.Errorf("error creating tmp directory: %w", err)
	}

	privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		return fmt.Errorf("error generating private key: %w", err)
	}

	privateKeyPEM := &pem.Block{
		Type:  "RSA PRIVATE KEY",
		Bytes: x509.MarshalPKCS1PrivateKey(privateKey),
	}

	privateKeyFile, err := os.Create("./tmp/private.pem")
	if err != nil {
		return fmt.Errorf("error creating private key file: %w", err)
	}
	defer func(privateKeyFile *os.File) {
		err := privateKeyFile.Close()
		if err != nil {
			fmt.Printf("error closing private key file: %v", err)
		}
	}(privateKeyFile)

	err = pem.Encode(privateKeyFile, privateKeyPEM)
	if err != nil {
		return fmt.Errorf("error encoding private key: %w", err)
	}

	publicKey := privateKey.PublicKey
	publicKeyBytes, err := x509.MarshalPKIXPublicKey(&publicKey)
	if err != nil {
		return fmt.Errorf("error marshalling public key: %w", err)
	}

	publicKeyPEM := &pem.Block{
		Type:  "RSA PUBLIC KEY",
		Bytes: publicKeyBytes,
	}
	publicKeyKeyFile, err := os.Create("./tmp/public.pem")
	if err != nil {
		return fmt.Errorf("error creating public key file: %w", err)
	}
	defer func(publicKeyKeyFile *os.File) {
		err := publicKeyKeyFile.Close()
		if err != nil {
			fmt.Printf("Error closing public key file: %v", err)
		}
	}(publicKeyKeyFile)

	err = pem.Encode(publicKeyKeyFile, publicKeyPEM)
	if err != nil {
		return fmt.Errorf("error encoding public key: %w", err)
	}
	fmt.Println("Keys generated successfully")
	return nil
}

func (u *IUltils) DeletePPKeys() error {
	err := os.Remove("./tmp/private.pem")
	if err != nil {
		return fmt.Errorf("error removing private key file: %w", err)
	}

	err = os.Remove("./tmp/public.pem")
	if err != nil {
		return fmt.Errorf("error removing public key file: %w", err)
	}

	err = os.Remove("./tmp")
	if err != nil {
		return fmt.Errorf("error removing tmp directory: %w", err)
	}

	fmt.Println("Keys deleted successfully")
	return nil
}
