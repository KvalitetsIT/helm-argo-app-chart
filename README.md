## Argocd helm chart
### Add helm-repository
```console
helm repo add KvalitetsIT https://raw.githubusercontent.com/KvalitetsIT/helm-repo/master/
helm repo update
```

### Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release kvalitetsit/argoapps
```

### Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration
To illustrate properties inside objects in lists, an `[]` is added to show that all elements in the list has following property. For example `projects[].description` here we have a list `projects`, and for each element in the list, there is a `description` property.

### Common
Theese properties are both used in projects and applications - And should always be filed

| Value                                 | Description                                         | Valuetype         |
| -----                                 | -----------                                         | -----------       |
| `server`                              | server for allowed destinations                     | `<string>`        |
| `namespaceArgo`                       | What namespace to create the entities               | `<string>`        |

### Argo projects

| Value                                           | Description                                                        | Valuetype                   |
|-------------------------------------------------|--------------------------------------------------------------------|-----------------------------|
| `projects`                                      | List of projects                                                   | `<list<obj>>`               |
| `projects[].description`                        | description of project                                             | `<string>`                  |
| `projects[].sources`                            | Sourcerepositories                                                 | `<list<string>>`            |
| `projects[].destinations`                       | List of allowed destinationts                                      | `<string>`                  |
| `projects[].destinations[].namespace`           | namespace of allowed dest                                          | `<string>`                  |
| `projects[].destinations[].server`              | server of allowed dest                                             | `<string>`                  |
| `projects[].destinations[].name  `              | name of allowed dest                                               | `<string>`                  |
| `projects[].clusterResourceWhitelist`           | cluster resource whitelist                                         | `<list<string>>`            |
| `projects[].clusterResourceWhitelist[].group`   | K8S API group                                                      | `<string>`                  |
| `projects[].clusterResourceWhitelist[].kind`    | K8S API kind                                                       | `<string>`                  |
| `projects[].namespaceResourceBlacklist`         | namespace resource blacklist                                       | `<list<string>>`            |
| `projects[].namespaceResourceBlacklist[].group` | K8S API group                                                      | `<string>`                  |
| `projects[].namespaceResourceBlacklist[].kind`  | K8S API kind                                                       | `<string>`                  |
| `projects[].namespaceResourceWhitelist`         | namespace resource whitelist                                       | `<list<string>>`            |
| `projects[].namespaceResourceWhitelist[].group` | K8S API group                                                      | `<string>`                  |
| `projects[].namespaceResourceWhitelist[].kind`  | K8S API kind                                                       | `<string>`                  |
| `projects[].ignored`                            | kinds of orphanedressources to ignore                              | `<list<string>>`            |
| `projects[].warnignored`                        | If `true` a warning will be displayed if orphanedressources exists | `<bool>` (default: `true`)  |
| `projects[].orphanedResources.disable`          | If `true` orphanedressources check is disabled                     | `<bool>` (default: `false`) |


### Argo applications

| Value                                 | Description                                                             | Valuetype         |
| -----                                 | -----------                                                             | -----------       |
| `repoUrl`                             | Gitrepo the application should be created from                          | `<git-repo-url>`  |
| `namespace`                           | Default namespace for destination                                       | `<string>`        |
| `project`                             | What project should this app be created on                              | `<string>`        |
| `applications`                        | List containing applications to create                                  | `<list<obj>>`     |
| `applications[].namespace`            | Namespace for destination                                               | `<string>`        |
| `applications[].valueFiles`           | List with values-files to use for application                           | `<string>`        |
| `applications[].kustomize`            | If set to `true` or an object, the application is deployed as a Kustomize app. If an object is provided, it will be used as Kustomize options. | `<bool>` or `<obj>` |
| `applications[].path`                 | path from root to application-folder                                    | `<string>`        |
| `applications[].targetRevision`       | What branch should be used                                              | `<string>`        |
| `applications[].sync`                 | If `true` an `automated` syncPolicy is added - Argo will sync automatically | `<bool>`        |
| `applications[].createNamespace`      | Auto create namesapce                                                   | `<bool>`          |
| `applications[].ignoreDifferences`    | [Ignore some differences](https://argoproj.github.io/argo-cd/user-guide/diffing/) | `<list<obj>>`             |



## Values example
```yaml

# Common values
server: https://kubernetes.default.svc
namespaceArgo: infrastructure

# Projects
projects:
  infrastructure: #name of project
    description: Some description
    sources:
      - git@github.com:some/repository-k8s.git
    destinations:
      - namespace: infrastructure
        server: https://kubernetes.default.svc
      - namespace: longhorn-system
        server: https://kubernetes.default.svc
      - namespace: kube-system
        server: https://kubernetes.default.svc
      - namespace: test-kunde
        server: https://kubernetes.default.svc
    clusterResourceWhitelist:
      - group: "*"
        kind: "*"
    namespaceResourceWhitelist:
      - group: "*"
        kind: "*"

    ignored:
      - Secret
      - Application
      - Role
      - RoleBinding
      - AppProject
    warnignored: true

# Applications
namespace: somenamespace
repoUrl: git@github.com:some/repo-k8s.git
project: infrastructure
applications:
  kithosting-infrastructure-applications: #name of application
    path: deployment/apps/infrastructure
    targetRevision: master
    sync: false
    valueFiles:
      - values.yaml
      - values-test.yaml
    namespace: infrastructure
    ignoreDifferences:
    - group: apps
      kind: Deployment
      jsonPointers:
      - /spec/replicas

```
