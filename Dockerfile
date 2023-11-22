FROM bash:5.2

LABEL "name"="blackduck report action"
LABEL "maintainer"="Jeroen Knoops <jeroen.knoops@philips.com>"

LABEL "com.github.actions.name"="Black Duck report Github Action"
LABEL "com.github.actions.description"="Creates Black Duck report and downloads it"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="gray-dark"

RUN apk update && apk add \
      jq \
      curl

ENV WORK_DIR=/work
RUN mkdir -p ${WORK_DIR}

COPY get-blackduck-report.sh /

ENTRYPOINT ["/get-blackduck-report.sh"]
