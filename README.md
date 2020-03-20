# go-clever
Example of clever API client generated from spec file

### TL;DR

Run the local mock server:
```
npx prism mock -h 0.0.0.0 -p 4010 ./dist/combined-out.yaml
```

Run the Swagger UI interface:
```
cd dist; python -m SimpleHTTPServer 8000
```
NOTE: The mock server responses are only as good as the examples in the spec file. Edit the `dist/combined-out.yaml` using the [StopLight Desktop app](https://github.com/stoplightio/desktop) or online using https://editor.swagger.io/ or manually with a text editor.

### Background
At Khan Academy, we use the [OpenAPIv2 spec file here](https://github.com/Clever/swagger-api/blob/master/full-v2.yml), convert it to OpenAPI **v3** format, and use [oapi-codegen](https://github.com/deepmap/oapi-codegen) to autogenerate API-contract compliant golang clients for the V2.1 Clever API. The omission of pagination in the specification made this less viable for us, so we updated the spec to match the observed pagination behavior and it is working very well!

We believe that API First (or Document Driven Design) is an engineering and architecture best practice. API First involves establishing an API contract, separate from the code. This allows us to more clearly track the evolution of that API contract, separate from the evolution of the implementation of that contract. API contracts can be specified following the OpenAPI Specification (previously Swagger).

We know that there is a [clever-go](https://github.com/Clever/clever-go) library, but we prefer to track API specification updates both more closely and more proactively. We also inject some fault tolerance by injecting an [http client that will retry with exponential backoff](https://github.com/sethgrid/pester) to provide resilience against temporary network failures and exceeding rate limits.

### OpenAPI Document Driven Process

1. We downloaded the [Clever V2.1 OpenAPIv2 spec file here](https://github.com/Clever/swagger-api/blob/master/full-v2.yml).

2. The Clever spec document is in swagger (OpenAPIv2) format, so we run the `./convert.sh` script which uses `swagger2openapi` to convert it to OpenAPI **v3** (and patch a few minor issues).
  + Other alternatives are to use https://editor.swagger.io/ or `api-spec-converter`, but swagger2openapi is less prone to failures and it's "patch minor issues" feature helps improve specs.
3. Lint the resulting spec file for warnings:
```
npx speccy lint -v ./oas3/full-v2.oas3.yaml
```
4. Run prism Mock server for integration testing
```
npx prism mock -h 0.0.0.0 -p 4010 ./oas3/full-v2.oas3.yaml
```
5. Generate Golang client from spec:
```
go run github.com/deepmap/oapi-codegen/cmd/oapi-codegen --generate types,client --package=clever -o ./clever.gen.go ./oas3/full-v2.oas3.yml
```

[OpenAPI Client and Server Code Generator](https://github.com/deepmap/oapi-codegen) is the most popular Go tool for this purpose, but [most languages have similar support](https://openapi.tools/) and we've adopted it as a best practice to help save on costly API client maintenance and tedious contract testing. 
