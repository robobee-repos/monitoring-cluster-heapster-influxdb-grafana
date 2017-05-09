heapster-service-yaml(parent, vars) ::= <<
kind: Service
apiVersion: v1
metadata:
  name: heapster
  namespace: kube-system
spec:
  ports:
    - port: 80
      targetPort: 8082
  selector:
    k8s-app: heapster

>>
