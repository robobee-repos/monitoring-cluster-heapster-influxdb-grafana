influxdb-grafana-controller-yaml(parent, vars) ::= <<
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: monitoring-influxdb-grafana-<parent.influxGrafanaVersion>
  namespace: kube-system
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    k8s-app: influxGrafana
    version: <parent.influxGrafanaVersion>
  template:
    metadata:
      labels:
        k8s-app: influxGrafana
        version: <parent.influxGrafanaVersion>
        kubernetes.io/cluster-service: "true"
      annotations:
        scheduler.alpha.kubernetes.io/critical-pod: ''
        scheduler.alpha.kubernetes.io/tolerations: '[{"key":"CriticalAddonsOnly", "operator":"Exists"}]'
    spec:
      containers:
        - image: gcr.io/google_containers/heapster-influxdb-amd64:<parent.heapsterInfluxdbVersion>
          name: influxdb
          resources:
            # keep request = limit to keep this container in guaranteed class
            limits:
              cpu: 100m
              memory: 500Mi
            requests:
              cpu: 100m
              memory: 500Mi
          ports:
            - containerPort: 8083
            - containerPort: 8086
          volumeMounts:
          - name: influxdb-persistent-storage
            mountPath: /data
        - image: gcr.io/google_containers/heapster-grafana-amd64:<parent.heapsterGrafanaVersion>
          name: grafana
          env:
          resources:
            # keep request = limit to keep this container in guaranteed class
            limits:
              cpu: 100m
              memory: 100Mi
            requests:
              cpu: 100m
              memory: 100Mi
          env:
            # This variable is required to setup templates in Grafana.
            - name: INFLUXDB_SERVICE_URL
              value: http://monitoring-influxdb:8086
              # The following env variables are required to make Grafana accessible via
              # the kubernetes api-server proxy. On production clusters, we recommend
              # removing these env variables, setup auth for grafana, and expose the grafana
              # service using a LoadBalancer or a public IP.
            - name: GF_AUTH_BASIC_ENABLED
              value: "false"
            - name: GF_AUTH_ANONYMOUS_ENABLED
              value: "true"
            - name: GF_AUTH_ANONYMOUS_ORG_ROLE
              value: Admin
            - name: GF_SERVER_ROOT_URL
              value: /api/v1/proxy/namespaces/kube-system/services/monitoring-grafana/
          volumeMounts:
          - name: grafana-persistent-storage
            mountPath: /var
      volumes:
      - name: influxdb-persistent-storage
        emptyDir: {}
      - name: grafana-persistent-storage
        emptyDir: {}

>>