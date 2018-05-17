FROM golang:1.10-alpine3.7

RUN apk add -U ca-certificates curl git gcc musl-dev make
RUN curl -fsSL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 \
		&& chmod +x /usr/local/bin/dep

RUN mkdir -p $GOPATH/src/github.com/golang/gddo
WORKDIR $GOPATH/src/github.com/golang/gddo

COPY Gopkg.toml Gopkg.lock ./
RUN dep ensure -vendor-only -v

ADD . ./
RUN CGO_ENABLED=0 go build -ldflags="-s -w -extldflags '-static'" -o /gddo-server ./gddo-server


FROM alpine:3.7
RUN apk add -U --no-cache ca-certificates graphviz
COPY --from=0 /gddo-server /gddo-server
ADD ./gddo-server/assets /assets
WORKDIR /
ENV GITHUB_TOKEN=
EXPOSE 8080
ENTRYPOINT ["/gddo-server"]
