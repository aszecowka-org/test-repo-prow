FROM eu.gcr.io/kyma-project/test-infra/alpine-kubectl:v20190325-ff66a3a

RUN apk update &&\
	apk add jq

WORKDIR /

RUN mkdir waiter
COPY ./wait.sh /waiter/wait.sh
