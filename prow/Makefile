check-config:
	go run ${GOPATH}/src/k8s.io/test-infra/prow/cmd/checkconfig/main.go --plugin-config=plugins.yaml --config-path=config.yaml

update-plugins: check-config
	kubectl create configmap plugins --from-file=plugins.yaml=plugins.yaml --dry-run -o yaml | kubectl replace configmap plugins -f -

update-config: check-config
	kubectl create configmap config --from-file=config.yaml=config.yaml --dry-run -o yaml | kubectl replace configmap config -f -
