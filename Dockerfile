FROM rust:1.75-bookworm AS builder
RUN apt-get update && apt-get install -y git pkg-config libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /src
RUN git clone https://github.com/cloudflare/pingora.git .
RUN cargo build --release

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates libssl3 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /src/target/release/pingora /app/pingora
EXPOSE 80
CMD ["/app/pingora"]
