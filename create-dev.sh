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

# Simple script to spin up a local deployment running the test application.
set -eu

CLUSTER_NAME=${CLUSTER_NAME:-couchbase-gitops}
# The image we want to run up.
DEV_IMAGE=${DEV_IMAGE:-couchbase-nodejs-sdk:v1}
# The Kubernetes namespace to deploy into (make sure it exists).
NAMESPACE=${NAMESPACE:-default}
AUTHENTICATION_SECRET=${AUTHENTICATION_SECRET:-auth-couchbase-couchbase-cluster}
CB_SERVICE=${CB_SERVICE:-couchbase-couchbase-cluster}

docker build -t "${DEV_IMAGE}" .
kind load docker-image "${DEV_IMAGE}" --name="${CLUSTER_NAME}"

# Create a deployment for our dev container image.
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
      - name: dev-container
        image: $DEV_IMAGE
        imagePullPolicy: Never
        env:
          - name: CB_HOST
            value: $CB_SERVICE
          # https://kubernetes.io/docs/concepts/configuration/secret/#environment-variables-are-not-updated-after-a-secret-update
          - name: CB_USER
            valueFrom:
              secretKeyRef:
                name: $AUTHENTICATION_SECRET
                key: username
          - name: CB_PSWD
            valueFrom:
              secretKeyRef:
                name: $AUTHENTICATION_SECRET
                key: password
EOF
# Note that if you do not change anything then it will stay deployed from a previous run.

echo "Waiting for Dev Deployment to start up..."
until kubectl rollout status deployment/couchbase-sdk-dev; do
    echo -n '.'
    sleep 2
done
echo "Dev Deployment configured and ready to go"

# Output the name of the development pod
DEV_POD=$(kubectl get pods -l couchSdk=dev --output=jsonpath='{.items[*].metadata.name}')
echo "Dev Pod Name: $DEV_POD"
