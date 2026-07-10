#!/bin/bash

set -euo pipefail

########################################################
# Install Himmelblau repository and packages
# Reference: st-agent-linux/command_service/st_command/st_login/azure.go
########################################################

HIMMELBLAU_REPO_KEY_URL="https://packages.himmelblau-idm.org/himmelblau.asc"

FEDORA_VERSION=$(rpm -E %fedora)
case "${FEDORA_VERSION}" in
    42)
        REPO_URL="https://packages.himmelblau-idm.org/nightly/latest/rpm/fedora42/"
        ;;
    43)
        REPO_URL="https://packages.himmelblau-idm.org/nightly/latest/rpm/fedora43/"
        ;;
    44)
        REPO_URL="https://packages.himmelblau-idm.org/nightly/latest/rpm/fedora44/"
        ;;
    *)
        echo "Error: Unsupported Fedora version: ${FEDORA_VERSION}"
        exit 1
        ;;
esac

echo "Configuring Himmelblau repository for Fedora ${FEDORA_VERSION}"
echo "Repository URL: ${REPO_URL}"

tee /etc/yum.repos.d/himmelblau.repo > /dev/null <<EOF
[himmelblau]
name=Himmelblau Repository
baseurl=${REPO_URL}
enabled=1
gpgcheck=1
gpgkey=${HIMMELBLAU_REPO_KEY_URL}
EOF

dnf5 makecache
dnf5 install -y golang himmelblau nss-himmelblau pam-himmelblau
