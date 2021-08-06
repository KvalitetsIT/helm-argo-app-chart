## Configuration
To illustrate properties inside objects in lists, an `[]` is added to show that all elements in the list has following property. For example `projects[].description` here we have a list `projects`, and for each element in the list, there is a `description` property.

### Common
Theese properties are both used in projects and applications - And should always be filed

| Value                                 | Description                                         | Valuetype         |  
| -----                                 | -----------                                         | -----------       |
| `server`                              | server for allowed destinations                     | `<string>`        |
| `namespaceArgo`                       | What namespace to create the entities               | `<string>`        |

### Argo projects

| Value                                 | Description                         | Valuetype                   |
| -----                                 | -----------                         | -----------                 |
| `projects`                            | List of projects                    | `<list<obj>>`               |
| `projects[].description`              | description of project              | `<string>`                  |
| `projects[].sources`                  | Sourcerepositories                  | `<list<string>>`            |
| `projects[].destinations`             | List of allowed destinationts       | `<string>`                  |
| `projects[].destinations[].namespace` | namespace of allowed dest           | `<string>`                  |
| `projects[].destinations[].server`    | server of allowed dest              | `<string>`                  |
| `projects[].ignored`                  | kinds of Ignored orphanedressources | `<list<string>>`            |
| `warnignored`                         |                                     | `<bool>`                    |

### Argo applications

| Value                                 | Description                                         | Valuetype         |  
| -----                                 | -----------                                         | -----------       |
| `repoUrl`                             | Gitrepo the application should be created from      | `<git-repo-url>`  |
| `namespace`                           | Default namespace for destination                   | `<string>`        |
| `project`                             | What project should this app be created on          | `<string>`        |
| `applications`                        | List containing applications to create              | `<list<obj>>`     |
| `applications[].namespace`            | Namespace for destination                           | `<string>`        |
| `applications[].valueFiles`           | List with values-files to use for application       | `<string>`        |
| `applications[].path`                 | path from root to application-folder                | `<string>`        |
| `applications[].targetRevision`       | What branch should be used                          | `<string>`        |
| `applications[].sync`                 |                                                     | `<string>`        |
| `applications[].createNamespace`      | Auto create namesapce                               | `<bool>`          |
| `applications[].ignoreDifferences`    |                                                     | `<?>`             |



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
    valueFiles:
      - values.yaml
      - values-test.yaml
    namespace: infrastructure

```
