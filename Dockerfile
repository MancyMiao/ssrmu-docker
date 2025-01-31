FROM alpine:latest

ENV NODE_ID=0                            \
    DNS_1=1.0.0.1                        \
    DNS_2=8.8.8.8                        \
    SPEEDTEST=0                          \
    CLOUDSAFE=0                          \
    AUTOEXEC=0                           \
    ANTISSATTACK=0                       \
    OFFSET=0                             \
    MU_SUFFIX=download.windowsupdate.com \
    MU_REGEX=%5m%id.%suffix              \
    API_INTERFACE=modwebapi              \
    WEBAPI_URL=https://zhaoj.in          \
    WEBAPI_TOKEN=glzjin                  \
    MYSQL_HOST=127.0.0.1                 \
    MYSQL_PORT=3306                      \
    MYSQL_USER=ss                        \
    MYSQL_PASS=ss                        \
    MYSQL_DB=shadowsocks                 \
    REDIRECT=github.com                  \
    FAST_OPEN=false

RUN  apk update && apk add tzdata &&             \
     ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \ 
     echo "Asia/Shanghai" > /etc/timezone &&     \
     apk --no-cache add                          \
                        curl                     \
                        libintl                  \
                        python3-dev              \
                        py3-gevent               \
                        libsodium-dev            \
                        openssl-dev              \
                        udns-dev                 \
                        mbedtls-dev              \
                        pcre-dev                 \
                        libev-dev                \
                        libtool                  \
                        libffi-dev            && \
     apk --no-cache add --virtual .build-deps    \
                        git                      \
                        tar                      \
                        make                     \
                        gettext                  \
                        py3-pip                  \
                        autoconf                 \
                        automake                 \
                        build-base               \
                        linux-headers         && \
     ln -s /usr/bin/python3 /usr/bin/python   && \
     ln -s /usr/bin/pip3    /usr/bin/pip      && \
     git clone -b manyuser https://github.com/micll/shadowsocks-mod.git "/root/shadowsocks" --depth 1 && \
     pip install --upgrade pip                && \
     cd  /root/shadowsocks                    && \
     pip install -r requirements.txt          && \
     rm -rf ~/.cache && touch /etc/hosts.deny && \
     apk del --purge .build-deps

WORKDIR /root/shadowsocks

CMD cp apiconfig.py userapiconfig.py &&                                            cp   config.json  user-config.json && \
    sed -i "s|NODE_ID = 0|NODE_ID = ${NODE_ID}|"                                   /root/shadowsocks/userapiconfig.py && \
    sed -i "s|SPEEDTEST = 0|SPEEDTEST = ${SPEEDTEST}|"                             /root/shadowsocks/userapiconfig.py && \
    sed -i "s|CLOUDSAFE = 0|CLOUDSAFE = ${CLOUDSAFE}|"                             /root/shadowsocks/userapiconfig.py && \
    sed -i "s|AUTOEXEC = 0|AUTOEXEC = ${AUTOEXEC}|"                                /root/shadowsocks/userapiconfig.py && \
    sed -i "s|ANTISSATTACK = 0|ANTISSATTACK = ${ANTISSATTACK}|"                    /root/shadowsocks/userapiconfig.py && \
    sed -i "s|OFFSET = 0|OFFSET = ${OFFSET}|"                                      /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MU_SUFFIX = \"zhaoj.in\"|MU_SUFFIX = \"${MU_SUFFIX}\"|"              /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MU_REGEX = \"%5m%id.%suffix\"|MU_REGEX = \"${MU_REGEX}\"|"           /root/shadowsocks/userapiconfig.py && \
    sed -i "s|API_INTERFACE = \"modwebapi\"|API_INTERFACE = \"${API_INTERFACE}\"|" /root/shadowsocks/userapiconfig.py && \
    sed -i "s|WEBAPI_URL = \"https://zhaoj.in\"|WEBAPI_URL = \"${WEBAPI_URL}\"|"   /root/shadowsocks/userapiconfig.py && \
    sed -i "s|WEBAPI_TOKEN = \"glzjin\"|WEBAPI_TOKEN = \"${WEBAPI_TOKEN}\"|"       /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_HOST = \"127.0.0.1\"|MYSQL_HOST = \"${MYSQL_HOST}\"|"          /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_PORT = 3306|MYSQL_PORT = ${MYSQL_PORT}|"                       /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_USER = \"ss\"|MYSQL_USER = \"${MYSQL_USER}\"|"                 /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_PASS = \"ss\"|MYSQL_PASS = \"${MYSQL_PASS}\"|"                 /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_DB = \"shadowsocks\"|MYSQL_DB = \"${MYSQL_DB}\"|"              /root/shadowsocks/userapiconfig.py && \
    sed -i "s|\"redirect\": \"\"|\"redirect\": \"${REDIRECT}\"|"                   /root/shadowsocks/user-config.json && \
    sed -i "s|\"fast_open\": true|\"fast_open\": ${FAST_OPEN}|"                   /root/shadowsocks/user-config.json && \
    echo -e "${DNS_1}\n${DNS_2}\n" >                                               /root/shadowsocks/dns.conf         && \
    python /root/shadowsocks/server.py
