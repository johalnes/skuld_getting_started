# Use Caddy 2 official image as the base
FROM caddy:2 as base

# Copy the Caddyfile into the container
COPY ./Caddyfile /etc/caddy/Caddyfile

# Expose ports 80 and 443 for HTTP and HTTPS traffic
EXPOSE 80 443

# Run Caddy with no arguments.
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
