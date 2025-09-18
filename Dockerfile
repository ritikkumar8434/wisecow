FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/games:${PATH}"


# Install required packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    fortune-mod fortunes cowsay netcat-openbsd bash curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app
COPY App/wisecow.sh /app/wisecow.sh

# Fix line endings and permissions
RUN sed -i 's/\r$//' /app/wisecow.sh && chmod +x /app/wisecow.sh

# Create non-root user and grant ownership of /app

EXPOSE 4499
ENTRYPOINT ["/app/wisecow.sh"]
