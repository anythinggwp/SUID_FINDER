package cmd

import (
	"fmt"
	"simply_http_server/httpserver"

	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

var log logrus.Logger

var rootCmd = &cobra.Command{
	Use:   "simply-server",
	Short: "simply go server",
	Run: func(cmd *cobra.Command, args []string) {
	},
}

var runCmd = &cobra.Command{
	Use:   "run",
	Short: "",
	RunE: func(cmd *cobra.Command, args []string) error {
		addr, err := cmd.Flags().GetString("addres")
		if err != nil {
			return err
		}
		port, err := cmd.Flags().GetString("port")
		if err != nil {
			return err
		}
		httpserver.Start(addr, port)
		return nil
	},
}

func Init() {
	rootCmd.AddCommand(runCmd)

	// Инициализация флагов для команды run

	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
	}
}
