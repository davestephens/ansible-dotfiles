# Ansible Ubuntu Dev Desktop Playbook

Ansible version of my [dotfiles](https://github.com/davestephens/dotfiles) repo. Aims to do exactly the same thing, 
just with a lot less clunk and complication. 

Sets up and configures all of the software I use for development on an Ubuntu desktop.

## What It Does
- Installs packages

## What It'll Do Soon
- Set up my dotfiles
- Configure Visual Studio Code
- Set up rbenv and rubies
- Set up pyenv and pythons
- Set up nvm and nodes
- Set up my keys
- Other stuff I can't think of right now

## Quick Installation
1. Install Ansible and git: `sudo apt-get install ansible git`
2. Clone the playbook: `git clone https://github.com/davestephens/ansible-ubuntu-dev-playbook.git && cd ansible-ubuntu-dev-playbook`
3. Run it: `ansible-playbook -i inventory desktop.yml -b -K`

## Testing 
Requires Docker:

```
./tests/test.sh
```