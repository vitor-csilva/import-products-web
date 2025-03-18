# Installations

Follow the steps below to install the necessary tools.

The installations are based on the Linux Operating System.

## NPM

To install the project frontend, you will need NPM to install JavaScript dependencies.

Installation instructions: <https://docs.npmjs.com/downloading-and-installing-node-js-and-npm>

## Python

To install the project backend, you need to have Python installed. The required version must be 3.x or higher.

Installation instructions: <https://python.org.br/instalacao-linux>

### Virtual Env

To create a new virtual environment, run the command: `python3 -m venv virtual_env_name`.

More instructions about the required virtual environment can be found in the START.MD file, under the Backend section.

Virtual environment documentation: <https://docs.python.org/3/library/venv.html>

## Docker

To work with containers, you need to install Docker.

Installation instructions: <https://docs.docker.com/engine/install>

### Docker Hub

To push images to Docker Hub (a public container registry), you need to create an account on Docker Hub.

Link: <https://hub.docker.com>

After creating an account, you can run the command: `docker login` and enter the username and password created on the platform to authenticate and push images.

## Docker Compose

To orchestrate containers in the development environment, you need to install Docker Compose.

Installation instructions: <https://docs.docker.com/compose/install>

## Kubernetes

To work with Kubernetes, a simple way to do so is by using the Kind tool.

Installation instructions: <https://kind.sigs.k8s.io/docs/user/quick-start/#installation>

### Creating a new cluster

To create a Kubernetes cluster: `kind create cluster --name k8s-import-products`

### Kubectl

To access commands that manipulate Kubernetes objects, install Kubectl.

Installation instructions: <https://kubernetes.io/docs/tasks/tools/install-kubectl-linux>

Example command: `kubectl get nodes`

