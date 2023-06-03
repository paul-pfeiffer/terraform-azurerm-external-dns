# externalDns Azure (private) DNS Zone integration - Service Principal Example
This is an example setup that follows the official documentation at https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/azure-private-dns.md. 
Just execute terraform apply to try it out.

## Setup
1. Creates a Kubernetes Cluster
2. Creates a private dns zone and an nginx deployment.
3. Creates a nginx ingress controller
4. Deploys externalDns via helm on the cluster and configures permission.


## Confirm your setup
Go to the private dns zone (test.com). Check if it contains entries for server.example.com