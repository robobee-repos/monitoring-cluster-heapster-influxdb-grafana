grafana-service-yaml(parent, vars) ::= <<
apiVersion: v1
kind: Service
metadata:
  name: monitoring-grafana
  namespace: kube-system
spec:
  # On production clusters, consider setting up auth for grafana, and
  # exposing Grafana either using a LoadBalancer or a public IP.
  # type: LoadBalancer
  ports:
    - port: 80
      targetPort: 3000
  selector:
    k8s-app: influxGrafana

>>
