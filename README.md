Build base image

```bash
docker build -t cform docker/base
```

Build cform image whenever deploy.sh changes

```bash
docker build -t cform docker/base
```

Run a playbook (creates a stack by default)

```bash
docker run -it \
    --mount type=bind,src=$(pwd)/src,dst=/ansible \
    --mount type=bind,src=$HOME/.aws,dst=/ansible/.aws,readonly \
    cform -e <playbook>
```

Update a stack

```bash
docker run -it \
    --mount type=bind,src=$(pwd)/src,dst=/ansible \
    --mount type=bind,src=$HOME/.aws,dst=/ansible/.aws,readonly \
    cform -e <playbook> -a update
```

Delete a stack

```bash
docker run -it \
    --mount type=bind,src=$(pwd)/src,dst=/ansible \
    --mount type=bind,src=$HOME/.aws,dst=/ansible/.aws,readonly \
    cform -e <playbook> -a delete
```

Ignore a stack in a playbook group

```bash
docker run -it \
    --mount type=bind,src=$(pwd)/src,dst=/ansible \
    --mount type=bind,src=$HOME/.aws,dst=/ansible/.aws,readonly \
    cform -e <playbook> -a delete -i topic.yaml
```

Add more `ansible-playbook` arguments, such as debugging level

```bash
docker run -it \
    --mount type=bind,src=$(pwd)/src,dst=/ansible \
    --mount type=bind,src=$HOME/.aws,dst=/ansible/.aws,readonly \
    cform -e <playbook> -vvv
```

Define the awscli profile

```bash
docker run -it \
    --mount type=bind,src=$(pwd)/src,dst=/ansible \
    --mount type=bind,src=$HOME/.aws,dst=/ansible/.aws,readonly \
    cform -e <playbook> -p <aws profile>

```

Open a bash shell

```bash
docker run -it --entrypoint bash cform
```
