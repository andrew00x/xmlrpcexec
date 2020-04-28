package main

import (
	"flag"
	"fmt"
	"github.com/andrew00x/xmlrpc/pkg/xmlrpc"
	"os"
)

func main() {
	addr := flag.String("addr", "", "SCGI Address")
	method := flag.String("m", "", "XML-RPC method")
	flag.Parse()
	if *addr == "" {
		fmt.Println("\tError: SCGI address is required")
		os.Exit(1)
	}
	if *method == "" {
		fmt.Println("\tError: XML-RPC method is required")
		os.Exit(1)
	}
	client := xmlrpc.CreateSCGIClient(*addr)
	var resp []interface{}
	var err error
	if len(flag.Args()) == 0 {
		resp, err = client.Send(*method)
	} else {
		params := make([]interface{}, 0, len(flag.Args()))
		for _, arg := range flag.Args() {
			params = append(params, arg)
		}
		resp, err = client.Send(*method, params)
	}
	if err != nil {
		fmt.Printf("\tError: XML-RPC call error: %s", err.Error())
		os.Exit(2)
	}
	if len(resp) == 0 {
		fmt.Println("OK: <empty>")
	} else {
		for _, item := range resp {
			fmt.Println(item)
		}
	}
}
