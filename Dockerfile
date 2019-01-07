############################
# build executable binary
############################
FROM golang:alpine AS builder

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

COPY . $GOPATH/src/mypackage/myapp/

WORKDIR $GOPATH/src/mypackage/myapp/

# Fetch dependencies.
# Using go get.
RUN go get -d -v

# Build the binary.
RUN go build -o /go/bin/minica

############################
# build openssl image
############################
FROM alpine AS openssl

# install openssl
RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*

# Copy our static executable.
COPY --from=builder /go/bin/minica /go/bin/minica

# Run the hello binary.
ENTRYPOINT ["/go/bin/minica"]
