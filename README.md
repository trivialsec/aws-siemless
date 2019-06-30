## Build

### Build base image

```bash
docker build -t cform-base docker/base
```

### Build cform image whenever deploy.sh changes

```bash
docker build -t cform docker/cform
```

## Execute a playbook

### Run a playbook (creates a stack by default)

```bash
docker run -it \
    --mount type=bind,src=$(pwd)/src,dst=/ansible \
    --mount type=bind,src=$HOME/.aws,dst=/ansible/.aws,readonly \
    cform -t|--type <env or type> -e|--exec <playbook file or dir>
```

Update a stack with `-a|--action update`

Delete a stack with `-a|--action delete`

You can preserve the build dir and inspect the generated cloudformation templates using `--no-cleanup`

You can prevent calling the AWS API and only generate the cloudformation templates using `--dry-run`

Most of the time you specify the playbook using `--type` and `--exec` but when the dir structure is `<type>/<exec>/<many playbooks>.yaml` you can ignore a single playbook in a subgroup using `-i|--ignore playbook.yaml` and all other playbooks in `<type>/<exec>/` dir will still run.

Add more `ansible-playbook` arguments, such as debugging level with `-v` or `-vvvv` as usual.

Define the awscli profile using `-p|--aws-profile <aws profile>`

Open a bash shell in the container using;

```bash
docker run -it --entrypoint bash cform
```
