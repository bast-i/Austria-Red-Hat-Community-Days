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

FROM ubi9/ubi:latest as nginx-runner

COPY --from=build /workspace/public/* /usr/share/nginx/html/
RUN dnf -y install nginx &&\
    dnf clean all

CMD ["/bin/nginx"]