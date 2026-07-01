FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    prosody \
    lua-sec \
    lua-socket \
    lua-expat \
    lua-filesystem \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/prosody /var/lib/prosody /var/log/prosody \
    && chown -R prosody:prosody \
       /var/run/prosody /var/lib/prosody \
       /var/log/prosody /etc/prosody

RUN cat > /etc/prosody/prosody.cfg.lua << 'EOF'
admins = { "admin@onyx1.up.railway.app" }

modules_enabled = {
    "roster",
    "saslauth",
    "tls",
    "dialback",
    "disco",
    "posix",
    "private",
    "vcard",
    "http",
    "websocket",
    "carbons",
    "blocklist",
    "ping",
    "register",
}

allow_registration = true
consider_websocket_secure = true
cross_domain_websocket = true
cross_domain_bosh = true

interfaces = { "0.0.0.0" }
http_ports = { 5280 }
http_interfaces = { "0.0.0.0" }
https_ports = {}

VirtualHost "onyx1.up.railway.app"
    http_paths = {
        websocket = "/xmpp-websocket";
    }
EOF

RUN chown prosody:prosody /etc/prosody/prosody.cfg.lua

USER prosody

EXPOSE 5280

CMD ["prosody", "-F"]
