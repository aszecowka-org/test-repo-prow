#!/bin/bash

requiredJobLabelKey=${REQUIRED_JOB_LABEL_KEY:-kyma-component-job}
requiredJobLabelValue=${REQUIRED_JOB_LABEL_VALUE:-true}
maxRetries=${MAX_RETRIES:-100}


eventGUID=$(kubectl get prowjob ${PROW_JOB_ID} -ojson | jq -r '.metadata."labels"."event-GUID"')

echo "GUID: ${eventGUID}"
echo "===="



i=0
until [[ ${i} -eq ${maxRetries} ]]; do

    incompletedJobs=`kubectl get prowjob -l event-GUID=${eventGUID} -l ${requiredJobLabelKey}=${requiredJobLabelValue} --no-headers -o=custom-columns="NAME:metadata.name"`

    if [[ -z "$incompletedJobs" ]]
    then
            echo "No more component jobs found. Exiting..."
            exit 0
    fi

    printf ">> [${i}/${maxRetries}] Waiting for jobs:\n$incompletedJobs\n"

    sleep 5

    ((i++))

done

exit 1