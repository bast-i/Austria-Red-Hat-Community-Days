FROM ubi9/ubi:latest as build

ADD . /workspace

#RUN dnf -y install jq &&\
#    curl -sL $(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r '\
#            . as $artifacts | .tag_name | ltrimstr("v") as $version | \
#            $artifacts | .assets | .[] | [.name, .browser_download_url] | \
#            if (.[0] | contains($version) and contains("extended") and contains("Linux-64bit") and contains(".tar.gz")) \
#            then .[1] \
#            else empty \
#            end') | tar -C /usr/local/bin -xzf - hugo && \
RUN curl -sL https://github.com/gohugoio/hugo/releases/download/v0.142.0/hugo_0.142.0_Linux-64bit.tar.gz | tar -C /usr/local/bin -xzf - hugo &&\
    cd /workspace &&\
    date &&\
    hugo &&\
    ls -laR public

FROM registry.access.redhat.com/ubi9/nginx-124

COPY --from=build /workspace/public/ .

CMD nginx -g "daemon off;"
