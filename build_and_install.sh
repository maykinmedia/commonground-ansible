#!/bin/bash
set -eux pipefail

ansible-galaxy collection build -f 
ansible-galaxy collection install maykinmedia-commonground-1.0.0-alpha.tar.gz -p ./collections -f
