# Create a Multi-Node Couchbase Deployment Locally in Three Easy Steps With GitOps

This repository is to support the Couchbase CONNECT 2021 talk: "Create a Multi-Node Couchbase Deployment Locally in Three Easy Steps With GitOps"

It includes all the examples of how to use Kubernetes-in-docker (KIND), Helm, the Couchbase Operator and the Couchbase SDK to spin up a local development cluster with a working example.

# Abstract

Wondering where to start with Couchbase development on Kubernetes? The days of using heavy infrastructure for development are gone.

This will show you how to quickly spin up a simple cluster locally using Kubernetes in Docker (KIND). You’ll see how to deploy the Couchbase Autonomous Operator using Helm to fully provision a working multi-node Couchbase cluster and then integrate this with an SDK, all in your local development environment.

This is just the beginning. You can apply the techniques you learn here to both interactive development and automated CI/CD pipelines.

# Usage

Two simple scripts are provided:
1. Create the complete Kubernetes cluster with Couchbase Server pods deployed using [create-cluster.sh](./create-cluster.sh).
2. Deploy a test pod with your application on it using [create-dev.sh](./create-dev.sh).

## Couchbase Operator deployment with Helm and KIND

The cluster creation script basically performs the following steps:
1. `kind create cluster` - this spins up a Kubernetes cluster locally using KIND.
2. `helm install couchbase couchbase/operator` - this deploys the latest operator and a default configuration for Couchbase using the helm chart.

The script adds some extra helpers and configuration:
* Multi-node KIND cluster
* Specify the Couchbase Server image version to use
* Pre-load the Couchbase Server images
* Ensure we have the helm chart repository installed
* Wait for it all to complete

## Couchbase SDK example

TODO