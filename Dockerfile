FROM golang:alpine

RUN apk --no-cache add bash git make perl yarn && \
    git clone --depth=1 https://github.com/minio/minio

COPY variables.less /go/minio/browser/app/less/inc/variables.less

RUN go get github.com/jteeuwen/go-bindata/... && \
    go get github.com/elazarl/go-bindata-assetfs/... && cd minio/browser && \
    yarn && yarn release && cd .. && make

FROM mfrancis95/minio-s3-gateway

COPY --from=0 /go/minio/minio /usr/bin/minio