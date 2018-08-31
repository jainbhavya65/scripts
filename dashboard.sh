#!/bin/bash
#kubectl delete clusterrolebinding cluster-admin-binding
#kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
#kubectl config set-credentials cluster-admin --token=bearer_token
gnome-terminal -x bash -c "kubectl proxy"
firefox http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/ 
