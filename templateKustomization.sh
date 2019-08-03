#!/usr/bin/env bash
# Output the kustomization file

cat <<EOF >kustomization.yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: default
resources:
$(ls k8s/ | xargs -n1 -I{} echo "  - k8s/{}")
images:
  - name: auto-ssl # match images with this name
    newName: ${DOCKER_REPO}/auto-ssl # override the name
    newTag: master # override the tag
  - name: skelly
    newName: hashicorp/http-echo
    newTag: latest
EOF
