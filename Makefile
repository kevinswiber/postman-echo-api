postman:
	openapi2postmanv2 -s ./openapi/postman-echo-oas-v1.0.0.yaml -o ./openapi/postman-echo-postman-v1.0.0.json

.PHONY: postman
