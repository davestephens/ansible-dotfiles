# Ansible Playbook - Ubuntu Dev Desktop Setup

This is an Ansible version of my [dotfiles](https://github.com/davestephens/dotfiles) repo. Does exactly the same thing, just with a lot less clunk and complication. 

Sets up and configures all of the software I use for development on an Ubuntu desktop - currently targets Ubuntu 18.04. 

## What It Does
- Installs packages
- Set up my dotfiles
  - Super-custom git config
  - Sexy bash prompt
  - Lots of useful shortcuts
- Sets up vim, vim-plug and plugins
- Sets up rvm and installs Ruby
- Installs proper fonts


## What It'll Do Soon
- Configure Visual Studio Code (not just install it)
- Set up pyenv and pythons
- Set up nvm and nodes
- Set up my keys
- Other stuff I can't think of right now

## TODO
- Tidy the vim config
- Switch to Docker repos once they exist for Bionic

## Quick Installation
1. Install Ansible and git: `sudo apt-get install ansible git`
2. Clone the playbook: `git clone https://github.com/davestephens/ansible-playbook-ubuntu-dev-desktop.git && cd ansible-playbook-ubuntu-dev-desktop`
3. Run it: `ansible-playbook -i inventory desktop.yml -b -K`

## Testing 
Requires Docker:

```
./tests/test.sh
```