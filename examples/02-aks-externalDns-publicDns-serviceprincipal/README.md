# externalDns Azure (public) DNS Zone integration - Service Principal Example
This is an example setup that follows the official documentation at https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/azure.md. 
Just execute terraform apply to try it out.

## Setup
1. Creates a Kubernetes Cluster
2. Specifiy an existing public dns zone in the settings.
3. Creates a nginx and nginx ingress controller
4. Deploys externalDns via helm on the cluster and configures permission.


## Confirm your setup
Go to the public dns zone. Check if it contains entries for server.example.com