#!/bin/sh

nvidia_setup_dashboard_monitor(){
  curl -sLfO https://github.com/NVIDIA/dcgm-exporter/raw/main/grafana/dcgm-exporter-dashboard.json
  oc create configmap nvidia-dcgm-exporter-dashboard -n openshift-config-managed --from-file=dcgm-exporter-dashboard.json || true
  oc label configmap nvidia-dcgm-exporter-dashboard -n openshift-config-managed "console.openshift.io/dashboard=true" --overwrite
  oc label configmap nvidia-dcgm-exporter-dashboard -n openshift-config-managed "console.openshift.io/odc-dashboard=true" --overwrite
  oc -n openshift-config-managed get cm nvidia-dcgm-exporter-dashboard --show-labels
  rm dcgm-exporter-dashboard.json
}

nvidia_setup_dashboard_admin(){
  helm repo add rh-ecosystem-edge https://rh-ecosystem-edge.github.io/console-plugin-nvidia-gpu || true
  helm repo update
  helm upgrade --install -n nvidia-gpu-operator console-plugin-nvidia-gpu rh-ecosystem-edge/console-plugin-nvidia-gpu

  oc get consoles.operator.openshift.io cluster --output=jsonpath="{.spec.plugins}" || true
  oc patch consoles.operator.openshift.io cluster --patch '{ "spec": { "plugins": ["console-plugin-nvidia-gpu"] } }' --type=merge || true
  oc patch consoles.operator.openshift.io cluster --patch '[{"op": "add", "path": "/spec/plugins/-", "value": "console-plugin-nvidia-gpu" }]' --type=json || true
  oc patch clusterpolicies.nvidia.com gpu-cluster-policy --patch '{ "spec": { "dcgmExporter": { "config": { "name": "console-plugin-nvidia-gpu" } } } }' --type=merge || true
  oc -n nvidia-gpu-operator get all -l app.kubernetes.io/name=console-plugin-nvidia-gpu
}

nvidia_setup_mig_config(){
  MIG_MODE=${1:-single}
  MIG_CONFIG=${1:-all-1g.5gb}

  ocp_aws_create_gpu_machineset p4d.24xlarge

  oc apply -k components/operators/gpu-operator-certified/instance/overlays/mig-"${MIG_MODE}"

  oc label node \
    -l node-role.kubernetes.io/gpu \
    nvidia.com/mig.config="$MIG_CONFIG" --overwrite
}
