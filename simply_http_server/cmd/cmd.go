package cmd

import (
	"fmt"
	"simply_http_server/config"
	"simply_http_server/httpserver"

	"github.com/spf13/cobra"
)

// var log = logrus.New()

var rootCmd = &cobra.Command{
	Use:   "simply-server",
	Short: "simply go server",
	Run: func(cmd *cobra.Command, args []string) {
	},
}

var runCmd = &cobra.Command{
	Use:   "run",
	Short: "Command for start running http server",
	RunE: func(cmd *cobra.Command, args []string) error {
		path, err := cmd.Flags().GetString("conf")
		if err != nil {
			return err
		}
		cfg := config.NewConfig()
		err = cfg.InitConfig(path)
		if err != nil {
			return err
		}
		err = httpserver.Start(cfg)
		if err != nil {
			return err
		}
		return nil
	},
}

func Init() {

	rootCmd.AddCommand(runCmd)

	// Инициализация флагов для команды run
	runCmd.Flags().String("conf", "config.json", "path to configuration file")

	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
	}
}
