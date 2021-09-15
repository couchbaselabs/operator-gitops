#!/bin/bash
# Copyright 2021 Couchbase, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file  except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the  License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Simple script to provision a Kubernetes cluster using KIND: https://kind.sigs.k8s.io/
# It then spins up a Couchbase Server cluster on it using Helm: https://helm.sh/
# To use, need Docker (or a container runtime) installed plus kubectl, KIND & Helm.
set -eu

# In case you want a different name
CLUSTER_NAME=${CLUSTER_NAME:-couchbase-gitops}
# The server container image to use
SERVER_IMAGE=${SERVER_IMAGE:-couchbase/server:7.0.1}
SERVER_COUNT=${SERVER_COUNT:-1}

# Delete the old cluster (if it exists)
kind delete cluster --name="${CLUSTER_NAME}"

# Create KIND cluster with 1 worker node
# Mostly just an example to show you how to do it
kind create cluster --name="${CLUSTER_NAME}" --config - <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
EOF

# Speed up deployment by pre-loading the server image
docker pull "${SERVER_IMAGE}"
kind load docker-image "${SERVER_IMAGE}" --name="${CLUSTER_NAME}"

# Add Couchbase via helm chart: note with/out slash is considered different so we just try both
helm repo add couchbase https://couchbase-partners.github.io/helm-charts/ || helm repo add couchbase https://couchbase-partners.github.io/helm-charts
# Ensure we update the repo (may have added it years ago!)
helm repo update
# Deploy the cluster with all defaults except the image used and the number of pods.
# This will create a three pod Couchbase server cluster with all services on each pod.
# Always installs the latest version of the Helm chart (which is usually fine for dev), can be pinned with --version X
helm upgrade --install couchbase couchbase/couchbase-operator --set cluster.image="${SERVER_IMAGE}",cluster.servers.default.size="${SERVER_COUNT}"
# To tweak the helm deployment there are a lots of options.
# All the configuration values are here: https://github.com/couchbase-partners/helm-charts/blob/master/charts/couchbase-operator/values.yaml
# You may not want to deploy a Couchbase Cluster at all, e.g. if you only want to deploy the DAC and operator so
# you can later add your own custom YAML for the CouchbaseCluster CRD then use the following:
# helm ... --set install.couchbaseCluster=false
# For more details refer to the official documentation: https://docs.couchbase.com/operator/current/helm-setup-guide.html

# Wait for deployment to complete, the --wait flag does not work for this.
echo "Waiting for CB to start up..."
# The operator uses readiness gates to hold the containers until the cluster is actually ready to be used
until [[ $(kubectl get pods --field-selector=status.phase=Running --selector='app=couchbase' --no-headers 2>/dev/null |wc -l) -eq $SERVER_COUNT ]]; do
    echo -n '.'
    sleep 2
done
echo "CB configured and ready to go"

# Couchbase cluster is ready to go, not just started but configured.