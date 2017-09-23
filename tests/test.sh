#!/bin/bash
#
# Ansible playbook tester.
# Based on geerlingguy's Ansible role tester.
#
# Usage: [OPTIONS] .tests/test.sh
#   - distro: a supported Docker distro version (default = "ubuntu1604")
#   - playbook: a playbook in the tests directory (default = "test.yml")
#   - cleanup: whether to remove the Docker container (default = true)
#   - container_id: the --name to set for the container (default = timestamp)
#   - test_idempotence: whether to test playbook's idempotence (default = true)
#
# License: MIT

# Exit on any individual command failure.
set -e

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

timestamp=$(date +%s)

# Allow environment variables to override defaults.
distro=${distro:-"ubuntu1604"}
playbook=${playbook:-"desktop.yml"}
cleanup=${cleanup:-"true"}
container_id=${container_id:-$timestamp}
test_idempotence=${test_idempotence:-"true"}

## Set up vars for Docker setup.
case $distro in
  centos7)
    init="/usr/lib/systemd/systemd"
    opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
  ;;
  ubuntu1604)
    init="/lib/systemd/systemd"
    opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
  ;;
  debian9)
    init="/lib/systemd/systemd"
    opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
  ;;
  fedora24)
    init="/usr/lib/systemd/systemd"
    opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
  ;;
esac

# Run the container using the supplied OS.
printf ${green}"Starting Docker container: geerlingguy/docker-$distro-ansible."${neutral}"\n"
docker pull geerlingguy/docker-$distro-ansible:latest
docker run --detach --volume="$PWD":/etc/ansible/playbooks/playbook_under_test:rw --name $container_id $opts geerlingguy/docker-$distro-ansible:latest $init

printf "\n"

# Install requirements if `requirements.yml` is present.
if [ -f "$PWD/requirements.yml" ]; then
  printf ${green}"Requirements file detected; installing dependencies."${neutral}"\n"
  docker exec --tty $container_id env TERM=xterm ansible-galaxy install -r /etc/ansible/playbooks/playbook_under_test/requirements.yml
fi

printf "\n"

# Output Ansible version
printf ${green}"Checking Ansible version."${neutral}"\n"
docker exec --tty $container_id env TERM=xterm ansible-playbook --version

printf "\n"

# Test Ansible syntax.
printf ${green}"Checking Ansible playbook syntax."${neutral}"\n"
docker exec --tty $container_id env TERM=xterm ansible-playbook /etc/ansible/playbooks/playbook_under_test/$playbook --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${green}"Running command: docker exec $container_id env TERM=xterm ansible-playbook /etc/ansible/playbooks/playbook_under_test/$playbook"${neutral}"\n"
docker exec $container_id env TERM=xterm env ANSIBLE_FORCE_COLOR=1 ansible-playbook /etc/ansible/playbooks/playbook_under_test/$playbook

if [ "$test_idempotence" = true ]; then
  # Run Ansible playbook again (idempotence test).
  printf ${green}"Running playbook again: idempotence test"${neutral}
  idempotence=$(mktemp)
  docker exec $container_id ansible-playbook /etc/ansible/playbooks/playbook_under_test/$playbook | tee -a $idempotence
  tail $idempotence \
    | grep -q 'changed=0.*failed=0' \
    && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
    || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)
fi

# Remove the Docker container (if configured).
if [ "$cleanup" = true ]; then
  printf "Removing Docker container...\n"
  docker rm -f $container_id
fi
