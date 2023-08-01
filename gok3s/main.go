package main

import (
	"fmt"
	"gok3s/utils"
)

func main() {
	fn := utils.NewUtils()
	fmt.Println(fn.DowloadPackages("ls", []string{"-lha"}))
}
