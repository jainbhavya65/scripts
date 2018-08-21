##https://ygrene.tech/removing-a-lot-failed-pods-from-kubernetes-the-easy-way-5cf1d41eab3
#!/bin/bash
errorpod=$(kubectl get pods --field-selector=status.phase=Failed --all-namespaces --show-all  | grep -i -e error -e Evicted | awk '{print $2}'| head -n 1)
namespace=$(kubectl get pods --field-selector=status.phase=Failed --all-namespaces --show-all  | grep -i -e error -e Evicted | awk '{print $1}' | head -n 1)
for x in errorpod
 do
  kubectl delete pod $x -n $namespace
 done
echo "Podname:" $errorpod 
echo "Namespace:" $namespace
