# homelab

## Note:
This repo is a work in progress, I am migrating my original 3 node stack (Auriga, Nostromo, and a Linode cloud instance) running a portainer cluster with docker-compose as well as my teleport auth cluster. The end goal is a entirely GitOps managed 4-node cross-site K3s cluster using wireguard for edge cloud node. I will be migrating all manual changes I've done to the teleport cluster over the years to as close to 100% IaC coverage as I can get using the teleport terraform provider.

#### Compute
- *CHEYENNE* - Hetzner Cloud Instance - 2CPU & 4GB RAM
- *AURIGA* - Intel NUC - i5-1135G7 @ 4.20 GHz & 64GB RAM
- *PROMETHEUS* - Optiplex 5040 - i5-6500 @ 3.60 GHz & 32GB RAM
- *SULACO* - Optiplex 5040 - i5-6500 @ 3.60 GHz & 32GB RAM

#### Storage
- *NOSTROMO* - Synology DS920+ - Intel J4125 @ 2.70 GHz & 12GB RAM w/ 10TB RAID

#### Networking
- PC Engines APU4D4 running pfSense

## Infra Wrapper Script

Wraps sops decryption for ease of use.

e.g.
```bash
./infra tf plan
```

## Prerequisites

- If adding a new node on a different network than currently used, ensure you add the network to the allowed networks for fail2ban or your playbook will lock you out.

- Before running `playbooks/site.yml` or `playbooks/k3s-post.yml` playbooks, ensure you run `tsh login --proxy=bolmida.cloud` first or teleport will be unable to make a new join token.

## Secrets Management

```bash
sops secrets.sops.env # edits in place, re-encrypts on save

sops -d secrets.sops.env # decrypt to stdout
```
  
Adding new secrets files

```bash
sops -e -i ./new.sops.yaml # creates a new encrypted files with sops
```

## Ansible

Ansible will need to be ran within `nix develop` to have the necessary pre-reqs.

Example Usage with the infra wrapper:
```bash
nix develop

ansible-galaxy collection install -r ansible/requirements.yml # only need to run when changing ansible/requirements.yml

# confirm the dynamic inventory resolves the expected hosts locally and from cloud
./infra pb --list-hosts playbooks/site.yml

./infra pb playbooks/site.yml # run a playbook
```

Inventory has **two sources**, merged automatically since `ansible.cfg` points `inventory` at the whole `inventory/` directory:

- [`ansible/inventory/hcloud.yml`](ansible/inventory/hcloud.yml) — dynamically queries the Hetzner nodes filtered down to `env=homelab`.

- [`ansible/inventory/local.yml`](ansible/inventory/local.yml) — Static LAN hosts.

Use `--limit` to only run against a subset of nodes:
```bash
./infra pb --limit sulaco,prometheus playbooks/site.yml
```
