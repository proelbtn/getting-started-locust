#!/usr/bin/env python3

import sys
import json


output = json.loads(sys.stdin.read())

print("[master]")
master = output["master"]["value"]
print("%s ansible_host=%s instance_zone=%s instance_network_ip=%s ansible_ssh_private_key_file=~/.ssh/google_compute_engine" % (master["name"], master["nat_ip"], master["zone"], master["network_ip"]))
print()
print("[slaves]")
for slave in output["slaves"]["value"]:
    print("%s ansible_host=%s instance_zone=%s instance_network_ip=%s locust_master_ip=%s ansible_ssh_private_key_file=~/.ssh/google_compute_engine" % (slave["name"], slave["nat_ip"], slave["zone"], slave["network_ip"], master["network_ip"]))

