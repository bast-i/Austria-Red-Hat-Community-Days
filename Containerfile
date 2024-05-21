ARG workspace="/workspace"

FROM ubi9/ubi:latest

ADD . /workspace

RUN dnf -y install jq &&\
    curl -sL $(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r '\
            . as $artifacts | .tag_name | ltrimstr("v") as $version | \
            $artifacts | .assets | .[] | [.name, .browser_download_url] | \
            if (.[0] | contains($version) and contains("extended") and contains("Linux-64bit") and contains(".tar.gz")) \
            then .[1] \
            else empty \
            end') | tar -C /usr/local/bin -xzf - hugo && \
    ls -la $workspace
    hugo version &&\
    hugo -c $workspace &&\
    ls -la $workspace