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

# Simple script to spin up a local deployment containing your application.
set -eu

# The image we want to run up
DEV_IMAGE=${DEV_IMAGE:-tallbigsam/couchbase-nodejs-sdk:latest}
# The Kubernetes namespace to deploy into
NAMESPACE=${NAMESPACE:-default}

# Create a deployment for our dev container
cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: couchbase-sdk-dev
  namespace: $NAMESPACE
spec:
  selector:
    matchLabels:
      couchSdk: "dev"
  template:
    metadata:
      labels:
        couchSdk: "dev"
        environment: "dev"
    spec:
      containers:
      - name: couchbase-sdk-dev
        image: $DEV_IMAGE
EOF

echo "Waiting for Dev Deployment to start up..."
until kubectl rollout status deployment/couchbase-sdk-dev; do
    echo -n '.'
    sleep 2
done
echo "Dev Deployment configured and ready to go"

#get the name of the development pod
DEV_POD=$(kubectl get pods deployment/couchbase-sdk-dev --output=jsonpath='{.items[*].metadata.name}')
echo "Dev Pod Name: $DEV_POD"
