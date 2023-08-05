package main

import (
	"devopstation/utils"
	"fmt"
)

func main() {
	fn := utils.NewUtils()
	events := fn.DeletePPKeys()
	fmt.Println(events)
}
