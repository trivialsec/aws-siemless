#!/usr/bin/env bash

CLEANUP=''
IGNORE=''
ACTION='create'
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --no-cleanup)
    CLEANUP=false
    shift # past argument
    ;;
    -p|--aws-profile)
    PROFILE="$2"
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

export AWS_PROFILE=${PROFILE}
export AWS_ACCESS_KEY_ID=$(aws --profile ${AWS_PROFILE} configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws --profile ${AWS_PROFILE} configure get aws_secret_access_key)

WORKDIR=$(pwd)
mkdir -p build
cd playbooks/${PLAYBOOK}
RET=0
find * -prune -type f | while IFS= read -r f; do
    cd ${WORKDIR}
    if [[ $RET == 0 ]] && [[ $f != ${IGNORE} ]]; then
        ansible-playbook \
            --extra-vars=@vars/${PLAYBOOK}/$f \
            --extra-vars=playbook_file=$f \
            --extra-vars=playbook=${PLAYBOOK} \
            --extra-vars=action=${ACTION} \
            ${POSITIONAL} \
            playbooks/${PLAYBOOK}/$f
        RET=$?
    fi
done

if [[ -z "${CLEANUP}" ]]; then
    rm -rf build
fi
