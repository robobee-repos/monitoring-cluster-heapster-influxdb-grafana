influxdb-service-yaml(parent, vars) ::= <<
apiVersion: v1
kind: Service
metadata:
  name: monitoring-influxdb
  namespace: kube-system
spec: 
  ports: 
    - name: http
      port: 8083
      targetPort: 8083
    - name: api
      port: 8086
      targetPort: 8086
  selector: 
    k8s-app: influxGrafana

>>
