FROM golang:alpine

RUN apk --no-cache add bash git make perl yarn && \
    git clone --depth=1 https://github.com/minio/minio

COPY logo.svg /go/minio/browser/app/img/logo.svg
COPY sidebar.less /go/minio/browser/app/less/inc/

RUN sed -i s/002a37/b0197e/ /go/minio/browser/app/less/inc/login.less && \
    sed -i s/00303f/b0197e/ /go/minio/browser/app/less/inc/variables.less && \
    go get github.com/jteeuwen/go-bindata/... && \
    go get github.com/elazarl/go-bindata-assetfs/... && cd minio/browser && \
    yarn && yarn release && cd .. && make

FROM mfrancis95/minio-s3-gateway

COPY --from=0 /go/minio/minio /usr/bin/minio

ENV S3_ENDPOINT https://s3.csh.rit.edu