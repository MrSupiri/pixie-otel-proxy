install:
	cfssl genkey -initca csr.json | cfssljson -bare ca
	cfssl gencert -ca ca.pem -ca-key ca-key.pem csr.json | cfssljson -bare cert
	kubectl create secret generic otel-collector-secrets --from-file ca.pem --from-file ca-key.pem --from-file cert.pem --from-file cert-key.pem
	kubectl apply -f otel-client.yaml -f otel-server.yaml -f nginx.yaml
	kubectl create secret generic otel-oidc-secrets --from-env-file=.env
clean:
	kubectl delete secret otel-collector-secrets otel-oidc-secrets
	kubectl delete -f otel-client.yaml -f otel-server.yaml -f nginx.yaml
	rm *.pem *.csr