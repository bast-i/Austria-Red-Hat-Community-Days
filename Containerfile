FROM ubi9/ubi:latest as build

ADD . /workspace

RUN dnf -y install jq &&\
    curl -sL $(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r '\
            . as $artifacts | .tag_name | ltrimstr("v") as $version | \
            $artifacts | .assets | .[] | [.name, .browser_download_url] | \
            if (.[0] | contains($version) and contains("extended") and contains("Linux-64bit") and contains(".tar.gz")) \
            then .[1] \
            else empty \
            end') | tar -C /usr/local/bin -xzf - hugo && \
    cd /workspace &&\
    hugo version &&\
    hugo &&\
    ls -la

FROM registry.access.redhat.com/ubi9/nginx-124

COPY --from=build /workspace/public/* .
# Run script uses standard ways to run the application
CMD nginx -g "daemon off;"