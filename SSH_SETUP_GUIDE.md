# SSH Setup Guide for the Jumpbox

This guide captures the SSH setup used for the jumpbox at `20.118.171.12`.

## Problem

Connecting with the default SSH key produced:

```text
debian@20.118.171.12: Permission denied (publickey).
```

The cause was that SSH was offering `~/.ssh/id_rsa` by default, while this jumpbox was configured to accept `~/.ssh/id_rsa_azure`.

## Working Login Command

For a one-off connection, this works:

```bash
ssh -i ~/.ssh/id_rsa_azure debian@20.118.171.12
```

This environment uses the `debian` account, not `root`. After logging in, use:

```bash
sudo -i
```

## Optional: Load the Key into ssh-agent

If you want SSH to use the key from your current login session without typing `-i` each time:

```bash
ssh-add ~/.ssh/id_rsa_azure
ssh debian@20.118.171.12
```

Notes:

* `ssh-add` adds the key to the running `ssh-agent`.
* It usually remains available across new terminal tabs in the same login session.
* You typically need to run it again after a reboot, logout, or when starting a fresh agent.

## Make the Azure Key the Default for This Jumpbox

To make plain `ssh 20.118.171.12` work without `-i` or `ssh-add`, create `~/.ssh/config` with:

```sshconfig
Host 20.118.171.12
  User debian
  IdentityFile ~/.ssh/id_rsa_azure
  IdentitiesOnly yes
```

Then set the correct permissions:

```bash
chmod 600 ~/.ssh/config
```

`IdentitiesOnly yes` is important because it prevents SSH from trying `~/.ssh/id_rsa` first.

## Result

With that config in place, this works:

```bash
ssh 20.118.171.12
```

## If the Jumpbox IP Changes

Update the `Host` entry in `~/.ssh/config`, or replace it with a hostname if you assign one later.
