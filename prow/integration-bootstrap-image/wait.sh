#!/bin/bash

requiredJobLabelKey=${REQUIRED_JOB_LABEL_KEY:-kyma-component-job}
requiredJobLabelValue=${REQUIRED_JOB_LABEL_VALUE:-true}
maxRetries=${MAX_RETRIES:-100}

eventGUID=$(kubectl get prowjob ${PROW_JOB_ID} -ojson | jq -r '.metadata."labels"."event-GUID"')

echo "GUID: ${eventGUID}"
echo "===="

i=0
until [[ ${i} -eq ${maxRetries} ]]; do
    notSuccessfullJobs=`kubectl get prowjob -l event-GUID=${eventGUID},${requiredJobLabelKey}=${requiredJobLabelValue} --no-headers -o=custom-columns='NAME:metadata.name,STATE:status.state' | grep -v 'success'`

    if [[ -z "$notSuccessfullJobs" ]]
    then
            echo "No more unsuccessfull component jobs found. Exiting..."
            exit 0
    fi

    # Check if there are any failed jobs. If so, quit early
    failedJobs=`echo ${notSuccessfullJobs} | grep 'error\|failure' `

    if [[ -n "$failedJobs" ]];
    then
            echo "Jobs with 'failed' state detected. Exiting with code 1..."
            exit 1
    fi

    printf ">> [${i}/${maxRetries}] Waiting for jobs that should end with success:\n$notSuccessfullJobs\n"
    
    sleep 5
    ((i++))
done

exit 1