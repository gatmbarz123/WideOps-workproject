#!/bin/bash

kubectl apply -f wordpress-secrets.yml
kubectl apply -f ingress.yml
kubectl apply -f horizontal.yml
kubectl apply -f storage-class.yml
kubectl apply -f wordpress-pvc.yml
kubectl apply -f wordpress.yml

sleep 2 
echo "Done.."