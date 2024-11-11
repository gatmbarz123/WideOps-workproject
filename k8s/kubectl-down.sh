#!/bin/bash

kubectl delete -f wordpress-secrets.yml
kubectl delete -f ingress.yml
kubectl delete -f horizontal.yml
kubectl delete -f storage-class.yml
kubectl delete -f wordpress-pvc.yml
kubectl delete -f wordpress.yml

sleep 2 
echo "Done.."
