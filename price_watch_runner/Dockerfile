ARG BUILD_FROM
FROM $BUILD_FROM

# Small on purpose: Node + a few tools (about 60 MB), so it runs happily next to Home Assistant on a Pi 3.
RUN apk add --no-cache nodejs jq curl tar tzdata

COPY run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
