# Example PEcAn Ansible configuration

This repository showcases the convenience of using Ansible to easily manage multiple PEcAn installations. For more info on Ansible, see their [excellent documentation][ansible].

Ansible can be installed on Ubuntu via `apt` (`ansible` package) and CentOS via `yum` (`epel-release` repository; `ansible` package).

To use this configuration, follow the following steps:

1. Make sure ansible is installed (try running `ansible --version`).
2. Make sure your SSH keys are configured for all of the servers you want to test (here, `pecan1`, `pecan2`, and `test-pecan`.
3. Make sure you can log into each of these servers via SSH (e.g. `ssh <username>@pecan2.bu.edu`). Ansible is great about handling errors on individual nodes, and will tell you exactly which nodes it can and can't connect to, but it's nice to head these problems off in advance if you can.
4. Open the `ansible.cfg` file and change the `remote_user` to your username on the remotes. (If this varies by server, you can set server-specific usernames by adding `ansible_user=USERNAME` (no spaces!) to the relevant line of the `hosts` file. See the [Inventory][inventory] documentation for more details.)
5. Run `ansible -m ping all` to check that Ansible can connect to all of the hosts.
6. Open the `hosts` file and fix the `install_basepath` variable to point to the directory into which you want PEcAn to be downloaded. PEcAn will be cloned into a subdirectory of `install_basepath` called `ansible_pecan.<hostname>` (e.g. `ansible_pecan.pecan2`, `ansible_pecan.test-pecan`). You can also change the `install_prefix` if you want.
7. Run the included playbook with `ansible-playbook get_pecan.yml`. This will clone PEcAn from the `github_user` specified in `hosts` into the directory specified above.
8. For kicks, run the previous command again. Notice that the output should now say that none of the nodes changed. This is because the Ansible `git` module does a `pull` instead of a fresh `clone`, and since there have been no new changes, nothing happens. You can also try manually removing one of the clones and re-running the command -- this will clone only that directory and not change any of the others.

Stay tuned for more updates to this, but it should already be a useful way to quickly update a set of PEcAn installations.

[ansible]: http://docs.ansible.com/ansible/latest/intro.html
[inventory]: http://docs.ansible.com/ansible/latest/intro_inventory.html
