# Create a Multi-Node Couchbase Deployment Locally in Three Easy Steps With GitOps

This repository is to support the Couchbase CONNECT 2021 talk: "Create a Multi-Node Couchbase Deployment Locally in Three Easy Steps With GitOps"

It includes all the examples of how to use Kubernetes-in-docker or [KIND](https://kind.sigs.k8s.io/), [Helm](https://helm.sh/), the [Couchbase Autonomous Operator](https://docs.couchbase.com/operator/current/overview.html) (CAO) and the Couchbase SDK to spin up a local development cluster with a working example.

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
The index.js sample file follows similar principles to that in our SDK examples [Couchbase Node SDK - Getting Started](https://docs.couchbase.com/nodejs-sdk/current/hello-world/start-using-sdk.html). Please ensure that you have the Couchbase SDK installed, or utilise the environment built for you with [create-dev.sh](./create-dev.sh). 

The script follows a basic example:
1. Connect to a Couchbase cluster, using specified credentials, and retrieve the default collection
2. Perform an upsert operation on the bucket.
3. Retrieve the document which was upserted and output it to the CLI.

The outcome of running this example script is to give you a starter environment for you to directly test and develop functionality against a real Couchbase environment. 
