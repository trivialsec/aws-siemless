#!/usr/bin/env bash

CLEANUP=''
DRYRUN=False
IGNORE=''
TYPE=''
PROFILE="${AWS_PROFILE}"
ACTION='create'
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --no-cleanup)
    CLEANUP=false
    shift # past argument
    ;;
    --dry-run)
    DRYRUN=True
    shift # past argument
    ;;
    -p|--aws-profile)
    PROFILE="$2"
    shift # past argument
    shift # past value
    ;;
    -t|--type)
    TYPE="$2"
    shift # past argument
    shift # past value
    ;;
    -e|--exec)
    PLAYBOOK="$2"
    shift # past argument
    shift # past value
    ;;
    -a|--action)
    ACTION="$2"
    shift # past argument
    shift # past value
    ;;
    -i|--ignore)
    IGNORE="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ ! -z "${PROFILE}" ]; then
    export AWS_ACCESS_KEY_ID=$(aws --profile ${PROFILE} configure get aws_access_key_id)
    export AWS_SECRET_ACCESS_KEY=$(aws --profile ${PROFILE} configure get aws_secret_access_key)
fi

WORKDIR=$(pwd)
mkdir -p build
RET=0

if [[ -f "playbooks/${TYPE}/${PLAYBOOK}.yaml" ]]; then
    ansible-playbook \
        --extra-vars=@vars/${TYPE}/${PLAYBOOK}.yaml \
        --extra-vars=playbook=${PLAYBOOK} \
        --extra-vars=type=${TYPE} \
        --extra-vars=action=${ACTION} \
        --extra-vars=dryrun=${DRYRUN} \
        ${POSITIONAL} \
        playbooks/${TYPE}/${PLAYBOOK}.yaml
    RET=$?
else
    cd playbooks/${TYPE}/${PLAYBOOK}

    find * -prune -type f | while IFS= read -r f; do
        cd ${WORKDIR}
        if [[ $RET == 0 ]] && [[ $f != ${IGNORE} ]]; then
            ansible-playbook \
                --extra-vars=@vars/${PLAYBOOK}/$f \
                --extra-vars=playbook_file=$f \
                --extra-vars=playbook=${PLAYBOOK} \
                --extra-vars=type=${TYPE} \
                --extra-vars=action=${ACTION} \
                --extra-vars=dryrun=${DRYRUN} \
                ${POSITIONAL} \
                playbooks/${PLAYBOOK}/$f
            RET=$?
        fi
    done
fi


if [[ -z "${CLEANUP}" ]]; then
    rm -rf build
fi
