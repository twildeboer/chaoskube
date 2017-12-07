# builder image
FROM golang:1.9-alpine as builder

RUN apk -U add git
WORKDIR /go/src/github.com/twildeboer/chaoskube
COPY . .
RUN go test -v ./...
RUN go build -o /bin/chaoskube -v \
  -ldflags "-X main.version=$(git describe --tags --always --dirty) -w -s"

# final image
FROM alpine:3.6
MAINTAINER Linki <twildeboer@autonomic.ai>

RUN addgroup -S chaoskube && adduser -S -g chaoskube chaoskube
COPY --from=builder /bin/chaoskube /bin/chaoskube

USER chaoskube
ENTRYPOINT ["/bin/chaoskube"]
