package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/ghodss/yaml"
)

func main() {
	var (
		env     string
		showerr bool
	)

	flag.StringVar(&env, "e", "", "Environment")
	flag.BoolVar(&showerr, "s", false, "Do not suppress error output")

	flag.Parse()

	var body []byte
	var err error
	switch flag.Arg(0) {
	case "-":
		body, err = ioutil.ReadAll(os.Stdin)
	case "":
		if showerr {
			fmt.Println("FILENAME needs to be provided")
		}
		os.Exit(1)
	default:
		body, err = ioutil.ReadFile(flag.Arg(0))
	}
	if err != nil {
		if showerr {
			fmt.Printf("Failed to read the file. %v", err)
		}
		os.Exit(1)
	}

	vars := make(map[string]interface{})
	if err := yaml.Unmarshal(body, &vars); err != nil {
		if showerr {
			fmt.Printf("Failed to unmarshal yaml. %v", err)
		}
		os.Exit(1)
	}

	if env == "" {
		printEnv(vars, showerr)
		return
	}
	envvars, ok := vars[env]
	if !ok {
		if showerr {
			fmt.Printf("Environment: %s not found\n", env)
		}
		os.Exit(1)
	}
	printEnv(envvars, showerr)
}

func printEnv(vars interface{}, showerr bool) {
	v, ok := vars.(map[string]interface{})
	if !ok {
		if showerr {
			fmt.Printf("Data type is map[string]string only: %#v", vars)
		}
		os.Exit(1)
	}
	for ek, ev := range v {
		if _, ok := ev.(string); !ok {
			if showerr {
				fmt.Printf("Value is string only: %v", ev)
			}
			os.Exit(1)
		}
		fmt.Printf("export %s=%s\n", ek, ev)
	}
}
