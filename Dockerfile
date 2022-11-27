FROM golang:1.19.1-buster as go-target
RUN apt-get update && apt-get install -y build-essential coreutils autogen yasm git cmake make automake autotools-dev wget
ADD . /pdftilecut
WORKDIR /pdftilecut
RUN make
RUN go build
RUN wget https://www.africau.edu/images/default/sample.pdf
RUN wget https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf

FROM golang:1.19.1-buster
COPY --from=go-target /pdftilecut/pdftilecut /
COPY --from=go-target /pdftilecut/*.pdf /testsuite/

ENTRYPOINT []
CMD ["/pdftilecut", "-tile-size", "A4", "-in", "@@", "-out", "/dev/null"]
