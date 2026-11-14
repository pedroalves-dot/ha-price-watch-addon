ARG BUILD_FROM
FROM $BUILD_FROM

# What GitHub's runner (.NET) and the price check need. Node itself is fetched by the workflow (actions/setup-node).
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl jq git tar \
      libicu72 libkrb5-3 zlib1g libssl3 liblttng-ust1 \
 && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
